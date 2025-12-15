# Core Protocol Contracts (Beta)

This directory contains Ridera’s **core protocol smart contracts** used during the
beta/testnet phase.

These contracts focus on **data verification, reward parameter calculation, and
protocol coordination**. They do **not** directly manage user staking or distribute
user rewards.

---

## Included Contracts

### ProofRegistryWithSigner.sol
- Anchors verified cycle data on-chain
- Accepts only signer-authorized submissions
- Stores cycle metadata (SRU totals, timestamps, Merkle roots)

**Role:** On-chain source of truth for verified cycle data

---

### YieldVault.sol
- Reads verified cycle data from ProofRegistry
- Calculates reward parameters (APY) based on total SRU
- Stores APY values per cycle
- Exposes read-only data for downstream contracts

**Important:**  
YieldVault **does NOT distribute rewards** and **does NOT manage staking**.  
It only calculates and stores reward parameters.

---

## Architecture Flow

SRU Engine → ProofRegistry → YieldVault → Staking → Users

- ProofRegistry verifies and stores cycle data
- YieldVault computes reward parameters
- Staking contract applies APY and distributes rewards to users

---

## Design Principles
- Separation of concerns
- Minimal on-chain computation
- No user fund custody in core contracts
- Off-chain computation with on-chain verification

---

## Notes
- Testnet-only contracts
- Subject to change
- Not audited
- Mainnet versions will introduce stricter controls and governance
