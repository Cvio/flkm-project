const DaoContract1 = artifacts.require(
  "../dao/cow-token/01-cowl-dao-token.sol"
);
const DaoContract2 = artifacts.require(
  "../dao/cow-token/02-cowl-dao-token-treasury.sol"
);
const DaoContract3 = artifacts.require(
  "../dao/cow-token/03-cowl-dao-token-vesting.sol"
);
const DaoContract4 = artifacts.require(
  "../dao/cow-token/04-cowl-dao-token-liq-pool.sol"
);
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );
// const DaoContract1 = artifacts.require(
//   "../dao/cow-token/01-cowl-dao-token.sol"
// );

// if no chaining is needed and these contracts are independent of each other
// if constructor needs params: deployer.deploy(DaoContract1, param1, param2);
// module.exports = function (deployer) {
//   deployer.deploy(DaoContract1);
//   deployer.deploy(DaoContract2);
//   deployer.deploy(DaoContract3);
//   deployer.deploy(DaoContract4);
// };

// if chaining is needed and these contracts are dependent on order
// if constructor needs params: deployer.deploy(DaoContract1, param1, param2);
module.exports = function (deployer) {
  deployer
    .deploy(DaoContract1) // params are hard-coded in the contract
    .then(() => deployer.deploy(DaoContract2, DaoContract1.address))
    .then(() => deployer.deploy(DaoContract3, DaoContract2.address))
    .then(() => deployer.deploy(DaoContract4));
};
