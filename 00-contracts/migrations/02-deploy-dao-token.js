// 2_deploy_cowl_token.js
const CowlToken = artifacts.require(
  "../dao/cowl-dao-token/01-cowl-dao-token.sol"
);
const RewardDistribution = artifacts.require(
  "../dao/cowl-dao-token/02-cowl-dao-token-treasury.sol"
);
const VestingContract = artifacts.require(
  "../dao/cowl-dao-token/03-cowl-dao-token-vesting.sol"
);
const LiquidityPool = artifacts.require(
  "../dao/cowl-dao-token/04-cowl-dao-token-liquidity-pool.sol"
);

module.exports = async function (deployer, network, accounts) {
  // Step 1: Deploy CowlToken
  await deployer.deploy(CowlToken, "CowlToken", "COWL");
  const cowlToken = await CowlToken.deployed();

  // Step 2: Deploy RewardDistribution
  await deployer.deploy(RewardDistribution);
  const rewardDistribution = await RewardDistribution.deployed();
  await rewardDistribution.initialize(cowlToken.address, accounts[0]); // Assuming accounts[0] is the owner.

  // Step 3: Deploy VestingContract
  await deployer.deploy(VestingContract);
  const vestingContract = await VestingContract.deployed();
  await vestingContract.initialize(
    cowlToken.address,
    SOME_VESTING_DURATION,
    accounts[0]
  ); // Replace SOME_VESTING_DURATION with the desired duration in seconds.

  // Step 4: Deploy LiquidityPool
  await deployer.deploy(LiquidityPool);
  const liquidityPool = await LiquidityPool.deployed();
  // Assuming there's another token you'd like to use for the pool
  const OTHER_TOKEN_ADDRESS = "0x..."; // Replace this with the desired token's address
  await liquidityPool.initialize(cowlToken.address, OTHER_TOKEN_ADDRESS);
};
