const WaningLightBase = artifacts.require(
  "../dao/cowl-membership-nft/01-waning-light-base.sol"
);
const WaningLightMetadata = artifacts.require(
  "../dao/cowl-membership-nft/02-waning-light-metadata.sol"
);
const WaningLightMinting = artifacts.require(
  "../dao/cowl-membership-nft/03-waning-light-minting.sol"
);

module.exports = function (deployer) {
  let baseInstance, metadataInstance;

  deployer
    .then(() => {
      return WaningLightBase.deployed();
    })
    .then((instance) => {
      baseInstance = instance;
      return WaningLightMetadata.deployed();
    })
    .then((instance) => {
      metadataInstance = instance;
      return deployer.deploy(
        WaningLightMinting,
        baseInstance.address,
        metadataInstance.address
      );
    });
};
