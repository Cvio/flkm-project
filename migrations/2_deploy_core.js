const CowlToken = artifacts.require("CowlToken");
const CowlMarketplaceBase = artifacts.require("CowlMarketplaceBase");
const ReputationNFT = artifacts.require("ReputationNFT");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(CowlToken);
  const cowlToken = await CowlToken.deployed();

  // deploy the marketplace
  await deployer.deploy(CowlMarketplaceBase);
  const cowlMarketplaceBase = await CowlMarketplaceBase.deployed();

  // initialize the marketplace with the address of the token
  await cowlMarketplaceBase.initialize("CowlMarketplace", cowlToken.address);
  const cowlMarketplaceBaseAddress = await cowlMarketplaceBase.address;

  // deploy and initialize the ReputationNFT contract with the address of the marketplace
  await deployer.deploy(ReputationNFT);
  const reputationNFT = await ReputationNFT.deployed();

  await reputationNFT.initialize(cowlMarketplaceBaseAddress);
};
