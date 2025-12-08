# **Ridera Emission Model**  
### *Dynamic RDR Emissions Backed by Real-World Work (RWW)*

---

# **1. Introduction**

The **Ridera Emission Model** defines how the protocol converts **verified real-world fleet productivity** (measured as SRU) into **RDR emissions** for stakers.

Unlike traditional protocols that rely on arbitrary APRs or inflation schedules, Ridera emissions are **directly linked to real economic activity**.

This ensures:

- **Sustainability**  
- **Fair distribution**  
- **Economic alignment**  
- **Anti-inflation control**

This document explains how the daily emission engine works, how rewards are generated, and how RDR distribution stays transparent and economically grounded.

---

# **2. Design Principles**

Ridera emissions follow four foundational principles:

## **2.1 Real-World Backing**
RDR is emitted **only when real work is performed**.  
If no SRU is generated → **no emissions**.

## **2.2 Predictable & Anti-Inflation**
Emissions follow a **soft-capped curve**, avoiding runaway inflation.

## **2.3 Dynamic & Market-Independent**
Rewards are unaffected by:

- Token price  
- Market volatility  
- Speculation  

Emissions reflect **verified human productivity**.

## **2.4 Fully Transparent & On-Chain**
All emission decisions are derived from:

- **Proof Registry**  
- **SRU Engine outputs**  
- **On-chain verifiable SRU cycles**

---

# **3. Components of the Emission Model**

The emission system has three core layers:

---

## **3.1 SRU Engine**
- Processes raw earnings  
- Converts them into **SRU**  
- Outputs daily cycle data:

  - **totalSRU**  
  - **per-user SRU**  
  - **merkleRoot**  
  - **timestamp**

This data is written to the Proof Registry.

---

## **3.2 Proof Registry**
The **immutable source of truth** for:

- Cycle IDs  
- Verified totalSRU  
- Merkle roots  
- Signed Oracle proofs  

The **Yield Vault reads from here** to compute emissions.

---

## **3.3 Yield Vault**
The protocol’s reward engine.

Responsibilities:

- Read **totalSRU**  
- Apply **emission formula**  
- Compute global **dailyEmission**  
- Distribute rewards proportionally to stakers  

The Yield Vault **never accesses raw earnings**, only SRU outputs.

---

# **4. Emission Model Formula**

## **4.1 Daily Emission Formula**

dailyEmission = min(
BASE_EMISSION + (totalSRU × SRU_Emission_Factor),
MAX_EMISSION
)


### **Variables Explained**

| Variable | Description |
|---------|-------------|
| **BASE_EMISSION** | Minimum baseline emission per day |
| **totalSRU** | Verified SRU generated in previous cycle |
| **SRU_Emission_Factor** | RDR emitted per SRU unit |
| **MAX_EMISSION** | Hard ceiling to prevent inflation |

---

# **5. Emission Factors**

## **5.1 SRU Emission Factor**
Determines how much SRU contributes to emissions.

Example (adjustable before mainnet):

SRU_Emission_Factor = 0.0002 RDR per SRU


---

## **5.2 Maximum Emission Cap**
Hard ceiling to prevent systemic inflation:

MAX_EMISSION = 100,000 RDR per day


---

# **6. How Emissions Respond to SRU Volume**

## **6.1 Low SRU Day**
- Fewer workers  
- Low activity  
- Limited submissions  

**Result:** Emissions stay near **BASE_EMISSION**.

---

## **6.2 Moderate SRU Day**
- Healthy global worker activity  
- Normal operational behavior  

**Result:** Emissions increase **proportionally**.

---

## **6.3 High SRU Day**
- Surge hours  
- Holidays  
- Heavy workforce activity  

**Result:** Emissions increase but **never exceed MAX_EMISSION**.

---

# **7. Emission Distribution to Stakers**

Once dailyEmission is computed:

BASE_EMISSION = 5,000 RDR per day


---

# **6. How Emissions Respond to SRU Volume**

## **6.1 Low SRU Day**
- Fewer workers  
- Low activity  
- Limited submissions  

**Result:** Emissions stay near **BASE_EMISSION**.

---

## **6.2 Moderate SRU Day**
- Healthy global worker activity  
- Normal operational behavior  

**Result:** Emissions increase **proportionally**.

---

## **6.3 High SRU Day**
- Surge hours  
- Holidays  
- Heavy workforce activity  

**Result:** Emissions increase but **never exceed MAX_EMISSION**.

---

# **7. Emission Distribution to Stakers**

Once dailyEmission is computed:

userReward = ( userStake / totalStake ) × dailyEmission

Meaning:

- **Fair proportional distribution**
- **Larger stake = larger share**
- **No boosting, no tiered manipulation**
- 100% transparent and deterministic

---

# **8. Holistic Emission Lifecycle**

Worker Earnings
↓
SRU Engine
↓
Proof Registry
↓
Yield Vault
↓
Daily Emission
↓
RDR Rewards to Stakers


A trustless and complete cycle from **real-world income → on-chain yield**.

---

# **9. Design Benefits**

## **9.1 Economic Sustainability**
Emissions scale only with actual productivity.

## **9.2 Anti-Gaming Mechanism**
Fake earnings cannot create SRU → cannot generate rewards.

## **9.3 Predictable Token Supply**
Emission caps ensure long-term stability and protect holders.

## **9.4 Real-World Yield Alignment**
Unlike traditional APYs, Ridera rewards track **global workforce performance**.

---

# **10. Future Enhancements**

Planned upgrades:

- Multi-region SRU weighting  
- Seasonal emission adjustments  
- Volatility smoothing curve  
- DAO-controlled factors  
- Dynamic caps based on maturity  

---

# **11. Conclusion**

Ridera introduces the world’s first **emission model directly tied to verified human work**.

By grounding token issuance in real productivity, Ridera ensures:

- **Fair rewards**  
- **Controlled inflation**  
- **Real-world backed on-chain yield**  
- **Long-term economic scalability**

This positions Ridera as one of the most **economically sound and transparent RWA models** in Web3.


