const CowlDaoBase = artifacts.require("CowlDaoBase");
const CowlDaoToken = artifacts.require("CowlDaoToken");
const WaningLightBase = artifacts.require("WaningLightBase");

module.exports = async function (deployer, network, accounts) {
  // Deploy CowlDaoToken and WaningLightBase first if they aren't deployed yet
  await deployer.deploy(CowlDaoToken /* constructor arguments */);
  await deployer.deploy(WaningLightBase /* constructor arguments */);

  // Get deployed addresses
  const cowlDaoTokenAddress = CowlDaoToken.address;
  const waningLightBaseAddress = WaningLightBase.address;

  // Deploy CowlDaoBase
  await deployer.deploy(CowlDaoBase);
  const cowlDaoBase = await CowlDaoBase.deployed();

  // Initialize CowlDaoBase with the addresses of CowlDaoToken and WaningLightBase
  await cowlDaoBase.initialize(cowlDaoTokenAddress, waningLightBaseAddress);
};

// const CowlDaoBase = artifacts.require("CowlDaoBase");
// const CowlDaoTokenOne = artifacts.require("CowlDaoTokenOne");
// const CowlDaoTokenTwo = artifacts.require("CowlDaoTokenTwo");
// const WaningLightBase = artifacts.require("WaningLightBase");

// module.exports = async function (deployer, network, accounts) {
//   // Deploy CowlDaoTokenOne, CowlDaoTokenTwo, and WaningLightBase first if they aren't deployed yet
//   await deployer.deploy(CowlDaoTokenOne /* constructor arguments */);
//   await deployer.deploy(CowlDaoTokenTwo /* constructor arguments */);
//   await deployer.deploy(WaningLightBase /* constructor arguments */);

//   // Get deployed addresses
//   const cowlDaoTokenOneAddress = CowlDaoTokenOne.address;
//   const cowlDaoTokenTwoAddress = CowlDaoTokenTwo.address;
//   const waningLightBaseAddress = WaningLightBase.address;

//   // Deploy CowlDaoBase
//   await deployer.deploy(CowlDaoBase);
//   const cowlDaoBase = await CowlDaoBase.deployed();

//   // Initialize CowlDaoBase with the addresses of CowlDaoTokenOne, CowlDaoTokenTwo, and WaningLightBase
//   await cowlDaoBase.initialize(
//     cowlDaoTokenOneAddress,
//     cowlDaoTokenTwoAddress,
//     waningLightBaseAddress
//   );
// };
