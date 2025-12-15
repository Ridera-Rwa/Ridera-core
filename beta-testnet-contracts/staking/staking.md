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

SRU Engine
↓
ProofRegistry
↓
YieldVault (calculates APY)
↓
EnhancedStakingV2 (distributes rewards)
↓
Users


- YieldVault decides *how much* reward is available
- EnhancedStakingV2 decides *who gets how much*

---

## Staking Model

### Deposits
Each `stake()` call creates a **new deposit**:
- Amount
- Lock option
- Lock expiry
- Boost multiplier

Deposits are **not merged**.

---

### Lock Options
Each lock option defines:
- Lock duration (days)
- Reward boost (basis points)
- Early unlock fee

Example:
| Duration | Boost | Early Fee |
|--------|------|-----------|
| Flexible | 1.0x | 0% |
| 30 days | 1.02x | 0.1% |
| 90 days | 1.05x | 0.3% |
| 180 days | 1.08x | 0.6% |
| 365 days | 1.10x | 1.2% |

---

## Reward Distribution

### Source of Rewards
- APY is read from `YieldVault`
- YieldVault **does not distribute rewards**
- This contract applies APY to total staked value

### Distribution Formula
