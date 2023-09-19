require("dotenv").config();

const {
  Client,
  AccountId,
  PrivateKey,
  TokenCreateTransaction,
  FileCreateTransaction,
  FileAppendTransaction,
  ContractCreateTransaction,
  ContractFunctionParameters,
  TokenUpdateTransaction,
  ContractExecuteTransaction,
  TokenInfoQuery,
  AccountBalanceQuery,
} = require("@hashgraph/sdk");
const fs = require("fs");

const operatorId = AccountId.fromString(process.env.OPERATOR_ID);
const operatorKey = PrivateKey.fromString(process.env.OPERATOR_PVKEY);
const treasuryId = AccountId.fromString(process.env.TREASURY_ID);
const treasuryKey = PrivateKey.fromString(process.env.TREASURY_PVKEY);
const aliceId = AccountId.fromString(process.env.ALICE_ID);
const aliceKey = PrivateKey.fromString(process.env.ALICE_PVKEY);

const client = Client.forTestnet().setOperator(operatorId, operatorKey);

async function queryTokenInfo(tokenId) {
  let info = await new TokenInfoQuery().setTokenId(tokenId).execute(client);
  return info;
}

async function queryAccountBalance(accountId, tokenId) {
  let balanceCheckTx = await new AccountBalanceQuery()
    .setAccountId(accountId)
    .execute(client);
  return balanceCheckTx.tokens._map.get(tokenId.toString());
}

async function main() {
  const tokenCreateTx = await new TokenCreateTransaction()
    .setTokenName("My new Token!")
    .setTokenSymbol("MNT")
    .setDecimals(0)
    .setInitialSupply(100)
    .setTreasuryAccountId(treasuryId)
    .setAdminKey(treasuryKey)
    .setSupplyKey(treasuryKey)
    .freezeWith(client)
    .sign(treasuryKey);
  const tokenCreateSubmit = await tokenCreateTx.execute(client);
  const tokenCreateRx = await tokenCreateSubmit.getReceipt(client);
  const tokenId = tokenCreateRx.tokenId;
  const tokenAddressSol = tokenId.toSolidityAddress();
  console.log(`- Token ID: ${tokenId}`);
  console.log(`- Token ID in Solidity format: ${tokenAddressSol}`);

  const tokenInfo1 = await queryTokenInfo(tokenId);
  console.log(`- Initial token supply: ${tokenInfo1.totalSupply.low} \n`);

  const bytecode = fs.readFileSync("./TestToken_sol_TestToken.bin");
  const fileCreateTx = new FileCreateTransaction()
    .setKeys([treasuryKey])
    .freezeWith(client);
  const fileCreateSign = await fileCreateTx.sign(treasuryKey);
  const fileCreateSubmit = await fileCreateSign.execute(client);
  const fileCreateRx = await fileCreateSubmit.getReceipt(client);
  const bytecodeFileId = fileCreateRx.fileId;
  console.log(`- The smart contract bytecode file ID is ${bytecodeFileId}`);

  const fileAppendTx = new FileAppendTransaction()
    .setFileId(bytecodeFileId)
    .setContents(bytecode)
    .setMaxChunks(10)
    .freezeWith(client);
  const fileAppendSign = await fileAppendTx.sign(treasuryKey);
  const fileAppendSubmit = await fileAppendSign.execute(client);
  const fileAppendRx = await fileAppendSubmit.getReceipt(client);
  console.log(`- Content added: ${fileAppendRx.status} \n`);

  const contractInstantiateTx = new ContractCreateTransaction()
    .setBytecodeFileId(bytecodeFileId)
    .setGas(3000000)
    .setConstructorParameters(
      new ContractFunctionParameters().addAddress(tokenAddressSol)
    );
  const contractInstantiateSubmit = await contractInstantiateTx.execute(client);
  const contractInstantiateRx = await contractInstantiateSubmit.getReceipt(
    client
  );
  const contractId = contractInstantiateRx.contractId;
  const contractAddress = contractId.toSolidityAddress();
  console.log(`- The smart contract ID is: ${contractId}`);
  console.log(
    `- The smart contract ID in Solidity format is: ${contractAddress} \n`
  );

  const tokenInfo2p1 = await queryTokenInfo(tokenId);
  console.log(`- Token supply key: ${tokenInfo2p1.supplyKey.toString()}`);

  const tokenUpdateTx = await new TokenUpdateTransaction()
    .setTokenId(tokenId)
    .setSupplyKey(contractId)
    .freezeWith(client)
    .sign(treasuryKey);
  const tokenUpdateSubmit = await tokenUpdateTx.execute(client);
  const tokenUpdateRx = await tokenUpdateSubmit.getReceipt(client);
  console.log(`- Token update status: ${tokenUpdateRx.status}`);

  const tokenInfo2p2 = await queryTokenInfo(tokenId);
  console.log(`- Token supply key: ${tokenInfo2p2.supplyKey.toString()} \n`);

  const contractExecTx = await new ContractExecuteTransaction()
    .setContractId(contractId)
    .setGas(3000000)
    .setFunction(
      "mintFungibleToken",
      new ContractFunctionParameters().addUint64(150)
    );
  const contractExecSubmit = await contractExecTx.execute(client);
  const contractExecRx = await contractExecSubmit.getReceipt(client);
  console.log(`- New tokens minted: ${contractExecRx.status.toString()}`);

  const tokenInfo3 = await queryTokenInfo(tokenId);
  console.log(`- New token supply: ${tokenInfo3.totalSupply.low} \n`);

  const contractExecTx1 = await new ContractExecuteTransaction()
    .setContractId(contractId)
    .setGas(3000000)
    .setFunction(
      "tokenAssociate",
      new ContractFunctionParameters().addAddress(aliceId.toSolidityAddress())
    )
    .freezeWith(client);
  const contractExecSign1 = await contractExecTx1.sign(aliceKey);
  const contractExecSubmit1 = await contractExecSign1.execute(client);
  const contractExecRx1 = await contractExecSubmit1.getReceipt(client);
  console.log(
    `- Token association with Alice's account: ${contractExecRx1.status.toString()} \n`
  );

  const contractExecTx2 = await new ContractExecuteTransaction()
    .setContractId(contractId)
    .setGas(3000000)
    .setFunction(
      "tokenTransfer",
      new ContractFunctionParameters()
        .addAddress(treasuryId.toSolidityAddress())
        .addAddress(aliceId.toSolidityAddress())
        .addInt64(50)
    )
    .freezeWith(client);
  const contractExecSign2 = await contractExecTx2.sign(treasuryKey);
  const contractExecSubmit2 = await contractExecSign2.execute(client);
  const contractExecRx2 = await contractExecSubmit2.getReceipt(client);

  console.log(
    `- Token transfer from Treasury to Alice: ${contractExecRx2.status.toString()}`
  );

  const treasuryBalance = await queryAccountBalance(treasuryId, tokenId);
  const aliceBalance = await queryAccountBalance(aliceId, tokenId);
  console.log(
    `- Treasury balance: ${treasuryBalance} units of token ${tokenId}`
  );
  console.log(`- Alice balance: ${aliceBalance} units of token ${tokenId} \n`);
}

main();
