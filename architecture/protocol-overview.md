# **Ridera Protocol Overview**  
### *Global Mobility → Verified Proofs → Standardized Revenue → On-Chain Yield (Base)*  
### *Technical Architecture Overview — Ridera Protocol v1.0*

---

# **1. Introduction**

The **Ridera Protocol** is a hybrid off-chain/on-chain system that converts global mobility earnings (Uber, Lyft, DoorDash, Grab, Rappi, Swiggy, Zomato, etc.) into **verifiable, standardized, and on-chain value**.

Ridera solves three fundamental problems in the mobility economy:

1. **Mobility income cannot be easily verified**  
2. **Earnings are fragmented across platforms, regions, and currencies**  
3. **No on-chain system represents global mobility income fairly**

To solve this, Ridera introduces:

- a **global verification Oracle**  
- a **standardized revenue unit (SRU)**  
- a **decentralized yield vault**  
- **validator participation & governance**  
- a transparent, scalable **RWA model** based on mobility work  

This document provides the full technical overview of Ridera’s architecture, workflow, trust boundaries, and yield model.

---

# **2. Core Architecture Layers**

Ridera consists of **four major layers**, split between off-chain and on-chain components.

---

## **2.1 Submission Layer — Off-chain**
Receives earnings proofs from drivers, couriers, and fleets.

---

## **2.2 Verification Layer — Ridera Oracle (Off-chain)**
Validates, parses, and authenticates all income submissions.

---

## **2.3 Standardization Layer — SRU Engine (Off-chain)**
Converts verified earnings into **SRU — Standardized Revenue Units**, the core metric of Ridera’s RWA model.

---

## **2.4 Settlement Layer — On-Chain (Base Network)**
Anchors proofs, stores SRU cycles, computes emissions, and distributes rewards.

Components on-chain:

- Proof Registry  
- Yield Vault  
- Staking Contract  
- Validator Registry  

---

# **3. System Modules Breakdown**

Below are the **8 core modules** powering Ridera.

---

## **3.1 Submission Module (Off-chain)**

Responsible for receiving and preprocessing all proof submissions.

**Functions:**

- input validation  
- screenshot/PDF parsing  
- metadata extraction  
- queueing for the Oracle  

**Supports:**

- Screenshots  
- PDF statements  
- Platform payout logs  
- Fleet bulk uploads  

---

## **3.2 Oracle Module (Verification Engine)**

Ensures all earnings are:

- authentic  
- accurate  
- non-duplicated  
- consistent with platform logic  

**Oracle Components:**

- OCR engine  
- Platform structure validator  
- Timestamp validator  
- Region-based anomaly detection model  
- Duplicate hash scanning  
- ML fraud detection  
- Validator routing (for suspicious entries)

**Outputs:**

- approved earnings  
- flagged proofs  
- rejected submissions  
- user trust-score updates  

---

## **3.3 SRU Engine (Standardization Layer)**

Transforms Oracle-approved earnings into **SRU**.

**Inputs:**

- validated income  
- currency conversion  
- platform coefficients  
- region multipliers  

**Outputs:**

- SRU values  
- SRU metadata  
- cycle batch entries  

SRU ensures global fairness across all regions and platforms.

---

## **3.4 Batcher & Merkle Generator (Off-chain)**

Bundles SRU entries for efficient on-chain anchoring.

**Functions:**

- aggregate SRUs  
- group by time/region/platform  
- build Merkle trees  
- generate Merkle roots  
- prepare metadata  

A Merkle root represents **thousands of SRUs** in one small commitment.

---

## **3.5 On-Chain Proof Registry (Base Network)**

Immutable, minimal storage contract.

**Responsibilities:**

- storing Merkle roots  
- storing batch metadata  
- exposing cycle IDs  
- enabling off-chain inclusion proof checks  

This ensures Ridera’s SRU data is **auditable and tamper-proof**.

---

## **3.6 Yield Vault (On-Chain)**

The financial engine that converts total SRU into $RDR token emissions.

