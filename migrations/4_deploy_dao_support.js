const CowlDaoGovernance = artifacts.require("CowlDaoGovernance");
const WaningLightMinting = artifacts.require("WaningLightMinting");
const WaningLightMetadata = artifacts.require("WaningLightMetadata");

const CowlDaoToken = artifacts.require("CowlDaoToken");
const WaningLightBase = artifacts.require("WaningLightBase");

module.exports = async function (deployer, network, accounts) {
  // Retrieve already deployed contract addresses
  const cowlDaoTokenAddress = CowlDaoToken.address;
  const waningLightBaseAddress = WaningLightBase.address;

  // Deploy CowlDaoGovernance and initialize it with CowlDaoToken's address
  await deployer.deploy(CowlDaoGovernance, cowlDaoTokenAddress);
  const cowlDaoGovernance = await CowlDaoGovernance.deployed();

  // Deploy WaningLightMetadata and initialize it with WaningLightBase's address
  await deployer.deploy(WaningLightMetadata, waningLightBaseAddress);
  const waningLightMetadata = await WaningLightMetadata.deployed();

  // Deploy WaningLightMinting and initialize it with WaningLightBase's and WaningLightMetadata's addresses
  await deployer.deploy(
    WaningLightMinting,
    waningLightBaseAddress,
    waningLightMetadata.address
  );
  const waningLightMinting = await WaningLightMinting.deployed();
};
