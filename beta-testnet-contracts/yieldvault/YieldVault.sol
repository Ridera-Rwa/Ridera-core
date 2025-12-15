// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IProofRegistry {
    function cycles(uint256 cycleId) external view returns (
        uint256 cycleId_,
        uint256 totalSRU,
        uint256 timestamp,
        bytes32 merkleRoot
    );
    function lastCycleId() external view returns (uint256);
}

contract YieldVault is Ownable {
    IERC20 public rewardToken;
    IProofRegistry public proofRegistry;
    
    uint256 public lastProcessedCycle;
    uint256 public callerReward = 10 * 10**18; // 10 RDRT for caller
    
    // Cycle APY data (stored for Staking contract to read)
    struct CycleAPY {
        uint256 cycleId;
        uint256 totalSRU;
        uint256 apyBps;          // APY in basis points (1300 = 13%)
        uint256 processedAt;
        address processedBy;
    }
    
    mapping(uint256 => CycleAPY) public cycleAPYs;
    
    event CycleProcessed(
        uint256 indexed cycleId,
        uint256 totalSRU,
        uint256 apyBps,
        address indexed processedBy
    );
    
    constructor(
        address initialOwner,
        address _rewardToken,
        address _proofRegistry
    ) Ownable(initialOwner) {
        rewardToken = IERC20(_rewardToken);
        proofRegistry = IProofRegistry(_proofRegistry);
        lastProcessedCycle = 0;
    }
    
    /**
     * @notice Calculate APY based on total SRU
     * @dev Returns APY in basis points (1300 = 13%)
     */
    function calculateAPY(uint256 totalSRU) public pure returns (uint256) {
        if (totalSRU <= 500 * 10**18) return 1300;      // 13%
        if (totalSRU <= 1000 * 10**18) return 1200;     // 12%
        if (totalSRU <= 1300 * 10**18) return 1100;     // 11%
        if (totalSRU <= 1400 * 10**18) return 1000;     // 10%
        if (totalSRU <= 1500 * 10**18) return 900;      // 9%
        if (totalSRU <= 1600 * 10**18) return 800;      // 8%
        if (totalSRU <= 1700 * 10**18) return 700;      // 7%
        if (totalSRU <= 1800 * 10**18) return 600;      // 6%
        if (totalSRU <= 1900 * 10**18) return 500;      // 5%
        return 400;                                      // 4% (fixed for 1901+)
    }
    
    /**
     * @notice Process the next cycle - calculate and store APY
     * @dev Anyone can call - caller receives 10 RDRT reward
     */
    function processNextCycle() external returns (uint256 cycleId, uint256 apyBps) {
        uint256 nextCycle = lastProcessedCycle + 1;
        
        // Check if cycle exists in ProofRegistry
        uint256 registryLastCycle = proofRegistry.lastCycleId();
        require(nextCycle <= registryLastCycle, "Cycle not yet in registry");
        
        // Get cycle data from registry
        (, uint256 totalSRU, uint256 timestamp,) = proofRegistry.cycles(nextCycle);
        
        // Verify cycle was actually submitted
        require(timestamp > 0, "Cycle not submitted to registry");
        
        // Calculate APY based on total SRU
        apyBps = calculateAPY(totalSRU);
        
        // Store APY data (Staking contract reads this)
        cycleAPYs[nextCycle] = CycleAPY({
            cycleId: nextCycle,
            totalSRU: totalSRU,
            apyBps: apyBps,
            processedAt: block.timestamp,
            processedBy: msg.sender
        });
        
        // Update last processed cycle
        lastProcessedCycle = nextCycle;
        
        // Reward caller with 10 RDRT
        if (callerReward > 0) {
            rewardToken.transfer(msg.sender, callerReward);
        }
        
        emit CycleProcessed(nextCycle, totalSRU, apyBps, msg.sender);
        
        return (nextCycle, apyBps);
    }
    
    /**
     * @notice Get APY for a specific cycle (called by Staking contract)
     */
    function getCycleAPY(uint256 cycleId) external view returns (uint256) {
        require(cycleAPYs[cycleId].processedAt > 0, "Cycle not processed");
        return cycleAPYs[cycleId].apyBps;
    }
    
    /**
     * @notice Check if cycle is processed
     */
    function isCycleProcessed(uint256 cycleId) external view returns (bool) {
        return cycleAPYs[cycleId].processedAt > 0;
    }
    
    /**
     * @notice Get pending cycles count
     */
    function getPendingCyclesCount() external view returns (uint256) {
        uint256 registryLastCycle = proofRegistry.lastCycleId();
        if (registryLastCycle <= lastProcessedCycle) return 0;
        return registryLastCycle - lastProcessedCycle;
    }
    
    // Admin functions
    function setCallerReward(uint256 _callerReward) external onlyOwner {
        callerReward = _callerReward;
    }
    
    function setProofRegistry(address _proofRegistry) external onlyOwner {
        proofRegistry = IProofRegistry(_proofRegistry);
    }
}
