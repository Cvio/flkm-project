# WaningLight NFT Contracts Knowledge Base

## 1. **WaningLightBase Contract**

### Attributes:

- `_tokenIdCounter`: Keeps track of the current token ID, ensuring each minted token has a unique ID.

### Functions:

- `mint(address to)`: Mints a new token and sends it to the specified address, only callable by the owner.
- `burn(uint256 tokenId)`: Destroys the token with the given ID, only callable by the owner.
- `mintWithURI(address to, string memory tokenURI)`: Mints a new token with a specific URI and sends it to the specified address, only callable by the owner.

### Purpose:

- It serves as the foundational contract, allowing for basic operations such as minting and burning of tokens.

## 2. **WaningLightMetadata Contract**

### Attributes:

- `_tokenDetails`: A mapping to store the details of each token based on their token ID.
- `waningLightBase`: Reference to the WaningLightBase contract.

### Functions:

- `setTokenDetails(uint256 tokenId, string memory details)`: Sets the details for a specific token, only callable by the owner.
- `tokenDetails(uint256 tokenId)`: Retrieves the details of a specific token.
- `tokenURI(uint256 tokenId)`: Retrieves the URI of a specific token, combining it with details from `_tokenDetails`.

### Purpose:

- Manages metadata and details for each token, ensuring that the information is stored and can be retrieved as needed.

## 3. **MetadataLogicContract Contract**

### Attributes:

- `_tokenURIs`: A mapping to store the URI of each token based on their token ID.
- `_baseURIExtended`: Holds the base URI for tokens.

### Functions:

- `setBaseURI(string memory baseURI_)`: Sets the base URI, only callable by the owner.
- `tokenURI(uint256 tokenId)`: Retrieves the URI of a specific token, combining it with `_baseURIExtended` if necessary.
- `setTokenURI(uint256 tokenId, string memory uri)`: Sets the URI for a specific token, only callable by the owner.

### Purpose:

- Responsible for managing and configuring the base URI and individual token URIs.

## 4. **WaningLightMinting Contract**

### Attributes:

- `maxSupply`: The maximum supply of tokens that can be minted.
- `mintPrice`: The price to mint a new token.
- `mintedSupply`: The current number of tokens minted.

### Functions:

- `mintNFT(address to)`: Mints a new token and sends it to the specified address, considering the sale is open, the contract is not paused, and the sent value covers the mint price.
- `setMintPrice(uint256 newMintPrice)`: Sets a new price for minting tokens, only callable by the owner.
- `pauseSale()`: Pauses the sale of tokens, only callable by the owner.
- `unpauseSale()`: Unpauses the sale of tokens, only callable by the owner.

### Purpose:

- Manages the minting process of tokens, including mint price and supply, and provides mechanisms to pause and unpause sales.

## Interrelation

- Each contract in the series builds on the preceding one, adding additional layers of functionality and management to the NFT system.
- **WaningLightBase** provides foundational functionalities such as minting and burning.
- **WaningLightMetadata** extends functionalities to manage metadata for each token, utilizing the foundational elements from WaningLightBase.
- **MetadataLogicContract** specializes in managing the logic for URIs, defining the base URI and allowing configuration of individual token URIs.
- Finally, **WaningLightMinting** integrates and leverages all the preceding contracts to manage the overall minting process, ensuring adherence to supply limits and providing controls for sales operations.

This collective suite of contracts form a coherent, interconnected system, allowing the WaningLight NFTs to be minted, managed, and interacted with in a multifaceted and controlled manner, reflecting the intricate themes and philosophies imbued within them.
