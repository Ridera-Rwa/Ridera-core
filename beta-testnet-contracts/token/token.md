# Ridera Test Token (RDRT)


## Deployment Information
**Name:** Ridera test token
**Path:** contracts/token/RideraTestToken.sol  
**Network:** Base Testnet only  
**Status:** Beta
**Contract Address:**  
`0x9d28d89fE48ff7cC6ADBCAD13001e19176D5c847`

⚠️ Testnet deployment only. Address will change before mainnet.

---

## Overview
RideraTestToken is a **testnet-only ERC20 token** used during the Ridera beta phase.
It supports **daily user minting** and **owner-controlled minting** for testing
rewards, staking flows, and protocol mechanics.

⚠️ This contract is **NOT intended for mainnet use**.

---

## Token Details
- Name: Ridera Test Token
- Symbol: RDRT
- Decimals: 18
- Standard: ERC20

---

## Features

### Daily Claim Minting
Users can mint a fixed amount of tokens once per cooldown period.

- Default daily mint: `550 RDRT`
- Cooldown: `24 hours`
- Enforced per wallet

### Owner Minting
The contract owner can mint tokens for:
- Reward pools
- Staking simulations
- System testing

### Configurable Parameters
Owner can update:
- Daily mint amount
- Cooldown duration

---

## Security & Limitations
- No supply cap (testnet only)
- Owner has minting privileges
- Not audited
- Logic subject to change

---

## Mainnet Disclaimer
This contract will **not** be deployed to mainnet.
Mainnet token contracts will include:
- Fixed or governed supply
- Audited logic
- No unrestricted minting