**Responsibilities:**

- read totalSRU from Proof Registry  
- compute daily yield cycles  
- distribute rewards to stakers  
- maintain emission records  
- ensure SRU-backed reward integrity  

Yield is produced *exclusively* from real mobility work.

---

## **3.7 Staking Contract (On-Chain)**

Tracks:

- staker balances  
- eligibility for reward cycles  
- pending rewards  

Rewards follow the formula:

```
userReward = (userStake / totalStake) × dailyEmission
```

---

## **3.8 Validator Registry (On-Chain)**

Controls validator roles for the Oracle system.

Includes:

- validator bonding  
- slashing rules  
- audit responsibilities  
- trust scoring  

Validators operate:

- **off-chain** → proof audits  
- **on-chain** → governance, staking  

---

# **4. End-to-End Protocol Flow**

Complete lifecycle:

```
SUBMISSION → ORACLE → SRU ENGINE → BATCHER 
→ BASE (PROOF REGISTRY) → YIELD VAULT → STAKERS
```

---

### **Step-by-step Flow**

1. Driver uploads income proof  
2. Oracle verifies authenticity  
3. Approved earnings → SRU Engine  
4. SRU Engine converts earnings into SRU  
5. Batcher creates Merkle tree  
6. Merkle root submitted on Base  
7. Proof Registry stores cycle  
8. Yield Vault reads totalSRU  
9. Yield Vault executes emission cycle  
10. Stakers receive $RDR rewards  

This creates a complete **real-world work → on-chain yield** pipeline.

---

# **5. Trust Boundary Diagram (Mermaid)**

> *(Optional – you can insert a Mermaid graph in GitBook)*

```
graph TD
A[Submission Layer] --> B[Ridera Oracle]
B --> C[SRU Engine]
C --> D[Batcher + Merkle Generator]
D --> E[On-Chain Proof Registry]
E --> F[Yield Vault]
F --> G[Staking Contract]
G --> H[Stakers Receive Rewards]
```

---

# **6. Off-Chain vs On-Chain Responsibilities**

| Component | Off-Chain | On-Chain (Base) |
|----------|-----------|------------------|
| Submission Portal | ✔ | ❌ |
| Oracle | ✔ | ❌ |
| SRU Engine | ✔ | ❌ |
| Batcher | ✔ | ❌ |
| Proof Registry | ❌ | ✔ |
| Yield Vault | ❌ | ✔ |
| Staking | ❌ | ✔ |
| Validator Registry | ❌ | ✔ |
| Transparency Dashboard | ✔ | ❌ |

---

# **7. Protocol Guarantees**

Ridera guarantees:

## **1. Verifiability**
Every SRU can be proven through Merkle inclusion proofs.

## **2. Transparency**
All batches, cycles, and emissions are public.

## **3. Non-Custodial Structure**
Ridera never holds user fiat — only cryptographic proofs.

## **4. Global Fairness**
SRU standardizes income across 195+ countries.

## **5. Security**
Validators, signatures, anomaly detection, and proof anchoring provide multi-layer safety.

---

# **8. Future Upgrade Path**

### **Oracle v2**
- ML automation  
- Language-independent parsing  
- Behavior modeling  

### **Oracle v3**
- Mobility platform API integrations  
- Automatic earnings sync  

### **Oracle v4**
- Zero-knowledge earnings validation  

### **Yield Vault v2**
- Multi-vault pools  
- Region-specific reward markets  

### **Governance v1**
- Validator-driven governance  
- SRU parameter proposals  

---

# **9. Summary**

The Ridera Protocol is a **global, scalable, and secure mobility-RWA system** that transforms real-world labor into verifiable, standardized, on-chain economic value.

Through:

- rigorous Oracle verification  
- SRU standardization  
- cryptographic Merkle proofs  
- decentralized yield mechanics  

Ridera introduces the **first blockchain-native RWA model tied directly to mobility work**, one of the largest and most stable industries in the world.

**Document Version: v1.0 — Protocol Architecture Overview**

