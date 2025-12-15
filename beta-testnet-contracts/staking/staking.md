# Enhanced Staking 

## Contract
**Name:** EnhancedStakingV2  
**Path:** contracts/staking/EnhancedStakingV2.sol  
**Network:** Testnet  
**Status:** Beta
**Ca:** 0x46be8561fCf74a2D63AeaE25981aE3F74ad88F8e
---

## Overview
`EnhancedStakingV2` is the **reward distribution and user staking contract** in the Ridera protocol.

Users stake tokens with optional lock periods.  
Rewards are **distributed per cycle** using APY values calculated by `YieldVault`.

This contract:
- Manages user deposits
- Applies lock-based boosts
- Distributes rewards proportionally
- Handles reward claiming

---

## Key Design Principles
- **Multi-deposit staking** (each stake is independent)
- **No reward math hardcoding**
- **External reward parameters** (from YieldVault)
- **Permissionless reward distribution**
- **Separation of calculation and distribution**

---

## Architecture Role

