# **Proof Registry**  
### *On-Chain Storage Layer for Verified Mobility Work*  
### *Ridera Protocol — Technical Specification*

---

# **1. Overview**

The **Proof Registry** is Ridera’s immutable on-chain storage layer.  
It stores cryptographic summaries of all verified mobility earnings processed by:

- the **Ridera Oracle** (verification)  
- the **SRU Engine** (standardization)  

Instead of storing every user’s earnings on-chain (which would be expensive), Ridera stores an optimized, trustless representation of each day’s activity through:

- **Merkle Roots**  
- **Cycle IDs**  
- **Total SRU outputs**  
- **Timestamps**  
- **Verification signatures**

This creates a **tamper-proof, publicly auditable history of all real-world work** used to compute yield.

---

# **2. Design Goals**

The Proof Registry achieves:

## **2.1 Immutable Data Integrity**
All SRU calculations map back to verifiable proofs.

## **2.2 Efficient On-Chain Storage**
Only Merkle Roots + summary data are stored.

## **2.3 Auditability**
Anyone can reconstruct and verify a cycle off-chain.

## **2.4 Trustless Yield Computation**
The Yield Vault reads cycle data directly from the Proof Registry.

## **2.5 Privacy Preservation**
No personal or sensitive worker data is ever stored on-chain.

---

# **3. What the Proof Registry Stores**

For each 24-hour cycle, the Proof Registry stores:

| Field | Description |
|------|-------------|
| **cycleId** | Unique identifier (incremental) |
| **merkleRoot** | Hash summarizing all verified worker proofs |
| **totalSRU** | Global SRU generated that day |
| **timestamp** | End of cycle block timestamp |
| **oracleSignature** | Oracle verification signature |
| **dataHash** | Optional metadata for off-chain reconstruction |

This is the canonical source of truth that all other Ridera components depend on.

---

# **4. Proof Lifecycle (How Data Reaches the Registry)**

```
Worker Earnings  
     ↓ submit  
Ridera Oracle (Verification Layer)  
     ↓ verified proofs  
SRU Engine (Standardization Layer)  
     ↓ SRU values + Merkle tree  
Proof Registry (On-Chain Storage)  
     ↓ totalSRU  
Yield Vault (Emission Model)  
     ↓ RDR Rewards  
Staking Contract (Distribution)
```

This lifecycle ensures **real-world work → on-chain yield** happens in a fully traceable pipeline.

---

# **5. Merkle Tree Construction**

The SRU Engine generates a **Merkle Tree** to efficiently compress all submissions for a cycle.

### **5.1 Leaf Nodes**
Each worker's verified SRU entry becomes a leaf node:

```
hash(workerId, platform, region, SRU)
```

(workerId is hashed → no personal info stored)

### **5.2 Tree Formation**
Leaves → hashed upward → produce **Merkle Root**.

### **5.3 Final Output**
The Merkle Root represents the entire day’s verified earning activity.

This root ensures:

- no retroactive modification  
- cheap verification  
- trustless staking emissions  

---

# **6. Cycle Structure**

Each cycle consists of:

```
Cycle {
  cycleId: uint256
  totalSRU: uint256
  merkleRoot: bytes32
  timestamp: uint256
  oracleSignature: bytes
}
```

Stored immutably on-chain.

---

# **7. How Developers Validate a Cycle (Simple)**

A developer or auditor can:

1. Retrieve `merkleRoot` from the Proof Registry  
2. Reconstruct the off-chain Merkle tree from verified data  
3. Verify that each leaf’s hash is included in the tree  
4. Validate totalSRU consistency  

This proves:

- data was not manipulated  
- SRU was computed legitimately  
- emissions were generated correctly  

---

# **8. Interaction With Other Components**

### **8.1 With Oracle**
The Oracle sends:

- verified earnings  
- region/platform metadata  
- worker validation  

### **8.2 With SRU Engine**
The Engine sends:

- computed SRU values  
- final Merkle Root  
- total SRU  

### **8.3 With Yield Vault**
The Yield Vault reads:

- `totalSRU`  
- `cycleId`  
- `merkleRoot`  

and uses these values to compute **daily RDR emissions**.

### **8.4 With Staking Contract**
Stakers receive proportional rewards based on emissions generated from Proof Registry SRU data.

---

# **9. Security Model**

The Proof Registry ensures:

## **9.1 Immutability**
Once stored, no cycle can be edited or removed.

## **9.2 Fraud Prevention**
Fake earnings → rejected by Oracle → never appear in Registry.

## **9.3 Public Verifiability**
Anyone can verify each SRU cycle off-chain.

## **9.4 Tamper Resistance**
Cycle IDs + Merkle Roots prevent manipulation.

## **9.5 Data Privacy**
Workers’ personal details never appear on-chain.

---

# **10. Why the Proof Registry Matters**

Without the Proof Registry:

- emissions could not be trusted  
- SRU could not be verified  
- yield could be manipulated  
- workers’ data would be inconsistently tracked  

The Proof Registry ensures:

- transparency  
- accountability  
- accurate token emissions  
- sustainable protocol economics  

It is the **audit foundation of the entire Ridera RWA system**.

---

# **11. Future Enhancements**

Planned upgrades:

- zero-knowledge proof (ZKP) based verification  
- multi-cycle batching optimization  
- validator-signed cycle checkpoints  
- long-term archival compression  
- cross-chain Registry mirroring  

---

# **12. Conclusion**

The Proof Registry is one of Ridera’s most important components.  
It provides:

- decentralized trust  
- data immutability  
- transparent yield foundations  
- cryptographic proof of real-world work  

By anchoring real earnings on-chain through Merkle Roots and SRU cycle records, Ridera establishes a **tamper-proof financial layer** backed by global human productivity.

