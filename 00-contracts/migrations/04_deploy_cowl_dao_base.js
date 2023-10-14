// 4_deploy_cowl_dao_base.js
const CowlDaoBase = artifacts.require(
  "../dao/cowl-dao-base/01-cowl-dao-base.sol"
);
const CowlToken = artifacts.require("../dao/cow-token/01-cowl-dao-token.sol");
const WaningLight = artifacts.require(
  "../dao/cowl-membership-nft/01-waning-light-base.sol"
);

module.exports = function (deployer) {
  let tokenInstance, waningLightInstance;

  deployer
    .then(() => {
      return CowlToken.deployed();
    })
    .then((instance) => {
      tokenInstance = instance;
      return WaningLight.deployed();
    })
    .then((instance) => {
      waningLightInstance = instance;
      return deployer.deploy(
        CowlDaoBase,
        tokenInstance.address,
        waningLightInstance.address
      );
    });
};
