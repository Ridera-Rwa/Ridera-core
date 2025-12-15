// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ProofRegistryWithSigner is Ownable {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    address public signer; 
    IERC20 public rewardToken;
    uint256 public rewardAmount = 10 * 1e18;
    uint256 public lastCycleId;

    struct Cycle {
        uint256 cycleId;
        uint256 totalSRU;
        uint256 timestamp;
        bytes32 merkleRoot;
    }

    mapping(uint256 => Cycle) public cycles;

    event CycleSubmitted(
        uint256 cycleId,
        uint256 totalSRU,
        uint256 timestamp,
        bytes32 merkleRoot,
        address indexed submitter
    );

    constructor(
        address initialOwner,
        address _signer,
        address _rewardToken
    ) Ownable(initialOwner) {
        signer = _signer;
        rewardToken = IERC20(_rewardToken);
    }

    function updateSigner(address newSigner) external onlyOwner {
        signer = newSigner;
    }

    function updateRewardToken(address newToken) external onlyOwner {
        rewardToken = IERC20(newToken);
    }

    function updateRewardAmount(uint256 newAmount) external onlyOwner {
        rewardAmount = newAmount;
    }

    function submitCycle(
        uint256 cycleId,
        uint256 totalSRU,
        uint256 timestamp,
        bytes32 merkleRoot,
        bytes calldata signature
    ) external {
        require(cycleId > lastCycleId, "Cycle already used or invalid");

        // Create message hash
        bytes32 hash = keccak256(
            abi.encodePacked(cycleId, totalSRU, timestamp, merkleRoot)
        );

        // Convert to Ethereum signed message hash
        bytes32 ethSigned = hash.toEthSignedMessageHash();

        // Verify signer
        address recovered = ethSigned.recover(signature);
        require(recovered == signer, "Invalid signature");

        // Store cycle
        cycles[cycleId] = Cycle({
            cycleId: cycleId,
            totalSRU: totalSRU,
            timestamp: timestamp,
            merkleRoot: merkleRoot
        });

        lastCycleId = cycleId;

        // Reward caller
        require(
            rewardToken.transfer(msg.sender, rewardAmount),
            "Reward transfer failed"
        );

        emit CycleSubmitted(cycleId, totalSRU, timestamp, merkleRoot, msg.sender);
    }
}
