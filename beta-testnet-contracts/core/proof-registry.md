# Proof Registry (Signer-Based)

## Contract
**Name:** ProofRegistryWithSigner  
**Path:** contracts/core/ProofRegistryWithSigner.sol  
**Network:** Base Testnet  
**Status:** Beta
**Ca:** 0x936e406dAD13Aa55ff747e80Bd1D9e630AB1B5d7
---

## Overview
`ProofRegistryWithSigner` is a **testnet proof anchoring contract** used by Ridera
to store verified cycle data on-chain.

Each cycle submission must be **authorized by an off-chain signer**, ensuring that
only validated data (after AI + backend checks) is committed to the blockchain.

---

## Core Concept
- Gig work data is processed off-chain
- A trusted signer approves the cycle payload
- Approved data is submitted on-chain
- The submitter receives a token reward

This design avoids on-chain computation while maintaining **on-chain integrity**.

---

## Cycle Structure
Each submitted cycle contains:

| Field | Description |
|----|------------|
| `cycleId` | Sequential unique identifier |
| `totalSRU` | Aggregated SRU value |
| `timestamp` | Cycle timestamp |
| `merkleRoot` | Merkle root of worker proofs |

---

## Signature Verification
Cycle submissions require a valid ECDSA signature from the authorized signer.

### Signed Payload
keccak256(cycleId, totalSRU, timestamp, merkleRoot)

The hash is converted to an Ethereum Signed Message before verification.

Only submissions signed by the trusted signer address are accepted.

---

## Rewards
- Successful submitters receive a token reward
- Reward is paid from the configured ERC20 token

### Default Reward
- `10 tokens` per valid cycle submission

Reward parameters are configurable by the contract owner.

---

## Owner Controls
The contract owner can:
- Update signer address
- Update reward token
- Update reward amount

These controls are required during beta testing and may be restricted or removed
in mainnet deployments.

---

## Security Notes
- Only increasing `cycleId` values are accepted
- Signature-based authorization prevents unauthorized submissions
- No on-chain validation of SRU or Merkle contents (off-chain responsibility)
- Not audited
- Testnet-only logic

---

## Mainnet Disclaimer
This contract is **for beta/testnet use only**.

Mainnet versions may include:
- Multi-signer or threshold signatures
- Time-based cycle enforcement
- Governance-controlled parameters
- Full audit coverage

