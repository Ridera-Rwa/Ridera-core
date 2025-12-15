# Yield Vault (Reward Parameter Calculator)

## Contract
**Name:** YieldVault  
**Path:** contracts/core/YieldVault.sol  
**Network:** Testnet  
**Status:** Beta

---

## Overview
`YieldVault` is a **read-only reward parameter engine** in the Ridera protocol.

It does **NOT** distribute rewards and does **NOT** hold or manage user stakes.

Its sole responsibility is to:
- Read verified cycle data from `ProofRegistry`
- Calculate reward parameters (APY) based on total SRU
- Store these parameters on-chain for consumption by the Staking contract

---

## What YieldVault DOES
- Calculates APY based on cycle-level SRU
- Stores APY per cycle
- Exposes read-only getters for downstream contracts
- Incentivizes decentralized processing of cycles

---

## What YieldVault DOES NOT Do
- ❌ Does not manage user deposits
- ❌ Does not calculate individual user rewards
- ❌ Does not distribute staking rewards
- ❌ Does not hold protocol funds (except caller incentive tokens)

---

## Architecture Role
SRU Engine → ProofRegistry → YieldVault → Staking → Users

- ProofRegistry anchors verified cycle data
- YieldVault computes reward parameters
- Staking contract applies APY and distributes rewards to users

---

## APY Calculation
APY is calculated deterministically from total SRU:

| Total SRU | APY |
|---------|-----|
| ≤ 500 | 13% |
| ≤ 1000 | 12% |
| ≤ 1300 | 11% |
| ≤ 1400 | 10% |
| ≤ 1500 | 9% |
| ≤ 1600 | 8% |
| ≤ 1700 | 7% |
| ≤ 1800 | 6% |
| ≤ 1900 | 5% |
| > 1900 | 4% |

APY values are stored in **basis points**.

---

## Cycle Processing
Anyone can process a cycle once it exists in the ProofRegistry.

Processing a cycle:
1. Reads SRU data
2. Computes APY
3. Stores APY on-chain
4. Emits an event

No user-level calculations occur in this contract.

---

## Incentive Model
A small fixed reward is paid to callers to ensure cycles are processed in a
decentralized and timely manner.

This incentive is **not related to staking rewards**.

---

## Consumer Contracts
The following contracts read data from YieldVault:
- Staking contract
- Frontend (read-only)

---

## Security Notes
- Deterministic calculations
- No custody of user funds
- Depends on correctness of ProofRegistry
- Testnet-only
- Not audited

---

## Mainnet Disclaimer
This contract will be refined before mainnet to:
- Harden incentive logic
- Potentially governance-control APY curves
- Add audit protections
