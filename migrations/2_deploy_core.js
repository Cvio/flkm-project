const CowlToken = artifacts.require("CowlToken"); // Replace "CoreContract" with the actual name of your core contract

module.exports = function (deployer) {
  deployer.deploy(CowlToken);
};
