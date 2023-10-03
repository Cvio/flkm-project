# Knowledge Base: Interacting Smart Contracts Overview

This Knowledge Base (KB) discusses the interactions and functionalities of two Ethereum smart contracts: `DataStakingContract` and `DatasetNFTContract`.

## 1. `DatasetNFTContract`
This contract manages the minting and management of Non-Fungible Tokens (NFTs) related to datasets. 

### Key Attributes:
- **totalMinted**: Counter for the total NFTs minted.
- **baseTokenURI**: Base URI for resolving metadata URIs for each token.
- **DatasetMetadata Struct**: Holds metadata (description, dataType, source, and royaltyPercentage) for each dataset NFT.
- **datasetMetadata**: Mapping from token ID to its associated metadata.

### Key Functions:
- **mintDatasetNFT**: Allows minting of new NFTs and associating metadata.
- **setMetadata**: Allows modification of metadata of an existing NFT.
- **transferDatasetOwnership**: Allows an NFT owner to transfer ownership.
- **_baseURI**: Internal function that returns the base token URI.

### Events:
- **MintedDatasetNFT**: Emitted when a new NFT is minted.
- **MetadataUpdated**: Emitted when the metadata of a token is updated.
- **BaseUriUpdated**: Emitted when the base token URI is updated.

## 2. `DataStakingContract`
This contract enables users to stake their dataset NFTs in return for rewards in the form of a specific ERC20 token.

### Key Attributes:
- **rewardToken**: The ERC20 token used for staking rewards.
- **datasetNFTContract**: The instance of the `DatasetNFTContract`.
- **rewardRate**: Reward rate in the reward token per second per NFT staked.
- **bonusRate**: An additional parameter that could be utilized to adjust rewards.
- **stakes**: Mapping from staker's address to their staked tokens and their staking time.

### Key Functions:
- **stake**: Allows users to stake a specified token ID and emits the `Staked` event.
- **unstake**: Allows users to unstake a specified token ID, emits the `Unstaked` event, and transfers the reward.
- **setRewardRate**: Allows the admin to set the reward rate and emits the `RewardRateChanged` event.
- **setBonusRate**: Allows the admin to set the bonus rate and emits the `BonusRateChanged` event.
- **_calculateReward**: Internal function that calculates the reward for a staked NFT.

### Events:
- **Staked**: Emitted when a user stakes a token.
- **Unstaked**: Emitted when a user unstakes a token and receives a reward.
- **RewardRateChanged**: Emitted when the reward rate is changed.
- **BonusRateChanged**: Emitted when the bonus rate is changed.

## Interaction Between the Contracts:

### Stake and Unstake Flow:
1. **Ownership Check**: `DataStakingContract` calls `DatasetNFTContract` via `ownerOf(uint256 tokenId)` to verify the ownership of a token before allowing staking or unstaking.
2. **Staking**: Users stake their dataset NFTs using the `stake(uint256 tokenId)` function. This function checks if the caller is the owner of the NFT and registers the stake.
3. **Unstaking**: Users unstake their NFTs using `unstake(uint256 tokenId)`. Rewards are calculated based on the staking duration and `rewardRate`, then transferred to the user. 

### Potential Improvements and Notes:
- **Safe Transfers**: Ensure that safe transfer mechanisms (`safeTransferFrom` and `safeTransfer`) are used to avoid issues related to transferring tokens.
- **Royalties**: `DatasetNFTContract` has a function `royaltyInfo` potentially intended to be compliant with EIP-2981. Ensure marketplace/platforms used support this standard for automated royalty distribution.
- **Security**: Include thorough testing for both contracts to avoid potential pitfalls related to staking, unstaking, and reward distribution. 
- **Upgradeability**: Consider utilizing proxy patterns for both contracts to enable future upgrades without data loss.
