# 🐞 Ridera Protocol – Bug Bounty Program

The Ridera Protocol bug bounty program rewards security researchers who help keep our ecosystem safe.  
We appreciate responsible disclosure and will reward impactful findings.

This program covers all Ridera smart contracts, backend services, and frontend code.

---

## 🎯 Scope

### ✔ In-Scope Targets

#### *Smart Contracts*
- Proof Registry  
- Yield Vault  
- Staking  
- SRU Engine  
- Faucet, SRU Reward Logic  
- Any Ridera contracts deployed on testnet or beta

#### *Web Application*
- https://ridera.xyz  
- Beta Panel  
- Dashboard, Staking UI, SRU UI  
- Contract interaction modules

#### *Backend / API*
- ridera API endpoints  
- SRU data submission endpoints  
- Staking/yield calculation endpoints  

---

## ❌ Out of Scope

The following are *NOT* valid for bounty rewards:

- UI/UX issues with no security impact  
- Missing rate-limits unless exploitable  
- Self-inflicted XSS (self-XSS)  
- Email spoofing without a real exploit  
- Old/unused testnet contracts  
- Bugs requiring root/jailbreak of device  
- Best-practice recommendations without direct security risk  

---

## 🧪 Allowed Testing Rules

- Only test on *beta/testnet* contracts  
- Never exploit vulnerabilities to cause real damage  
- Never access or modify other users’ data  
- Never perform DoS or spam attacks  
- Use test accounts, not mainnet wallets  

Following these ensures bounty eligibility.

---

## 🏆 Rewards

Rewards are based on severity per CVSS + protocol impact.

| Severity | Description | Example | Reward |
|----------|-------------|---------|--------|
| *Critical* | Fund loss, theft, takeover | Reentrancy, broken access control | Up to *$2,000* or RDRT |
| *High* | Major manipulation or shutdown | Unauthorized cycle modification | $500–$1,000 or RDRT |
| *Medium* | Data leakage or bypass | API auth bypass | $100–$300 or RDRT |
| *Low* | Minor issue with some risk | Incorrect error handling | Recognition or RDRT |

Rewards may increase depending on impact and quality of report.

---

## 📝 How to Submit a Vulnerability

Email: *contact.ridera@gmail.com*

Include:

- Description  
- Steps to reproduce  
- Contract/file/endpoint affected  
- Impact explanation  
- Suggested fix (optional)  
- Wallet for bounty  
- Screenshots / PoC  

---

## 🔒 Responsible Disclosure

- Do *not* publicly disclose before a fix  
- Do *not* exploit the bug  
- Ridera team will respond within *48 hours*  

---

## 🤝 Acknowledgements

Researchers who submit valid findings may be listed on our *Security Hall of Fame* (optional).

---

Thank you for helping secure the Ridera ecosystem!
