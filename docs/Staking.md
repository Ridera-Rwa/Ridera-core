# **Staking System**  
### *RDR Staking → Real-World Work (RWW) Backed Yield*  
### *Ridera Protocol — Technical Specification*

---

# **1. Overview**

The **Ridera Staking System** allows users to lock RDR tokens in exchange for yield that is fully backed by **real-world work**, not speculation.

When users stake RDR:

- they receive a proportional share of **daily emissions**  
- emissions are calculated from **SRU (Standardized Revenue Units)**  
- rewards increase with global work volume  
- staking has no fixed APY and no artificial inflation  

The staking system forms the **final reward distribution layer** of Ridera’s RWA architecture.

---

# **2. Design Goals**

The staking contract is built with the following objectives:

## **2.1 Fair Reward Distribution**
Rewards are distributed proportionally based on stake size.

## **2.2 Real-World Backing**
Yield is created only when real SRU is generated.

## **2.3 Security & Predictability**
Contracts are transparent, immutable, and auditable.

## **2.4 No Arbitrary APY**
Rewards follow the emission engine, not market manipulation.

## **2.5 Long-Term Sustainability**
Controlled emissions prevent inflationary collapse.

---

# **3. How Staking Works**

The Staking Contract receives the daily emission amount from the Yield Vault.  
Then it distributes rewards using:

```
userReward = (userStake / totalStake) × dailyEmission
```

Where:

- **userStake** = tokens the user has staked  
- **totalStake** = total RDR staked globally  
- **dailyEmission** = amount calculated by Yield Vault  

This ensures **every staker receives a fair share** of the day’s work-backed yield.

---

# **4. Staking Lifecycle**

```
User Stakes RDR  
        ↓  
Tokens Locked in Staking Contract  
        ↓  
Yield Vault Sends Daily RDR Emission  
        ↓  
Rewards Distributed Proportionally  
        ↓  
User Claims Rewards Anytime  
        ↓  
User Unstakes When Desired
```

Staking is non-inflationary because emissions are fixed + dynamic based on SRU.

---

# **5. Contract Components**

The Staking Contract contains:

## **5.1 Stake Ledger**
Tracks:

- stake amounts  
- staker addresses  
- reward debt  

## **5.2 Reward Pool**
Receives daily RDR emission from Yield Vault.

## **5.3 Accumulated Reward Tracker**
Keeps a running total:

```
accRewardPerShare
```

This allows fair distribution across all participants.

## **5.4 Claim Engine**
Users can claim rewards at any time with no lock.

---

# **6. Reward Distribution Logic**

After Yield Vault sends the daily emission:

1. The emission amount is added to the reward pool.
2. The system updates:

```
accRewardPerShare += dailyEmission / totalStake
```

3. Each user’s pending reward:

```
pending = userStake × accRewardPerShare - userRewardDebt
```

4. When user claims:

- pending reward is transferred  
- rewardDebt is updated  

This method keeps rewards accurate even if stake amounts change.

---

# **7. Time Locks & Flexibility**

### **7.1 No Mandatory Lock**
Users may:

- stake anytime  
- claim anytime  
- unstake anytime  

### **7.2 Optional Lock (Future Upgrade)**
Ridera may introduce:

- locked staking  
- boosted rewards for long-term holders  

These will be governed by community proposals.

---

# **8. Security Features**

## **8.1 Only Yield Vault Can Update Rewards**
This prevents manipulation.

## **8.2 Cycle-Based Emissions**
Rewards follow daily SRU cycle updates.

## **8.3 No External Write Access**
Users cannot influence reward math.

## **8.4 Transparent On-Chain Logs**
All emissions and reward events are publicly visible.

---

# **9. SRU → Emission → Staking: Full Flow**

```
Real-World Earnings  
        ↓  
Oracle (Verification)  
        ↓  
SRU Engine  
        ↓  
Proof Registry  
        ↓ totalSRU  
Yield Vault (Emission Model)  
        ↓ dailyEmission  
Staking Contract  
        ↓  
User Receives RDR Rewards
```

This establishes the world’s first **work-backed staking model**.

---

# **10. Staker Benefits**

- Earn yield backed by real economic activity  
- Transparent and predictable emissions  
- No dilution from unlimited inflation  
- Rewards tied to global workforce productivity  
- Fully auditable process from earnings → yield  

---

# **11. Future Enhancements**

- tiered staking multipliers  
- NFT-based boost passes  
- veRDR (vote escrow) model  
- cross-chain staking  
- delegated staking for fleet operators  

---

# **12. Conclusion**

Ridera’s staking system is the **final reward layer** of the RWW (Real-World Work) economy.

It:

- provides decentralized, sustainable yield  
- aligns stakers with real productivity  
- ensures token emissions remain controlled  
- offers a simple and transparent reward experience  

By bridging global labor output with on-chain staking rewards, Ridera delivers a **revolutionary new staking paradigm** powered by human work.

