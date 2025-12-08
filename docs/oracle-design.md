# Ridera Oracle Design  
### Global Mobility Verification Engine  
### Ridera Protocol — Technical Specification

1. Overview

The Ridera Oracle is the verification backbone of the Ridera protocol.
It processes real-world mobility earnings submitted by workers—such as ride-hailing drivers, food delivery couriers, and micro-fleet operators—and validates these submissions through multi-layered checks.

The Oracle ensures that all submitted earnings are:

authentic

consistent

non-duplicated

fraud-resistant

standardized for SRU computation

It does not generate SRU itself.
Instead, it outputs verified earnings to the SRU Engine, which performs standardization and final conversion into Standardized Revenue Units (SRU).

2. Design Goals

The Ridera Oracle is engineered around five primary goals:

2.1 Global Compatibility

Support for all mobility sectors:

Ride-hailing (Uber, Lyft, Grab, Bolt, Didi)

Food delivery (Zomato, Swiggy, DoorDash, Deliveroo)

Parcel courier fleets

Independent micro-fleets

Multi-platform earners

2.2 Tamper-Resistance

Every submission undergoes:

metadata validation

timestamp cross-checking

image anomaly detection

duplicate detection

region consistency modeling

2.3 Scalability

Designed to handle:

millions of global submissions

multi-language OCR

multi-region workloads

peak-hour surge load

2.4 Progressive Decentralization

Oracle starts semi-centralized (v1), becoming more decentralized through:

validator audits

rule-based governance

community oversight mechanisms

2.5 Transparency & Traceability

All verified proofs are:

logged

hashed

batched

posted to the Proof Registry

This ensures public auditability and long-term integrity.

3. Oracle Architecture

The Oracle operates through four main layers:

Input Layer – Ingestion of earnings data

Verification Layer – Core validation checks

Validator Layer – Decentralized auditing (v2+)

Output Layer – Standardized output to SRU Engine

4. Layer 1 — Input Layer (Data Ingestion)

The input layer collects and normalizes earnings from multiple sources.

4.1 Supported Input Formats
4.1.1 Screenshots (OCR Processing)

Supports OCR for:

English

Spanish

Portuguese

Arabic

Hindi

Indonesian

More languages will be added progressively

Extracted fields include:

total payout

base pay, bonus, tip breakdown

date/time

task count

platform identifier

4.1.2 PDF Statements

Direct ingestion from platforms such as:

Uber

Bolt

Deliveroo

Grab

iFood

4.1.3 Multi-Platform Merging

The Oracle can merge submissions from 2–4 apps per worker.

4.1.4 Metadata Enrichment

The Input Layer attaches:

region code

currency

device signature

optional GPS match

submission timestamp

5. Layer 2 — Verification Layer (Core Oracle Engine)

This is where the heavy logic is executed.
Each submission passes through seven verification stages.

5.1 Timestamp Validation

Checks include:

screenshot timestamp vs. device local time

whether payout belongs to the correct daily cycle

detection of forward/backdated entries

5.2 Region Consistency Modeling

The Oracle compares earnings with known regional patterns:

minimum and maximum expected ranges

task density

typical payout fluctuations

surge-hour alignment

local platform economics

Each region maintains its own adaptive model.

5.3 Platform Structure Validation

Each mobility platform has a unique earnings structure. The Oracle verifies:

Uber: fare + time + distance consistency

DoorDash: base pay, tip, bonus breakdown

Grab: surge multipliers

Bolt: trip count vs. total gross

Any mismatch triggers an audit request.

5.4 Duplicate Submission Detection

The Oracle uses:

perceptual hashing

metadata fingerprint comparison

image hashing

sequence pattern matching

Duplicate earnings are automatically rejected.

5.5 ML-Based Anomaly Detection

Machine learning models detect:

altered or synthetic screenshots

improbable earnings spikes

mismatched regional profiles

historical pattern anomalies

Models used:

CNN-based image anomaly detector

regional payout prediction model

clustering for detecting abnormal user behavior

5.6 Reputation Scoring

Each user maintains a dynamic trust score based on:

number of valid submissions

anomaly flags

validator audits

historical consistency

Note:
Reputation does not affect rewards.
It only adjusts:

audit frequency

submission limits

automatic approval likelihood

5.7 Proof Batching

All approved proofs are grouped into:

a 24-hour cycle

region buckets

platform groups

The output is sent to the SRU Engine for standardization.

6. Layer 3 — Validator Layer

Introduced progressively starting Oracle v2.

6.1 Responsibilities

Validators:

audit flagged submissions

verify complex proofs

confirm large fleet batches

provide feedback for rule updates

6.2 Incentives

Validators earn RDR for:

high audit accuracy

low dispute rates

consistent participation

6.3 Slashing Conditions

Validators lose rewards if:

approving fraudulent proofs

performing inaccurate audits

frequently failing consensus

7. Layer 4 — Output Layer (Verified Earnings → SRU Engine)

The Oracle does not compute SRU.
Instead, it outputs verified, structured earnings data to the SRU Engine.

7.1 Output Components

Each cycle includes:

total verified earnings per worker

platform-level breakdown

region metadata

cycle timestamp

Merkle root of all verified proofs

7.2 SRU Engine Integration

The SRU Engine uses Oracle data to calculate:

region weight

platform weight

category weight

final SRU output per worker

These SRU outputs then feed directly into the Yield Vault for reward generation.

8. Oracle Version Roadmap
Oracle v1 — 2025

OCR-based parsing

Timestamp + region checks

Rule-based fraud detection

Basic validator involvement

Oracle v2 — 2026

Full ML anomaly detection

Automated batching

Cross-platform merging

Validator staking + slashing

Oracle v3 — Future

Direct API integrations with platforms

Fully automated ingestion

Regional payout modeling

Oracle v4 — Future

Zero-knowledge proofs for income verification

Full decentralization of proof verification

9. Conclusion

The Ridera Oracle is a global, tamper-resistant verification engine designed for mobility-based RWA systems.
It ensures that every SRU issued by the protocol is:

backed by real work

cryptographically verified

globally consistent

fraud-resistant

transparent and fully auditable

The Oracle is the foundation that allows Ridera to convert global mobility labor into reliable on-chain yield—safely, fairly, and at global scale.
