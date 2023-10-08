# Knowledge Base: WaningLight Contracts

## WaningLightBase Contract

### Overview:

The `WaningLightBase` contract serves as the foundation for the WaningLight NFT, encompassing fundamental attributes and behaviors. The contract inherits from `ERC721URIStorageUpgradeable` and `AccessControlUpgradeable`.

### Imports:

- **Initializable**: This allows for contract initialization, a crucial component for upgradeable contracts.
- **ERC721URIStorageUpgradeable**: An ERC721 implementation designed for the storage and retrieval of token URIs.
- **AccessControlUpgradeable**: Manages access control lists ensuring appropriate permissions.
- **Strings**: Provides utility functions for converting data types into strings.

### Attributes:

- **\_tokenIdCounter**: A counter ensuring that each token has a unique ID.
- **ADMIN_ROLE & MINTER_ROLE**: These constants define roles for administration and minting capabilities.
- **\_tokenURIs**: A mapping that associates each token ID to its respective URI.
- **\_baseURIExtended**: Stores the extended base URI for tokens.

### Events:

- **MetadataChanged**: Triggered when a token's metadata undergoes a change.

### Functions & Modifiers:

- **initialize()**: Sets up the contract, naming conventions, and assigns initial roles.
- **mint(address to)**: Creates a new token.
- **burn(uint256 tokenId)**: Removes a token.
- **mintWithTokenURI(address to, string memory \_tokenURI)**: Creates a token with a specific URI.
- **setRole(address member, string memory role)**: Designates a role to a member.
- **setContribution(address member, string memory contribution)**: Specifies a contribution for a member.
- **supportsInterface(bytes4 interfaceId)**: Guarantees ERC-165 compatibility.
- **\_baseURI()**: Retrieves the tokens' base URI.
- **setBaseURI(string memory baseURI\_)**: Specifies the base URI.

## WaningLightMetadata Contract

### Overview:

The `WaningLightMetadata` contract manages the metadata for each NFT. This contract inherits from `ERC721EnumerableUpgradeable` and `AccessControlUpgradeable`.

### Imports:

- **ERC721EnumerableUpgradeable**: An ERC721 implementation that allows token enumerability.
- **AccessControlUpgradeable**: Provides a system to manage access control lists.

### Attributes:

- **ADMIN_ROLE**: Defines the role for administration capabilities.
- **waningLightBase**: A reference to the `WaningLightBase` contract.
- **\_tokenDetails**: A mapping that links each token ID to its details.

### Functions:

- **initialize(address waningLightBaseAddress)**: Initializes the contract with a reference to the `WaningLightBase` contract.
- **setTokenDetails(uint256 tokenId, string memory details)**: Sets the details of a specific token.
- **tokenDetails(uint256 tokenId)**: Retrieves the details of a specific token.
- **supportsInterface(bytes4 interfaceId)**: Guarantees ERC-165 compatibility.

## WaningLightMinting Contract

### Overview:

The `WaningLightMinting` contract facilitates the minting of NFTs, including the definition of mint price and tracking of the current supply. The contract inherits from `Initializable`, `ERC721EnumerableUpgradeable`, `AccessControlUpgradeable`, and `PausableUpgradeable`.

### Imports:

- **Initializable**: This allows for contract initialization.
- **ERC721EnumerableUpgradeable**: An ERC721 implementation that allows token enumerability.
- **AccessControlUpgradeable**: Manages access control lists ensuring appropriate permissions.
- **PausableUpgradeable**: Provides functionality to pause and unpause contract operations.

### Attributes:

- **ADMIN_ROLE & MINTER_ROLE**: These constants define roles for administration and minting capabilities.
- **waningLightBase & waningLightMetadata**: References to the `WaningLightBase` and `WaningLightMetadata` contracts respectively.
- **maxSupply**: The maximum number of tokens that can be minted.
- **mintPrice**: The cost to mint a token.
- **mintedSupply**: The current number of tokens that have been minted.

### Events:

- **Minted**: Triggered when a new token is minted.

### Functions & Modifiers:

- **initialize(address waningLightBaseAddress, address waningLightMetadataAddress, uint256 \_maxSupply, uint256 \_mintPrice)**: Sets up the contract and initializes references.
- **mintNFT(address to)**: Creates a new token and ensures the correct ether amount has been sent.
- **setMintPrice(uint256 newMintPrice)**: Updates the minting price.
- **pauseSale() & unpauseSale()**: Allows for pausing and resuming of the minting process.
- **\_baseURI()**: Retrieves the base URI for tokens.
- **supportsInterface(bytes4 interfaceId)**: Guarantees ERC-165 compatibility.
