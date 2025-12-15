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
