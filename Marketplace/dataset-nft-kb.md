# Knowledge Base (KB) for `DatasetNFTContract`

## Contract Overview

`DatasetNFTContract` is a smart contract developed on the Ethereum blockchain using Solidity. It's designed to manage Non-Fungible Tokens (NFTs) related to datasets. Each NFT represents ownership or usage rights of a particular dataset and contains metadata like description, data type, source, and royalty percentage.

## Inherited Contracts

### 1. `ERC721`
   - **Purpose**: Manages the basic functionality of NFTs following the ERC721 standard.
   - **Source**: OpenZeppelin library.
   - **Key Methods**:
        - `_mint(address to, uint256 tokenId)`: Internal function to mint a new NFT.
        - `_exists(uint256 tokenId)`: Internal function to check the existence of an NFT.

### 2. `AccessControl`
   - **Purpose**: Manages role-based access control, allowing different permissions for different roles.
   - **Source**: OpenZeppelin library.
   - **Key Roles**:
        - `DEFAULT_ADMIN_ROLE`: A role that allows changing URI and modifying metadata.
        - `MINTER_ROLE`: A role that allows minting new NFTs.

## Attributes

### 1. `totalMinted`
   - **Type**: `uint256`
   - **Description**: Counter of the total NFTs minted by the contract.

### 2. `baseTokenURI`
   - **Type**: `string`
   - **Description**: The base URI used for resolving metadata URIs per the ERC721 standard.

### 3. `DatasetMetadata`
   - **Type**: `struct`
   - **Description**: Holds metadata for each dataset NFT.
   - **Attributes**:
        - `description`: Textual information about the dataset.
        - `dataType`: Type or format of the dataset.
        - `source`: Source or origin of the dataset.
        - `royaltyPercentage`: Percentage of royalties to be applied on secondary sales.

### 4. `datasetMetadata`
   - **Type**: `mapping(uint256 => DatasetMetadata)`
   - **Description**: Mapping from token ID to its associated metadata.

## Events

### 1. `MintedDatasetNFT`
   - **Arguments**: `tokenId` (uint256), `to` (address).
   - **Usage**: Emitted when a new NFT is minted.

### 2. `MetadataUpdated`
   - **Arguments**: `tokenId` (uint256).
   - **Usage**: Emitted when the metadata of a token ID is updated.

### 3. `BaseUriUpdated`
   - **Arguments**: `newUri` (string).
   - **Usage**: Emitted when the base token URI is updated.

## Functions

### 1. `constructor(string, string, string)`
   - **Usage**: Initializes the contract, setting the name, symbol, and base token URI of the NFT, and sets up roles.
   - **Accessibility**: Public.
   
### 2. `setBaseTokenURI(string)`
   - **Usage**: Allows the admin to update the base token URI.
   - **Accessibility**: External, restricted to `DEFAULT_ADMIN_ROLE`.

### 3. `mintDatasetNFT(address, string, string, string, uint256)`
   - **Usage**: Allows minting new NFTs and associating metadata.
   - **Returns**: The token ID of the newly minted NFT.
   - **Accessibility**: External, restricted to `MINTER_ROLE`.

### 4. `setMetadata(uint256, string, string, string, uint256)`
   - **Usage**: Allows the admin to modify the metadata of an existing NFT.
   - **Accessibility**: External, restricted to `DEFAULT_ADMIN_ROLE`.

### 5. `transferDatasetOwnership(uint256, address)`
   - **Usage**: Enables an NFT owner to transfer ownership to a new address.
   - **Accessibility**: External, restricted to the current owner of the NFT.

### 6. `_baseURI()`
   - **Usage**: Returns the base URI set for the token. This is an internal function.
   - **Returns**: The base token URI.
   - **Accessibility**: Internal.

## Key Considerations

- **Security**: Always adhere to best practices and conduct thorough testing and auditing before deployment.
- **Royalty Handling**: Implementations for handling and distributing royalties during secondary sales are not included in this contract. Integrations might need additional development based on used marketplaces or platforms.
- **Upgradeability**: Consider implementing a proxy pattern for contract upgradeability in production environments.
