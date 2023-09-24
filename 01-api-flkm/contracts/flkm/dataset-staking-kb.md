# DatasetStaking Contract Knowledge Base

## Attributes

### 1. `cowlToken: IERC20 public`

- **Purpose**: Represents the token used for staking within this contract.
- **Type**: ERC20 Token Interface.
- **Need**: To interact with the Cowl token for staking, transferring, and balance checks.

### 2. `requiredStakeAmount: uint256 public constant`

- **Purpose**: Signifies the required amount of cowlTokens one needs to stake to register a dataset.
- **Value**: 100 cowlTokens.

### 3. `initialReputation: uint256 public constant`

- **Purpose**: Represents the initial reputation given to a dataset once it is staked.
- **Value**: 50.

### 4. `struct Dataset`

- **Purpose**: Represents a dataset and its properties.
- **Properties**:
  - `owner`: Address of the owner of the dataset.
  - `stakedAmount`: Amount of cowlTokens staked for this dataset.
  - `reputation`: Reputation score of the dataset.
  - `isActive`: Boolean representing whether the dataset is active or not.
  - `ipfsHash`: String containing the IPFS hash to locate the dataset.
  - `filecoinDealId`: String containing the Filecoin deal ID for long-term storage.

### 5. `mapping(address => Dataset) public datasets`

- **Purpose**: Stores Dataset structures, mapped by their owner's address.
- **Need**: Allows for quick lookup and interaction with datasets owned by a particular address.

### 6. `mapping(address => uint256) public rewards`

- **Purpose**: Represents the rewards that are mapped to each user’s address.
- **Need**: To manage and distribute rewards to users.

## Events

### 1. `event DatasetStaked(address indexed user, uint256 amount, string ipfsHash)`

- **Purpose**: Emitted when a user stakes tokens and registers a dataset.
- **Parameters**:
  - `user`: Address of the user who staked.
  - `amount`: Amount staked by the user.
  - `ipfsHash`: IPFS hash of the staked dataset.

### 2. `event DatasetUpdated(address indexed dataset, uint256 reputation, bool isActive)`

- **Purpose**: Emitted when a dataset’s properties are updated.
- **Parameters**:
  - `dataset`: Address associated with the dataset.
  - `reputation`: Updated reputation of the dataset.
  - `isActive`: Updated status of the dataset.

### 3. `event RewardClaimed(address indexed user, uint256 amount)`

- **Purpose**: Emitted when a user claims their rewards.
- **Parameters**:
  - `user`: Address of the user claiming the rewards.
  - `amount`: Amount of rewards claimed.

### 4. `event DatasetTransitionedToFilecoin(address indexed dataset, string filecoinDealId)`

- **Purpose**: Emitted when a dataset is transitioned to Filecoin.
- **Parameters**:
  - `dataset`: Address associated with the dataset.
  - `filecoinDealId`: The Filecoin deal ID.

## Functions

### 1. `constructor(address _cowlToken)`

- **Purpose**: Initializes the cowlToken attribute with the provided address.

### 2. `stakeDataset(string memory _ipfsHash) external nonReentrant`

- **Purpose**: Allows users to stake tokens and register a dataset with the associated IPFS hash.
- **Parameters**:
  - `_ipfsHash`: IPFS hash of the dataset.

### 3. `updateDataset(address _dataset, uint256 _newReputation, bool _newStatus) external onlyOwnerOf(_dataset)`

- **Purpose**: Allows the owner of a dataset to update its properties.
- **Parameters**:
  - `_dataset`: Address associated with the dataset.
  - `_newReputation`: New reputation score for the dataset.
  - `_newStatus`: New activity status for the dataset.

### 4. `transitionToFilecoin(address _dataset, string memory _filecoinDealId) external onlyOwnerOf(_dataset)`

- **Purpose**: Allows the owner of a dataset to transition it to Filecoin.
- **Parameters**:
  - `_dataset`: Address associated with the dataset.
  - `_filecoinDealId`: The Filecoin deal ID.

### 5. `claimRewards() external nonReentrant`

- **Purpose**: Allows users to claim their rewards.

### 6. `withdrawStake() external nonReentrant`

- **Purpose**: Allows users to withdraw their staked tokens.

## Modifier

### 1. `onlyOwnerOf(address _dataset)`

- **Purpose**: Ensures that the caller is the owner of the specified dataset.

## Purpose & Workflow

### Purpose

- This contract is designed to allow users to stake tokens and register datasets. It manages the properties of datasets like reputation and activity status and handles the transition of datasets to Filecoin. It also enables the claiming of rewards
