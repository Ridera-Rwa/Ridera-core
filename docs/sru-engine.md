# SRU Engine  
### Standardized Revenue Unit Computation Layer  
### Ridera Protocol — Technical Specification

---

# 1. Overview

The **SRU Engine** is the computational core of the Ridera protocol.  
It transforms *verified real-world mobility earnings* into a **standardized, normalized, and globally comparable unit** called **SRU (Standardized Revenue Unit)**.

SRU allows Ridera to convert fragmented earnings from gig workers—across countries, platforms, and work categories—into a **single unified economic metric** that serves as the foundation for:

- reward generation  
- global mobility indexing  
- yield computation  
- worker reputation scoring  
- on-chain verifiable work identity  

The SRU Engine operates *only* on earnings that the Ridera Oracle has fully verified.

---

# 2. Design Goals

The SRU Engine is built around four main goals:

## **2.1 Global Standardization**
Convert global, multi-currency earnings into a single comparable unit.

## **2.2 Platform Neutrality**
Different platforms pay differently — SRU normalizes these variations.

## **2.3 Fairness & Transparency**
Ensure workers from different countries are rewarded fairly relative to economic conditions.

## **2.4 Scalability**
Handle millions of daily SRU computations without performance bottlenecks.

---

# 3. Why SRU Is Needed

Gig earnings vary widely:

- A driver in India may earn ₹900 per day  
- A driver in the USA may earn $150 per day  
- A courier in Brazil may earn R$120 per day  

**But the *effort* and *work-time* might be similar.**

Without SRU:

- Rewards are unfair  
- Global comparisons are impossible  
- Emissions would favor high-income regions  
- Data becomes non-standardized  

SRU solves this through **normalization and weighting formulas**.

---

# 4. SRU Inputs

The SRU Engine receives structured data from the Ridera Oracle:

- **Verified earnings amount**
- **Platform ID (e.g., Uber, Swiggy, DoorDash)**
- **Region/Country code**
- **Work category (full-time, part-time, peak-hours)**
- **Task count (rides/deliveries)**
- **Cycle timestamp**
- **Metadata for normalization**

All earnings belong to a **24-hour cycle** (1 cycle = 1 day).

---

# 5. Normalization Factors

SRU uses three core multipliers to ensure fairness:

## **5.1 Country Weight (CW)**  
Corrects for differences in regional earning power and cost structures.

Examples (illustrative):

- India → 1.00  
- Vietnam → 0.92  
- UAE → 1.40  
- USA → 1.80  

This ensures equal-effort = equal SRU.

---

## **5.2 Platform Weight (PW)**  
Each platform has different payout models and task difficulty.

Examples (illustrative):

- Zomato → 1.00  
- Swiggy → 0.95  
- Uber Eats → 1.20  
- Grab → 1.10  

---

## **5.3 Category Weight (CTW)**  
Adjusts for working style and effort intensity.

Examples:

- Full-time worker → 1.20  
- Part-time worker → 1.00  
- Peak-hour rider → 1.15  
- Low-demand region → 0.90  

---

# 6. SRU Formula

The final SRU for a worker for a single cycle is computed as:

```
SRU = Earnings_USD × CW × PW × CTW
```

Where:

- **Earnings_USD** → earnings normalized to USD  
- **CW** → Country Weight  
- **PW** → Platform Weight  
- **CTW** → Category/Work-Type Weight  

This produces a **single SRU value** for each worker per cycle.

---

# 7. Cycle Formation

Ridera processes SRU on a **per-day basis**.

## **7.1 Daily Cycle Structure**
Each cycle contains:

- workerId (hashed)
- SRU value
- platform ID
- region code
- timestamp
- verification signature

All worker cycles for the day are grouped into a **Cycle Batch**.

---

# 8. Merkle Tree Construction

To optimize on-chain storage:

- Each worker’s SRU becomes a **leaf node**
- Leaves → hashed → form a **Merkle Tree**
- The **Merkle Root** represents the entire day's verified SRU dataset

This root is sent to the **Proof Registry**.

Stored on-chain:

- `cycleId`
- `totalSRU`
- `merkleRoot`
- `timestamp`

---

# 9. SRU Engine Output

At the end of each cycle, the SRU Engine produces:

- **SRU per worker**
- **Total SRU for the cycle**
- **Merkle Root**
- **Cycle summary**
- **Proof-ready dataset for the Yield Vault**

The output flows to the **Proof Registry**, enabling trustless yield computation.

---

# 10. Interaction With Other Components

```
Ridera Oracle (Verification)
          ↓ Verified Earnings
SRU Engine (Normalization)
          ↓ SRU Outputs + Merkle Tree
Proof Registry (On-Chain Storage)
          ↓ totalSRU
Yield Vault (Emission Model)
          ↓ RDR Rewards
Staking Contract (Distribution)
```

SRU is the **bridge** between real-world work and on-chain token emissions.

---

# 11. Future Enhancements

Planned upgrades include:

- dynamic global economic index  
- adaptive country weights  
- AI-powered platform normalization  
- work efficiency scoring  
- real-time SRU updates with API integration  

---

# 12. Conclusion

The SRU Engine is the heart of Ridera’s Real-World Work (RWW) architecture.

It ensures:

- fair global standardization  
- transparent and accurate yield mapping  
- on-chain auditability  
- verifiable income identity  
- economic sustainability  

SRU turns real-world labor into **programmable on-chain value**, enabling Ridera to become the world’s first scalable work-based RWA protocol.

