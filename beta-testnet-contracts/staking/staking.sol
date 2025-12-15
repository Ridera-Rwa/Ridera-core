// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

interface IYieldVault {
    function getCycleAPY(uint256 cycleId) external view returns (uint256);
    function lastProcessedCycle() external view returns (uint256);
    function isCycleProcessed(uint256 cycleId) external view returns (bool);
}

/**
 * @title EnhancedStakingV2
 * @notice Multi-deposit staking with lock periods, early unlock fees, and reward distribution
 * @dev Each stake creates an independent deposit - NOT merged like V1
 */
contract EnhancedStakingV2 is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    
    // ============= STRUCTS =============
    
    struct Deposit {
        uint256 id;
        uint256 amount;
        uint256 lockedUntil;
        uint256 lockOptionId;
        uint256 depositedAt;
        uint256 pendingRewards;
        bool active;
    }
    
    struct LockOption {
        uint256 durationDays;
        uint256 boostBps;      // Boost in basis points (10000 = 1.0x)
        uint256 earlyFeeBps;   // Early unlock fee in basis points
        bool active;
    }
    
    struct CycleDistribution {
        uint256 cycleId;
        uint256 totalReward;
        uint256 totalWeightedStake;
        uint256 distributedAt;
        address distributedBy;
    }
    
    // ============= STATE =============
    
    IERC20 public immutable stakingToken;
    IYieldVault public yieldVault;
    
    uint256 public totalStaked;
    uint256 public minStakeAmount = 1 * 1e18;  // 1 RDRT minimum
    uint256 public maxDepositsPerUser = 50;     // Gas protection
    uint256 public callerReward = 10 * 1e18;   // 10 RDRT for distribute caller
    uint256 public lastDistributedCycle;
    uint256 private nextDepositId = 1;
    
    address public treasury = 0x399a9e066B659B4A0506d41B7B437A7865F2a448;
    
    // User deposits - ARRAY for multi-deposit support
    mapping(address => Deposit[]) public userDeposits;
    
    // Lock options
    LockOption[] public lockOptions;
    
    // Active stakers tracking for reward distribution
    address[] public activeStakers;
    mapping(address => bool) public isActiveStaker;
    mapping(address => uint256) public stakerIndex;
    
    // Pending rewards per user
    mapping(address => uint256) public pendingRewards;
    
    // Cycle distribution history
    mapping(uint256 => CycleDistribution) public cycleDistributions;
    
    // ============= EVENTS =============
    
    event Staked(
        address indexed user,
        uint256 indexed depositId,
        uint256 amount,
        uint256 lockOption,
        uint256 lockedUntil,
        uint256 boostBps
    );
    
    event Unstaked(
        address indexed user,
        uint256 indexed depositId,
        uint256 amount
    );
    
    event EarlyUnstaked(
        address indexed user,
        uint256 indexed depositId,
        uint256 amount,
        uint256 fee
    );
    
    event LockExtended(
        address indexed user,
        uint256 indexed depositId,
        uint256 newLockOption,
        uint256 newLockedUntil
    );
    
    event RewardsDistributed(
        uint256 indexed cycleId,
        uint256 totalReward,
        uint256 stakerCount,
        address indexed caller
    );
    
    event RewardClaimed(
        address indexed user,
        uint256 amount
    );
    
    event CallerRewarded(
        address indexed caller,
        uint256 reward
    );
    
    // ============= CONSTRUCTOR =============
    
    constructor(
        address _stakingToken,
        address initialOwner
    ) Ownable(initialOwner) {
        stakingToken = IERC20(_stakingToken);
        
        // Initialize lock options with early unlock fees
        // Flexible - no lock, no boost, no fee
        lockOptions.push(LockOption({
            durationDays: 0,
            boostBps: 10000,  // 1.0x
            earlyFeeBps: 0,
            active: true
        }));
        
        // 1 Month - 2% boost, 0.1% early fee
        lockOptions.push(LockOption({
            durationDays: 30,
            boostBps: 10200,  // 1.02x
            earlyFeeBps: 10,  // 0.1%
            active: true
        }));
        
        // 3 Months - 5% boost, 0.3% early fee
        lockOptions.push(LockOption({
            durationDays: 90,
            boostBps: 10500,  // 1.05x
            earlyFeeBps: 30,  // 0.3%
            active: true
        }));
        
        // 6 Months - 8% boost, 0.6% early fee
        lockOptions.push(LockOption({
            durationDays: 180,
            boostBps: 10800,  // 1.08x
            earlyFeeBps: 60,  // 0.6%
            active: true
        }));
        
        // 1 Year - 10% boost, 1.2% early fee
        lockOptions.push(LockOption({
            durationDays: 365,
            boostBps: 11000,  // 1.1x
            earlyFeeBps: 120, // 1.2%
            active: true
        }));
    }
    
    // ============= STAKING FUNCTIONS =============
    
    /**
     * @notice Stake tokens - creates a NEW independent deposit each time
     * @param amount Amount of tokens to stake
     * @param lockOptionId Lock option index (0=flexible, 1=30d, 2=90d, 3=180d, 4=365d)
     */
    function stake(uint256 amount, uint256 lockOptionId) external nonReentrant {
        require(amount >= minStakeAmount, "Below minimum stake");
        require(lockOptionId < lockOptions.length, "Invalid lock option");
        require(lockOptions[lockOptionId].active, "Lock option disabled");
        require(userDeposits[msg.sender].length < maxDepositsPerUser, "Max deposits reached");
        
        // Transfer tokens
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        
        // Calculate lock time
        LockOption memory lockOpt = lockOptions[lockOptionId];
        uint256 lockedUntil = lockOpt.durationDays > 0 
            ? block.timestamp + (lockOpt.durationDays * 1 days) 
            : 0;
        
        // Create new deposit
        uint256 depositId = nextDepositId++;
        userDeposits[msg.sender].push(Deposit({
            id: depositId,
            amount: amount,
            lockedUntil: lockedUntil,
            lockOptionId: lockOptionId,
            depositedAt: block.timestamp,
            pendingRewards: 0,
            active: true
        }));
        
        totalStaked += amount;
        
        // Add to active stakers if not already
        if (!isActiveStaker[msg.sender]) {
            stakerIndex[msg.sender] = activeStakers.length;
            activeStakers.push(msg.sender);
            isActiveStaker[msg.sender] = true;
        }
        
        emit Staked(
            msg.sender,
            depositId,
            amount,
            lockOptionId,
            lockedUntil,
            lockOpt.boostBps
        );
    }
    
    /**
     * @notice Unstake a specific deposit (must be unlocked)
     * @param depositIndex Index in user's deposits array
     */
    function unstake(uint256 depositIndex) external nonReentrant {
        require(depositIndex < userDeposits[msg.sender].length, "Invalid deposit index");
        
        Deposit storage deposit = userDeposits[msg.sender][depositIndex];
        require(deposit.active, "Deposit not active");
        require(deposit.lockedUntil <= block.timestamp, "Still locked - use earlyUnstake");
        
        uint256 amount = deposit.amount;
        uint256 depositId = deposit.id;
        
        // Mark as inactive
        deposit.active = false;
        deposit.amount = 0;
        totalStaked -= amount;
        
        // Check if user still has active deposits
        _checkAndRemoveStaker(msg.sender);
        
        // Transfer tokens
        stakingToken.safeTransfer(msg.sender, amount);
        
        emit Unstaked(msg.sender, depositId, amount);
    }
    
    /**
     * @notice Partially unstake from a specific deposit
     * @param depositIndex Index in user's deposits array
     * @param amount Amount to unstake
     */
    function unstakePartial(uint256 depositIndex, uint256 amount) external nonReentrant {
        require(depositIndex < userDeposits[msg.sender].length, "Invalid deposit index");
        
        Deposit storage deposit = userDeposits[msg.sender][depositIndex];
        require(deposit.active, "Deposit not active");
        require(deposit.lockedUntil <= block.timestamp, "Still locked");
        require(amount > 0 && amount <= deposit.amount, "Invalid amount");
        
        uint256 depositId = deposit.id;
        
        deposit.amount -= amount;
        totalStaked -= amount;
        
        // If fully unstaked, mark inactive
        if (deposit.amount == 0) {
            deposit.active = false;
            _checkAndRemoveStaker(msg.sender);
        }
        
        stakingToken.safeTransfer(msg.sender, amount);
        
        emit Unstaked(msg.sender, depositId, amount);
    }
    
    /**
     * @notice Early unstake with fee penalty
     * @param depositIndex Index in user's deposits array
     */
    function earlyUnstake(uint256 depositIndex) external nonReentrant {
        require(depositIndex < userDeposits[msg.sender].length, "Invalid deposit index");
        
        Deposit storage deposit = userDeposits[msg.sender][depositIndex];
        require(deposit.active, "Deposit not active");
        require(deposit.lockedUntil > block.timestamp, "Already unlocked - use normal unstake");
        
        uint256 amount = deposit.amount;
        uint256 depositId = deposit.id;
        LockOption memory lockOpt = lockOptions[deposit.lockOptionId];
        
        // Calculate fee
        uint256 fee = (amount * lockOpt.earlyFeeBps) / 10000;
        uint256 userReceives = amount - fee;
        
        // Mark as inactive
        deposit.active = false;
        deposit.amount = 0;
        totalStaked -= amount;
        
        // Check if user still has active deposits
        _checkAndRemoveStaker(msg.sender);
        
        // Transfer fee to treasury
        if (fee > 0) {
            stakingToken.safeTransfer(treasury, fee);
        }
        
        // Transfer remaining to user
        stakingToken.safeTransfer(msg.sender, userReceives);
        
        emit EarlyUnstaked(msg.sender, depositId, amount, fee);
    }
    
    /**
     * @notice Unstake all flexible (unlocked) deposits at once
     */
    function unstakeAllFlexible() external nonReentrant {
        uint256 totalToUnstake = 0;
        Deposit[] storage deposits = userDeposits[msg.sender];
        
        for (uint256 i = 0; i < deposits.length; i++) {
            if (deposits[i].active && deposits[i].lockedUntil <= block.timestamp) {
                totalToUnstake += deposits[i].amount;
                deposits[i].active = false;
                deposits[i].amount = 0;
                emit Unstaked(msg.sender, deposits[i].id, deposits[i].amount);
            }
        }
        
        require(totalToUnstake > 0, "No unlocked deposits");
        
        totalStaked -= totalToUnstake;
        _checkAndRemoveStaker(msg.sender);
        
        stakingToken.safeTransfer(msg.sender, totalToUnstake);
    }
    
    /**
     * @notice Extend lock period for a deposit
     * @param depositIndex Index in user's deposits array
     * @param newLockOptionId New lock option (must be >= current)
     */
    function extendLock(uint256 depositIndex, uint256 newLockOptionId) external {
        require(depositIndex < userDeposits[msg.sender].length, "Invalid deposit index");
        require(newLockOptionId < lockOptions.length, "Invalid lock option");
        require(lockOptions[newLockOptionId].active, "Lock option disabled");
        
        Deposit storage deposit = userDeposits[msg.sender][depositIndex];
        require(deposit.active, "Deposit not active");
        require(newLockOptionId > deposit.lockOptionId, "Must increase lock duration");
        
        LockOption memory newLockOpt = lockOptions[newLockOptionId];
        uint256 newLockedUntil = block.timestamp + (newLockOpt.durationDays * 1 days);
        
        deposit.lockOptionId = newLockOptionId;
        deposit.lockedUntil = newLockedUntil;
        
        emit LockExtended(msg.sender, deposit.id, newLockOptionId, newLockedUntil);
    }
    
    // ============= REWARD DISTRIBUTION =============
    
    /**
     * @notice Distribute rewards for the next pending cycle - PERMISSIONLESS
     * @dev Anyone can call this and earn 10 RDRT caller reward
     * @return cycleId The cycle that was processed
     * @return totalReward Total rewards distributed
     */
    function distributeRewards() external nonReentrant returns (uint256 cycleId, uint256 totalReward) {
        require(address(yieldVault) != address(0), "YieldVault not set");
        
        // Get next cycle to distribute
        uint256 nextCycle = lastDistributedCycle + 1;
        require(yieldVault.isCycleProcessed(nextCycle), "Cycle not processed by YieldVault");
        
        // Get APY for this cycle
        uint256 apyBps = yieldVault.getCycleAPY(nextCycle);
        require(apyBps > 0, "Invalid APY");
        
        // Calculate total reward for this cycle
        // Daily reward = (totalStaked * APY) / 365 / 10000
        totalReward = (totalStaked * apyBps) / 365 / 10000;
        
        // Calculate total weighted stake
        uint256 totalWeightedStake = 0;
        for (uint256 i = 0; i < activeStakers.length; i++) {
            address staker = activeStakers[i];
            totalWeightedStake += _getUserWeightedStake(staker);
        }
        
        // Distribute rewards proportionally
        if (totalWeightedStake > 0 && totalReward > 0) {
            for (uint256 i = 0; i < activeStakers.length; i++) {
                address staker = activeStakers[i];
                uint256 userWeightedStake = _getUserWeightedStake(staker);
                
                if (userWeightedStake > 0) {
                    uint256 userReward = (totalReward * userWeightedStake) / totalWeightedStake;
                    pendingRewards[staker] += userReward;
                }
            }
        }
        
        // Record distribution
        cycleDistributions[nextCycle] = CycleDistribution({
            cycleId: nextCycle,
            totalReward: totalReward,
            totalWeightedStake: totalWeightedStake,
            distributedAt: block.timestamp,
            distributedBy: msg.sender
        });
        
        lastDistributedCycle = nextCycle;
        
        // Pay caller reward (10 RDRT)
        if (callerReward > 0) {
            stakingToken.safeTransfer(msg.sender, callerReward);
            emit CallerRewarded(msg.sender, callerReward);
        }
        
        emit RewardsDistributed(nextCycle, totalReward, activeStakers.length, msg.sender);
        
        return (nextCycle, totalReward);
    }
    
    /**
     * @notice Claim accumulated rewards
     */
    function claimRewards() external nonReentrant {
        uint256 rewards = pendingRewards[msg.sender];
        require(rewards > 0, "No rewards to claim");
        
        pendingRewards[msg.sender] = 0;
        stakingToken.safeTransfer(msg.sender, rewards);
        
        emit RewardClaimed(msg.sender, rewards);
    }
    
    // ============= VIEW FUNCTIONS =============
    
    /**
     * @notice Get all active deposits for a user
     */
    function getActiveDeposits(address user) external view returns (Deposit[] memory) {
        Deposit[] storage allDeposits = userDeposits[user];
        
        // Count active deposits
        uint256 activeCount = 0;
        for (uint256 i = 0; i < allDeposits.length; i++) {
            if (allDeposits[i].active) activeCount++;
        }
        
        // Build active deposits array
        Deposit[] memory active = new Deposit[](activeCount);
        uint256 j = 0;
        for (uint256 i = 0; i < allDeposits.length; i++) {
            if (allDeposits[i].active) {
                active[j] = allDeposits[i];
                j++;
            }
        }
        
        return active;
    }
    
    /**
     * @notice Get user's total staked amount across all deposits
     */
    function getTotalStaked(address user) external view returns (uint256) {
        uint256 total = 0;
        Deposit[] storage deposits = userDeposits[user];
        for (uint256 i = 0; i < deposits.length; i++) {
            if (deposits[i].active) {
                total += deposits[i].amount;
            }
        }
        return total;
    }
    
    /**
     * @notice Get user's flexible (unlocked) balance
     */
    function getFlexibleBalance(address user) external view returns (uint256) {
        uint256 total = 0;
        Deposit[] storage deposits = userDeposits[user];
        for (uint256 i = 0; i < deposits.length; i++) {
            if (deposits[i].active && deposits[i].lockedUntil <= block.timestamp) {
                total += deposits[i].amount;
            }
        }
        return total;
    }
    
    /**
     * @notice Get user's locked balance
     */
    function getLockedBalance(address user) external view returns (uint256) {
        uint256 total = 0;
        Deposit[] storage deposits = userDeposits[user];
        for (uint256 i = 0; i < deposits.length; i++) {
            if (deposits[i].active && deposits[i].lockedUntil > block.timestamp) {
                total += deposits[i].amount;
            }
        }
        return total;
    }
    
    /**
     * @notice Get weighted average boost for user
     */
    function getUserBoostBps(address user) external view returns (uint256) {
        uint256 totalWeighted = 0;
        uint256 totalAmount = 0;
        
        Deposit[] storage deposits = userDeposits[user];
        for (uint256 i = 0; i < deposits.length; i++) {
            if (deposits[i].active) {
                uint256 boost = lockOptions[deposits[i].lockOptionId].boostBps;
                totalWeighted += deposits[i].amount * boost;
                totalAmount += deposits[i].amount;
            }
        }
        
        if (totalAmount == 0) return 10000; // 1.0x default
        return totalWeighted / totalAmount;
    }
    
    /**
     * @notice Calculate early unlock fee for a deposit
     */
    function calculateEarlyFee(address user, uint256 depositIndex) 
        external view 
        returns (uint256 fee, uint256 userReceives) 
    {
        require(depositIndex < userDeposits[user].length, "Invalid index");
        
        Deposit memory deposit = userDeposits[user][depositIndex];
        if (!deposit.active || deposit.lockedUntil <= block.timestamp) {
            return (0, deposit.amount);
        }
        
        LockOption memory lockOpt = lockOptions[deposit.lockOptionId];
        fee = (deposit.amount * lockOpt.earlyFeeBps) / 10000;
        userReceives = deposit.amount - fee;
    }
    
    /**
     * @notice Get deposit info by index
     */
    function getDepositInfo(address user, uint256 depositIndex) external view returns (
        uint256 id,
        uint256 amount,
        uint256 lockedUntil,
        uint256 lockOptionId,
        uint256 boostBps,
        uint256 earlyFeeBps,
        bool isLocked,
        bool active
    ) {
        require(depositIndex < userDeposits[user].length, "Invalid index");
        
        Deposit memory dep = userDeposits[user][depositIndex];
        LockOption memory opt = lockOptions[dep.lockOptionId];
        
        return (
            dep.id,
            dep.amount,
            dep.lockedUntil,
            dep.lockOptionId,
            opt.boostBps,
            opt.earlyFeeBps,
            dep.lockedUntil > block.timestamp,
            dep.active
        );
    }
    
    /**
     * @notice Get all lock options
     */
    function getLockOptions() external view returns (LockOption[] memory) {
        return lockOptions;
    }
    
    /**
     * @notice Get active staker count
     */
    function getActiveStakerCount() external view returns (uint256) {
        return activeStakers.length;
    }
    
    /**
     * @notice Check if rewards can be distributed
     */
    function canDistribute() external view returns (bool, uint256 nextCycle) {
        if (address(yieldVault) == address(0)) return (false, 0);
        
        nextCycle = lastDistributedCycle + 1;
        bool canDist = yieldVault.isCycleProcessed(nextCycle);
        
        return (canDist, nextCycle);
    }
    
    /**
     * @notice Get number of pending cycles to distribute
     */
    function getPendingCyclesCount() external view returns (uint256) {
        if (address(yieldVault) == address(0)) return 0;
        
        uint256 vaultLastCycle = yieldVault.lastProcessedCycle();
        if (vaultLastCycle <= lastDistributedCycle) return 0;
        
        return vaultLastCycle - lastDistributedCycle;
    }
    
    // ============= INTERNAL FUNCTIONS =============
    
    function _getUserWeightedStake(address user) internal view returns (uint256) {
        uint256 weighted = 0;
        Deposit[] storage deposits = userDeposits[user];
        
        for (uint256 i = 0; i < deposits.length; i++) {
            if (deposits[i].active) {
                uint256 boost = lockOptions[deposits[i].lockOptionId].boostBps;
                weighted += (deposits[i].amount * boost) / 10000;
            }
        }
        
        return weighted;
    }
    
    function _checkAndRemoveStaker(address user) internal {
        // Check if user still has any active deposits
        bool hasActive = false;
        Deposit[] storage deposits = userDeposits[user];
        
        for (uint256 i = 0; i < deposits.length; i++) {
            if (deposits[i].active) {
                hasActive = true;
                break;
            }
        }
        
        // Remove from active stakers if no active deposits
        if (!hasActive && isActiveStaker[user]) {
            uint256 index = stakerIndex[user];
            uint256 lastIndex = activeStakers.length - 1;
            
            if (index != lastIndex) {
                address lastStaker = activeStakers[lastIndex];
                activeStakers[index] = lastStaker;
                stakerIndex[lastStaker] = index;
            }
            
            activeStakers.pop();
            isActiveStaker[user] = false;
            delete stakerIndex[user];
        }
    }
    
    // ============= ADMIN FUNCTIONS =============
    
    function setYieldVault(address _vault) external onlyOwner {
        yieldVault = IYieldVault(_vault);
    }
    
    function setTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), "Invalid treasury");
        treasury = _treasury;
    }
    
    function setMinStakeAmount(uint256 _min) external onlyOwner {
        minStakeAmount = _min;
    }
    
    function setMaxDepositsPerUser(uint256 _max) external onlyOwner {
        maxDepositsPerUser = _max;
    }
    
    function setCallerReward(uint256 _reward) external onlyOwner {
        callerReward = _reward;
    }
    
    function addLockOption(
        uint256 durationDays,
        uint256 boostBps,
        uint256 earlyFeeBps
    ) external onlyOwner {
        lockOptions.push(LockOption({
            durationDays: durationDays,
            boostBps: boostBps,
            earlyFeeBps: earlyFeeBps,
            active: true
        }));
    }
    
    function updateLockOption(
        uint256 index,
        uint256 durationDays,
        uint256 boostBps,
        uint256 earlyFeeBps,
        bool active
    ) external onlyOwner {
        require(index < lockOptions.length, "Invalid index");
        lockOptions[index] = LockOption({
            durationDays: durationDays,
            boostBps: boostBps,
            earlyFeeBps: earlyFeeBps,
            active: active
        });
    }
    
    function emergencyWithdraw(address token, uint256 amount) external onlyOwner {
        IERC20(token).safeTransfer(owner(), amount);
    }
}
