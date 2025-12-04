# Ridera Protocol – Beta Deployment Overview

This document contains the temporary beta contract deployments used for internal 
and community testing. These contracts are NOT final and will be redeployed 
before Testnet Public and Mainnet launch.

---

## 🚀 Current Beta Contracts

### 1. RDRT Token (ERC20)
**Address**: 0x3d6a3a22A4670594878c71cFcE1eF3d28E170591 

**Purpose**:  
- Native token for staking and rewards  
- Utility token across the Ridera protocol  

---

### 2. Proof Registry
*Address:* 0x366692Ef6a728062CC559f8b1f46cE64448f528d 

*Purpose:*  
- Stores cycleId → (merkleRoot, totalSRU, timestamp)  
- Receives SRU data from SRU Engine or admin  
- Source of truth for Yield Vault

---

### 3. Yield Vault  
*Address:* 0x5916E2e4e60ad57796345C1eb09313228D575572   
*Purpose:*  
- Reads cycle data from Proof Registry  
- Calculates daily RDRT rewards  
- Sends reward distribution data to Staking contract

---

### 4. Staking  
Address: 0x9A24878749E8591Ad4CB7a010e98699684788a7c 
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
