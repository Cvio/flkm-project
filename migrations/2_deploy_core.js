const CowlToken = artifacts.require("CowlToken");
const CowlMarketplaceBase = artifacts.require("CowlMarketplaceBase");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(CowlToken);
  const cowlToken = await CowlToken.deployed();

  // deploy the marketplace
  await deployer.deploy(CowlMarketplaceBase);
  const cowlMarketplaceBase = await CowlMarketplaceBase.deployed();

  // initialize the marketplace with the address of the token
  await cowlMarketplaceBase.initialize(cowlToken.address);
};
