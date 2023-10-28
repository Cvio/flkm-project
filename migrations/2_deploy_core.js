const CowlToken = artifacts.require("CowlToken");
const CowlMarketplaceBase = artifacts.require("CowlMarketplaceBase");
const ReputationNFT = artifacts.require("ReputationNFT");

module.exports = async function (deployer, network, accounts) {
  // Deploy and initialize the CowlToken
  await deployer.deploy(CowlToken, "CowlToken", "COWL");
  const cowlToken = await CowlToken.deployed();
  // Initialize the token
  await cowlToken.initialize(
    "CowlToken", // _name
    "COWL", // _symbol
    18, // _decimals
    10000000, // _initialSupply
    "0xeB6B42BFA9BCB83a72453AA2ef4D414BB9848b08" // admin address
  );

  // Deploy and initialize the CowlMarketplaceBase
  await deployer.deploy(CowlMarketplaceBase);
  const cowlMarketplaceBase = await CowlMarketplaceBase.deployed();
  await cowlMarketplaceBase.initialize("CowlMarketplace", cowlToken.address); // Initialize with name, token address, and admin account

  // Deploy and initialize the ReputationNFT
  await deployer.deploy(ReputationNFT);
  const reputationNFT = await ReputationNFT.deployed();
  await reputationNFT.initialize(cowlMarketplaceBase.address); // Initialize with marketplace address and admin account
};
