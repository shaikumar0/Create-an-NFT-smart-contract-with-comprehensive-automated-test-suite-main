const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NftCollection", function () {
  let nft;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    const NftCollection = await ethers.getContractFactory("NftCollection");
    nft = await NftCollection.deploy("MyNFT", "MNFT", 100);
    await nft.waitForDeployment();
  });

  it("should initialize with correct name, symbol, and supply", async function () {
    expect(await nft.name()).to.equal("MyNFT");
    expect(await nft.symbol()).to.equal("MNFT");
    expect(await nft.maxSupply()).to.equal(100n);
    expect(await nft.totalSupply()).to.equal(0n);
  });

  it("should allow only admin to mint", async function () {
    try {
      await nft.connect(addr1).safeMint(addr1.address, 1);
      expect.fail("Expected revert");
    } catch (err) {
      expect(err).to.exist;
    }
  });

  it("should mint a token and update balances", async function () {
    await nft.safeMint(addr1.address, 1);

    expect(await nft.totalSupply()).to.equal(1n);
    expect(await nft.balanceOf(addr1.address)).to.equal(1n);
    expect(await nft.ownerOf(1)).to.equal(addr1.address);
  });

  it("should revert when minting beyond max supply", async function () {
    for (let i = 1; i <= 100; i++) {
      await nft.safeMint(owner.address, i);
    }

    try {
      await nft.safeMint(owner.address, 101);
      expect.fail("Expected revert");
    } catch (err) {
      expect(err).to.exist;
    }
  });

  it("should transfer token correctly", async function () {
    await nft.safeMint(owner.address, 1);
    await nft.transferFrom(owner.address, addr1.address, 1);

    expect(await nft.ownerOf(1)).to.equal(addr1.address);
    expect(await nft.balanceOf(owner.address)).to.equal(0n);
    expect(await nft.balanceOf(addr1.address)).to.equal(1n);
  });

  it("should revert when transferring non-existent token", async function () {
    try {
      await nft.transferFrom(owner.address, addr1.address, 999);
      expect.fail("Expected revert");
    } catch (err) {
      expect(err).to.exist;
    }
  });

  it("should allow approved address to transfer token", async function () {
    await nft.safeMint(owner.address, 1);
    await nft.approve(addr1.address, 1);
    await nft.connect(addr1).transferFrom(owner.address, addr2.address, 1);

    expect(await nft.ownerOf(1)).to.equal(addr2.address);
  });

  it("should return correct token URI", async function () {
    await nft.safeMint(owner.address, 1);
    const uri = await nft.tokenURI(1);
    expect(uri).to.equal("https://example.com/metadata/1.json");
  });
});