// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RideraDailyMint is ERC20, Ownable {
    uint256 public dailyAmount = 550 * 1e18; 
    uint256 public cooldown = 24 hours;

    mapping(address => uint256) public lastClaim;

    constructor() ERC20("Ridera Test Token", "RDRT") Ownable(msg.sender) {}

    function claimDaily() external {
        require(
            block.timestamp >= lastClaim[msg.sender] + cooldown,
            "Already claimed. Try again later."
        );

        lastClaim[msg.sender] = block.timestamp;
        _mint(msg.sender, dailyAmount);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function setDailyAmount(uint256 amount) external onlyOwner {
        dailyAmount = amount;
    }

    function setCooldown(uint256 timeSeconds) external onlyOwner {
        cooldown = timeSeconds;
    }
}
