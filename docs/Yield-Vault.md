# **Yield Vault**  
### *Emission Engine for SRU-Backed Real-World Yield*  
### *Ridera Protocol — Technical Specification*

---

# **1. Overview**

The **Yield Vault** is the reward engine of the Ridera protocol.  
It converts **verified real-world productivity** (represented as SRU) into **RDR emissions** for stakers.

The Yield Vault:

- reads totalSRU from the **Proof Registry**  
- applies the **Emission Model**  
- generates a **daily RDR emission amount**  
- distributes rewards to stakers proportionally  

Unlike traditional staking protocols, Ridera does **not** use fixed APY or arbitrary inflation.  
All emissions come from **real-world work volume**, making Ridera a sustainable, RWA-backed system.

---

# **2. Design Goals**

The Yield Vault is engineered to provide:

## **2.1 Real-Economy Backed Rewards**
RDR is emitted *only* when real SRU is generated.

## **2.2 Predictable & Controlled Token Supply**
A hard maximum emission cap prevents inflation.

## **2.3 Fair Distribution**
Stakers receive proportional rewards based on their stake.

## **2.4 Transparent Yield Flow**
All emission decisions tie back to on-chain Proof Registry data.

## **2.5 Market Independence**
Rewards do not depend on token price, hype, or APY manipulation.

---

# **3. Inputs to the Yield Vault**

The Yield Vault reads **one cycle per day** from the Proof Registry:

| Field | Purpose |
|-------|---------|
| **totalSRU** | Determines emission size |
| **cycleId** | Ensures correct sequencing |
| **merkleRoot** | Attaches verified work data |
| **timestamp** | Locks emission to daily cycle |

This ensures total transparency:  
**Every RDR emitted is backed by verifiable SRU on-chain.**

---

# **4. Emission Model**

The Yield Vault uses Ridera’s dynamic emission algorithm:

```
dailyEmission = min(
    BASE_EMISSION + (totalSRU × SRU_Emission_Factor),
    MAX_EMISSION
)
```

---

## **4.1 Base Emission (Minimum Reward)**

```
BASE_EMISSION = 5,000 RDR/day
```

Purpose:

- ensures early stakers receive consistent rewards  
- avoids 0-yield days during low SRU periods  

---

## **4.2 SRU Emission Factor**

```
SRU_Emission_Factor = 0.0002 RDR per SRU
```

Meaning:

- more real-world work → more emissions  
- less work → emissions stay near base  

This creates a **direct link between human productivity and token issuance**.

---

## **4.3 Emission Cap (Anti-Inflation Mechanism)**

```
MAX_EMISSION = 100,000 RDR/day
```

This ensures:

- no runaway inflation  
- stable token supply  
- long-term sustainability  

Even if SRU becomes very high globally → emissions never exceed the cap.

---

# **5. How SRU Affects Emissions**

### **5.1 Low SRU Day**
- fewer tasks  
- fewer workers  
- dailyEmission stays near BASE_EMISSION  

### **5.2 Medium SRU Day**
- stable participation  
- yields increase proportionally  

### **5.3 High SRU Day**
- high regional activity  
- surge hours, weekends  
- emissions rise but remain capped  

This ensures a smooth, predictable economic model.

---

# **6. Reward Distribution**

Once `dailyEmission` is computed:

```
userReward = (userStake / totalStake) × dailyEmission
```

Meaning:

- stakers own a fraction of the daily emissions  
- more stake = larger reward  
- rewards are **proportional, transparent, and fair**

---

# **7. Emission Flow Diagram**

```
Oracle Verified Earnings  
         ↓  
SRU Engine (Standardization)  
         ↓  
Proof Registry (On-Chain Cycle Data)  
         ↓ totalSRU  
Yield Vault (Emission Engine)  
         ↓ RDR Emission  
Staking Contract (Distribution)  
         ↓  
Stakers Receive Rewards
```

This flow ensures **fully traceable yield** from *real-world economic activity → on-chain tokens*.

---

# **8. Safety & Security**

The Yield Vault implements:

## **8.1 Cycle-Strict Emissions**
Emissions occur **once per registered cycle**.

## **8.2 Replay Protection**
A cycle cannot be used twice.

## **8.3 Oracle Signature Checks**
Only verified totals can trigger emissions.

## **8.4 Immutable Proof Reference**
All emissions are cryptographically tied to a Merkle Root.

## **8.5 No User Earnings Stored**
Only SRU totals are handled — no sensitive data.

---

# **9. Why Ridera’s Yield Is Superior to APY-Based Systems**

| Ridera Yield | Traditional APY Tokens |
|--------------|------------------------|
| Backed by real work | Backed by inflation |
| Adjusts with SRU | Manipulated by token price |
| Stable, non-speculative | Volatile, market-dependent |
| Transparent | Often opaque |
| Sustainable emission curve | High risk of collapse |

Ridera introduces the **first globally scalable RWW yield model**, driven entirely by real-world work.

---

# **10. Future Enhancements**

Planned upgrades include:

- **dynamic emission smoothing curves**  
- **region-weighted SRU contributions**  
- **DAO-governed emission parameters**  
- **epoch-based yield averaging**  
- **multi-chain Yield Vault mirrors**  
- **seasonal emission adjustments**  

---

# **11. Conclusion**

The Yield Vault is the **economic engine** of the Ridera protocol.  
It ensures:

- emissions are backed by real-world income  
- rewards remain fair and predictable  
- inflation is controlled  
- all token issuance is auditably linked to human productivity  

By grounding emissions in SRU, Ridera creates the **first sustainable, decentralized RWA yield system powered by real-world work.**

