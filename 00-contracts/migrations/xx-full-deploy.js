// Importing contract artifacts
const CowlDAOToken = artifacts.require("CowlDAOToken");
const CowlDAOTokenTreasury = artifacts.require("CowlDAOTokenTreasury");
const CowlDAOTokenVesting = artifacts.require("CowlDAOTokenVesting");
const CowlDAOTokenLiqPool = artifacts.require("CowlDAOTokenLiqPool");

const WaningLightBase = artifacts.require("WaningLightBase");
const Metadata = artifacts.require("Metadata");
const Minting = artifacts.require("Minting");

const CowlDaoBase = artifacts.require("CowlDaoBase");

module.exports = async function (deployer, network, accounts) {
  // Deploy and chain CowlDAOToken and related contracts
  await deployer
    .deploy(CowlDAOToken)
    .then(() => deployer.deploy(CowlDAOTokenTreasury, CowlDAOToken.address))
    .then(() => deployer.deploy(CowlDAOTokenVesting, CowlDAOToken.address))
    .then(() => deployer.deploy(CowlDAOTokenLiqPool, CowlDAOToken.address));

  // Deploy and chain WaningLightBase and related contracts
  await deployer
    .deploy(WaningLightBase)
    .then(() => deployer.deploy(Metadata, WaningLightBase.address))
    .then(() =>
      deployer.deploy(Minting, WaningLightBase.address, Metadata.address)
    );

  // Deploy CowlDaoBase with addresses of CowlDAOToken and WaningLightBase, then chain its related contracts
  await deployer
    .deploy(CowlDaoBase, CowlDAOToken.address, WaningLightBase.address)
    .then(() => {
      // Add any related contracts for CowlDaoBase here, if needed
    });
};
