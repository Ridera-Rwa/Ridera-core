# Ridera Protocol – Beta Deployment Overview

This document contains the temporary beta contract deployments used for internal 
and community testing. These contracts are NOT final and will be redeployed 
before Testnet Public and Mainnet launch.

---

## 🚀 Current Beta Contracts

### 1. RDRT Token (ERC20)
**Address**: 0x9d28d89fE48ff7cC6ADBCAD13001e19176D5c847 

**Purpose**:  
- Native token for staking and rewards  
- Utility token across the Ridera protocol  

---

### 2. Proof Registry
*Address:* 0x936e406dAD13Aa55ff747e80Bd1D9e630AB1B5d7
*Purpose:*  
- Stores cycleId → (merkleRoot, totalSRU, timestamp)  
- Receives SRU data from SRU Engine or admin  
- Source of truth for Yield Vault

---

### 3. Yield Vault  
*Address:* 0x51e962361F4FCcC50ccf9d02367AbD40169D28eB 

*Purpose:*  
- Reads cycle data from Proof Registry  
- Calculates daily RDRT rewards  
- Sends reward distribution data to Staking contract

---

### 4. Staking  
Address: 0x46be8561fCf74a2D63AeaE25981aE3F74ad88F8e 

Purpose:  
- Users stake RDRT  
- Tracks user stake & stake timestamps  
- Receives reward data from Yield Vault  
- Users claim accumulated rewards

---

## 🔧 Upcoming Contract Deployments (Not deployed yet)
These will be added in the public testnet stage:

- Faucet Contract  
- Governance Contract  
- SRU Engine Oracle  
- Reward Distributor (final version)

---

## ⚠ Notes
- All contracts listed here are for *beta testing only*.  
- Addresses will change during Public Testnet launch.  
- These contracts are *not audited* and not intended for mainnet use.  

---

## 📌 Next Updates
This file will be updated to include:
- Testnet deployment addresses  
- ABI references  
- Explorer verification links  
- Upgrade logs  

---

# Ridera Protocol © 2025
