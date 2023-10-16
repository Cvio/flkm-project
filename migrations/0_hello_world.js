const { deployProxy } = require("@openzeppelin/truffle-upgrades");
const HelloWorld = artifacts.require("HelloWorld");

module.exports = async function (deployer) {
  const instance = await deployProxy(HelloWorld, ["Hello, World!"], {
    deployer,
    initializer: "initialize",
  });
  console.log("Deployed", instance.address);
};
