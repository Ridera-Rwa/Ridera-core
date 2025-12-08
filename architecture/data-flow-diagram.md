# **Ridera Architecture Overview**  
### *End-to-End System Architecture for Mobility RWA Protocol*  
### *Ridera Protocol — Technical Infrastructure Diagram*

---

# **1. Introduction**

This page provides a complete architectural view of the **Ridera Protocol**, showing how off-chain verification, standardization, batching, and on-chain settlement interact to convert global mobility income into trustless, on-chain SRU and reward generation.

This document is intended for:

- developers  
- auditors  
- investors  
- integration partners  

It includes multiple **Mermaid diagrams** to visualize system flows and trust boundaries.

---

# **2. High-Level Architecture Diagram**

This is the primary diagram showing the full Ridera pipeline:

```
flowchart LR

A[User Earnings Submission\n(Screenshots / PDFs / Logs)] --> B[Ridera Oracle\nVerification Layer]

B --> C[SRU Engine\nStandardization Layer]

C --> D[Batcher & Merkle Generator]

D --> E[Proof Registry (Base)\nOn-Chain Commitment]

E --> F[Yield Vault (Base)\nEmission Engine]

F --> G[Staking Contract\nReward Distribution]

G --> H[Stakers Receive $RDR\nReal-World Yield]
```

---

# **3. Off-Chain Architecture Diagram**

The off-chain subsystem handles:

- data submission  
- proof verification  
- earnings validation  
- SRU computation  
- batching  

```
flowchart TD

A[Submission Portal] --> B[Oracle Input Handler]

B --> C[OCR Engine]
B --> D[Timestamp Validator]
B --> E[Platform Structure Validator]
B --> F[Anomaly Detection Model]
B --> G[Duplicate Proof Detector]

C --> H[Oracle Decision Engine]
D --> H
E --> H
F --> H
G --> H

H --> I[Approved Earnings]
H --> J[Flagged for Validator Audit]
H --> K[Rejected Submission]

I --> L[SRU Engine]

L --> M[SRU Calculation]
L --> N[Region Weighting]
L --> O[Platform Weighting]
L --> P[Category Weighting]

M --> Q[SRU Output Batch]
N --> Q
O --> Q
P --> Q

Q --> R[Batcher + Merkle Tree Generator]
```

---

# **4. On-Chain Architecture Diagram (Base Network)**

This shows how Ridera uses blockchain for integrity, yield, and security.

```
flowchart LR

A[Batcher Output\n(Merkle Root + Metadata)] --> B[Proof Registry Contract]

B --> C[Yield Vault Contract]

C --> D[Staking Contract]

D --> E[Stakers\n(Get Rewards)]
```

---

# **5. Trust Boundary Diagram**

This diagram shows where trust shifts from off-chain components to cryptographically verified on-chain components.

```
flowchart TB

subgraph Off-Chain Systems
A[Submission Portal]
B[Ridera Oracle]
C[SRU Engine]
D[Batcher + Merkle Generator]
end

A --> B --> C --> D

subgraph On-Chain Systems (Base)
E[Proof Registry]
F[Yield Vault]
G[Staking Contract]
H[Validator Registry]
end

D --> E --> F --> G

B -. Flags .-> H
```

**Boundary Meaning:**

- Off-chain = computation + verification  
- On-chain = storage + yield + distribution  

Only **minimal, trustless data** (Merkle roots, SRU totals) cross the boundary.

---

# **6. Component Interaction Overview**

```
sequenceDiagram
    actor User
    participant Portal as Submission Layer
    participant Oracle as Verification Layer
    participant SRU as SRU Engine
    participant Batch as Batcher
    participant Proof as Proof Registry (Base)
    participant Vault as Yield Vault (Base)
    participant Stake as Staking Contract
    actor Staker

    User ->> Portal: Upload Earnings Proof
    Portal ->> Oracle: Send Raw Submission
    Oracle ->> Oracle: Validate Proof\n(OCR, timestamp, structure, ML)
    Oracle ->> SRU: Approved Earnings
    SRU ->> Batch: SRU Conversion + Metadata
    Batch ->> Proof: Submit Merkle Root + Cycle Data
    Proof ->> Vault: Provide totalSRU per cycle
    Vault ->> Stake: Daily Emission Distribution
    Stake ->> Staker: Rewards Released
```

---

# **7. Layered Architecture Summary**

| Layer | Component | Responsibility |
|-------|-----------|---------------|
| **Submission Layer** | Portal | Receives earnings |
| **Verification Layer** | Ridera Oracle | Validates authenticity |
| **Standardization Layer** | SRU Engine | Converts earnings → SRU |
| **Batching Layer** | Merkle Generator | Builds cycle batches |
| **Storage Layer** | Proof Registry | Stores cycle roots |
| **Yield Layer** | Yield Vault | Computes emissions |
| **Distribution Layer** | Staking Contract | Sends rewards to users |
| **Governance Layer** | Validator Registry | Oversees protocol integrity |

---

# **8. Key Design Principles**

### **8.1 Off-Chain Heavy, On-Chain Light**
Off-chain = computation  
On-chain = trust, settlement, immutability

### **8.2 Merkle Compression**
Allows thousands of proofs to be committed in a single root.

### **8.3 Deterministic Yield**
SRU → Emissions → Staker rewards  
No speculative APY.

### **8.4 Modular Architecture**
Each component can upgrade independently.

### **8.5 Enterprise Ready**
Supports:

- bulk fleet uploads  
- platform partnerships  
- multi-region OTP integration (future)  

---

# **9. Conclusion**

The Ridera Architecture is designed for:

- global scale  
- decentralized security  
- cryptographic verifiability  
- stable RWA-backed yield  
- low on-chain cost  
- multi-platform mobility integrations  

This architecture makes Ridera the **first globally scalable RWA protocol backed by real mobility work**, transforming daily labor into trustless, verifiable financial primitives.


