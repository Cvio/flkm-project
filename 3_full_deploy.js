// Importing contract artifacts
const CowlDAOToken = artifacts.require(
  "../../00-contracts/dao/cowl-dao-token/CowlDaoToken"
);
const CowlDAOTokenTreasury = artifacts.require(
  "../../00-contracts/dao/cowl-dao-token/RewardDistribution"
);
const CowlDAOTokenVesting = artifacts.require(
  "../../00-contracts/dao/cowl-dao-token/Vesting"
);
const CowlDAOTokenLiqPool = artifacts.require(
  "../../00-contracts/dao/cowl-dao-token/LiquidityPool"
);

const WaningLightBase = artifacts.require(
  "../../00-contracts/dao/cowl-membership-nft/WaningLightBase"
);
const Metadata = artifacts.require(
  "../../00-contracts/dao/cowl-membership-nft/WaningLightMetadata"
);
const Minting = artifacts.require(
  "../../00-contracts/dao/cowl-membership-nft/WaningLightMinting"
);

const CowlDaoBase = artifacts.require(
  "../../00-contracts/dao/cowl-dao/CowlDaoBase"
);

// module.exports = async function (deployer, network, accounts) {
//   // Deploy and chain CowlDAOToken and related contracts
//   await deployer
//     .deploy(CowlDAOToken)
//     .then(() => deployer.deploy(CowlDAOTokenTreasury, CowlDAOToken.address))
//     .then(() => deployer.deploy(CowlDAOTokenVesting, CowlDAOToken.address))
//     .then(() => deployer.deploy(CowlDAOTokenLiqPool, CowlDAOToken.address));

//   // Deploy and chain WaningLightBase and related contracts
//   await deployer
//     .deploy(WaningLightBase)
//     .then(() => deployer.deploy(Metadata, WaningLightBase.address))
//     .then(() =>
//       deployer.deploy(Minting, WaningLightBase.address, Metadata.address)
//     );

//   // Deploy CowlDaoBase with addresses of CowlDAOToken and WaningLightBase, then chain its related contracts
//   await deployer
//     .deploy(CowlDaoBase, CowlDAOToken.address, WaningLightBase.address)
//     .then(() => {
//       // Add any related contracts for CowlDaoBase here, if needed
//     });
// };
