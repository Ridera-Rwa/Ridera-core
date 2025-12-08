Ridera Emission Model
Dynamic RDR Emissions Backed by Real-World Work (RWW)
1. Introduction

The Ridera Emission Model defines how the protocol converts verified real-world fleet productivity (represented as SRU) into RDR emissions for stakers.
Unlike traditional protocols that use arbitrary APR or inflation schedules, Ridera’s emissions are directly linked to real economic activity.

Emissions scale up or down based on the amount of SRU generated globally, ensuring:

Sustainability

Fair distribution

Economic alignment

Anti-inflation control

This document explains how the daily emission engine works, how rewards are generated, and how RDR distribution remains transparent and economically grounded.

2. Design Principles

Ridera emissions follow four core principles:

2.1 Real-World Backing

RDR rewards are only issued when real SRU is produced.
No SRU → No emissions.

2.2 Predictable & Anti-Inflation

Emissions follow a soft-capped curve, preventing runaway token inflation.

2.3 Dynamic + Market Independent

Rewards do not rely on arbitrary APY percentages or token price manipulation—only on verifiable human productivity.

2.4 Transparent & On-Chain

All emission decisions originate from data stored in the Proof Registry and executed by the Yield Vault.

3. Components of the Emission Model

The Ridera emission system consists of three key layers:

3.1 SRU Engine

Processes raw earnings → converts into SRU
Outputs daily cycle data:

totalSRU

per-user SRU

merkle root

timestamp

Stored in the Proof Registry.

3.2 Proof Registry

The immutable source of truth for:

Cycle ID

Verified total SRU

Merkle root

Signed proofs from the oracle

The Yield Vault reads data directly from here.

3.3 Yield Vault

The protocol’s reward computation layer.

Responsibilities:

Read total SRU of each cycle

Apply emission formula

Determine global daily RDR emission

Allocate rewards proportionally to stakers

The Yield Vault never stores worker income — it interprets only SRU outputs.

4. Emission Model Formula
4.1 Daily Emission Formula
dailyEmission = min( BASE_EMISSION + (totalSRU × SRU_Emission_Factor), MAX_EMISSION )


Where:

Variable	Description
BASE_EMISSION	A small constant emission that ensures minimum staking reward baseline
totalSRU	Total SRU generated in the previous cycle
SRU_Emission_Factor	How much RDR is emitted per SRU unit
MAX_EMISSION	Hard ceiling to prevent inflation
5. Emission Factors
5.1 SRU Emission Factor

This multiplier determines how much SRU affects emissions.

Example value:

SRU_Emission_Factor = 0.0002 RDR per SRU


(This is protocol-adjustable before mainnet launch.)

5.2 Maximum Emission Cap

Hard upper bound to avoid inflation:

MAX_EMISSION = 100,000 RDR per day


This ensures predictable token output even if SRU volume rapidly increases.

5.3 Base Emission Floor

Minimum emission if SRU is low:

BASE_EMISSION = 5,000 RDR per day


Provides stability for stakers during early periods.

6. How Emissions Respond to SRU Volume
6.1 Low SRU Day

Daily tasks low

Few riders submit data

Result:
Emissions stay close to BASE_EMISSION.

6.2 Moderate SRU Day

Healthy task volume

More fleets participating

Result:
Emissions rise proportionally with SRU.

6.3 High SRU Day

Surge hours

Holidays, weekends

High number of active fleets

Result:
Emissions increase but never exceed MAX_EMISSION.

7. Emission Distribution to Stakers

Once the Yield Vault computes the daily emission:

userReward = ( userStake / totalStake ) × dailyEmission


Meaning:

Stakers receive RDR proportionally

Larger stake = larger share

No boosting, no unfair multipliers

100% transparent

8. Holistic Emission Lifecycle
Worker Earnings → SRU Engine → Proof Registry → Yield Vault → Daily Emission → Staker Rewards


This creates a complete, trustless flow from real-world income → on-chain yield.

9. Design Benefits
9.1 Economic Sustainability

Emissions scale with real productivity.

9.2 Anti-Gaming Mechanism

Fake earnings cannot produce SRU → cannot produce rewards.

9.3 Predictable Token Supply

Hard emission ceilings protect long-term holders.

9.4 Real-World Yield Alignment

Unlike APY-based models, Ridera rewards are tied to actual global workforce performance.

10. Future Enhancements

Planned upgrades:

Multi-region SRU weighting in emissions

Seasonal emissions adjustments

Emission smoothing curve to reduce volatility

DAO-defined emission factors

Dynamic caps based on protocol maturity

11. Conclusion

Ridera introduces the world’s first emissions model tied directly to verified human work.
By grounding token issuance in real worker productivity, Ridera achieves a sustainable, transparent, and economically resilient model that aligns incentives across all participants.

The emission engine ensures:

Fair rewards

Controlled inflation

Real-world backed on-chain yield

Long-term scalability

This makes Ridera one of the most economically grounded RWA protocols in Web3.
