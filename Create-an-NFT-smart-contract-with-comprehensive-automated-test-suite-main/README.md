
# ERC-721 NFT Smart Contract with Automated Test Suite

This project implements an **ERC-721–compatible NFT smart contract** using **Solidity** and **Hardhat**, along with a **comprehensive automated test suite** and a **Dockerized environment** for reproducible testing.

The goal of this project is to demonstrate correct NFT contract design, testing of edge cases, and containerized execution of tests without manual setup.

---

##  Project Structure

```

.
├── contracts/
│ └── NftCollection.sol # ERC-721 NFT smart contract
├── test/
│ └── NftCollection.test.js # Automated test suite
├── scripts/ # Hardhat scripts (default)
├── Dockerfile # Docker configuration
├── hardhat.config.js # Hardhat configuration
├── package.json # Node.js dependencies
├── package-lock.json
└── README.md # Project documentation

```
---

##  Features

- ERC-721–compatible NFT contract
- Admin-only minting
- Maximum supply enforcement
- Token ownership, transfers, and approvals
- Metadata handling via ```tokenURI```
- Comprehensive automated tests
- Docker container that installs dependencies and runs tests by default

---

##  Prerequisites (Local)

If you want to run the project **without Docker**, you need:

- **Node.js**: v18.x 
- **npm**: comes with Node.js
- **Git**

> Newer Node.js versions may show warnings with Hardhat but will still work.

---

##  Running Tests Locally 

Install dependencies:

```bash
npm install


Run tests:

npx hardhat test


Expected output:

8 passing
0 failing

Running Tests with Docker

The Docker setup ensures a clean, reproducible environment with no manual dependency installation.

1️. Build the Docker Image
docker build -t nft-test-suite .

2️. Run the Container
docker run --rm nft-test-suite

Output:

NftCollection
  ✓ should initialize with correct name, symbol, and supply
  ✓ should allow only admin to mint
  ✓ should mint a token and update balances
  ✓ should revert when minting beyond max supply
  ✓ should transfer token correctly
  ✓ should revert when transferring non-existent token
  ✓ should allow approved address to transfer token
  ✓ should return correct token URI

8 passing
0 failing
```
# Tooling & Versions

Solidity: ^0.8.20

Hardhat: ^2.22.0

Ethers.js: v6

Chai: v4

Docker Base Image: node:18-alpine

## Assumptions

Token IDs are provided externally during minting

Metadata is served via a base URI pattern:

https://example.com/metadata/1.json


No on-chain enumeration (ERC721Enumerable) is implemented

Safe transfer checks for ERC721Receiver are omitted for simplicity

## Outcomes

Fully functional ERC-721 NFT smart contract

Reliable ownership, balance, and approval model

Automated test suite covering normal and edge cases

Dockerized test execution for clean evaluation

Clear revert behavior and predictable errors


---
