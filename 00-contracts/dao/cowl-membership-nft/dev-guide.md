# Developer's Guide: Interacting with WaningLight Contracts

## Prerequisites:

- Solidity and Ethereum understanding.
- Development setup: [Remix](https://remix.ethereum.org/), [Truffle](https://www.trufflesuite.com/), or [Hardhat](https://hardhat.org/).
- [MetaMask](https://metamask.io/) or another web3 provider.
- Deployed instances of `WaningLightBase`, `WaningLightMetadata`, and `WaningLightMinting` contracts.

## Contract Interaction:

### 1. Web3 Setup:

- const Web3 = require('web3');
- const web3 = new Web3('YOUR_ETHEREUM_NODE_URL');

### 2. Contract Initialization:

For each contract, you will need its ABI (Application Binary Interface) and its deployed address.

- const waningLightBase = new web3.eth.Contract(WaningLightBaseABI, 'WANING_LIGHT_BASE_DEPLOYED_ADDRESS');
- const waningLightMetadata = new web3.eth.Contract(WaningLightMetadataABI, 'WANING_LIGHT_METADATA_DEPLOYED_ADDRESS');
- const waningLightMinting = new web3.eth.Contract(WaningLightMintingABI, 'WANING_LIGHT_MINTING_DEPLOYED_ADDRESS');

### 3. Interacting with WaningLightBase:

To mint a new token:

- waningLightBase.methods.mint('RECIPIENT_ADDRESS').send({ from: 'YOUR_ADDRESS' });

To burn a token:

- waningLightBase.methods.burn('TOKEN_ID').send({ from: 'YOUR_ADDRESS' });

To mint a token with a specific URI:

- waningLightBase.methods.mintWithTokenURI('RECIPIENT_ADDRESS', 'TOKEN_URI').send({ from: 'YOUR_ADDRESS' });

### 4. Interacting with WaningLightMetadata:

To set details for a specific token:
"waningLightMetadata.methods.setTokenDetails('TOKEN_ID', 'TOKEN_DETAILS').send({ from: 'YOUR_ADDRESS' });

To fetch details for a specific token:

- waningLightMetadata.methods.tokenDetails('TOKEN_ID').call();

### 5. Interacting with WaningLightMinting:

To mint a new NFT after sending the appropriate ether:

- waningLightMinting.methods.mintNFT('RECIPIENT_ADDRESS').send({ from: 'YOUR_ADDRESS', value: 'MINT_PRICE_IN_WEI' });

To adjust the mint price:

- waningLightMinting.methods.setMintPrice('NEW_MINT_PRICE').send({ from: 'YOUR_ADDRESS' });

To pause or resume the minting process:

- waningLightMinting.methods.pauseSale().send({ from: 'YOUR_ADDRESS' });
- waningLightMinting.methods.unpauseSale().send({ from: 'YOUR_ADDRESS' });

### 6. Error Handling and Confirmation:

Always ensure you handle errors gracefully. Web3.js provides error handlers you can use to handle transaction rejections or confirmations. Here's a basic example:

- waningLightBase.methods.mint('RECIPIENT_ADDRESS').send({ from: 'YOUR_ADDRESS' }).on('confirmation', (confirmationNumber, receipt) => { console.log('Confirmed:', confirmationNumber); }).on('error', (error) => { console.error('Error:', error.message); });
