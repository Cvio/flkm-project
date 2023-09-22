
# Knowledge Exchange Contract Overview

`KnowledgeExchangeContract` is a decentralized platform developed on the Ethereum blockchain, allowing users to upload and access knowledge-based resources. Users receive compensation in tokens, determined by user interactions and various other factors. 

## Attributes

1. **contractName** (string)
   - Represents the name of the contract.
   
2. **knowledgeToken** (IERC20)
   - The ERC20 token used for compensations within the contract.
   
3. **userReputation** (mapping: address => ReputationLevel)
   - Assigns a `ReputationLevel` to each user's address.
   
4. **reputationBonusValues** (mapping: ReputationLevel => uint256)
   - Assigns a bonus value to each `ReputationLevel`.
   
5. **userResourceCount** (mapping: address => uint256)
   - Tracks the number of resources each user has uploaded.
   
6. **userTotalDemand** (mapping: address => uint256)
   - Records the total demand for all resources uploaded by each user.
   
7. **knowledgeResources** (mapping: uint256 => KnowledgeResource)
   - Holds all the uploaded knowledge resources, indexed by a unique resource ID.
   
8. **nextResourceID** (uint256)
   - Holds the ID to be assigned to the next uploaded resource.
   
9. **MINIMUM_COMPENSATION**, **MAX_DEMAND**, **UNIQUENESS_SCALING_FACTOR**, **CONTRIBUTION_SCALING_FACTOR** (uint256 constants)
   - Constants used for calculations within the contract.
   
## Events

1. **ResourceUploaded**
   - Triggered when a new resource is uploaded. Logs the resource ID, creator, title, and description.
   
2. **ResourceAccessed**
   - Triggered when a user accesses a resource. Logs the resource ID and the user.
   
3. **FundsReceived**
   - Triggered when Ether is sent to the contract. Logs the sender and amount received.
   
## Functions

1. **constructor**
   - Initializes the contract with a name and the address of the ERC20 token used.
   
2. **uploadResource**
   - Allows users to upload resources if they have sufficient knowledge tokens.
   
3. **accessResource**
   - Enables users to access uploaded resources, increases the demand for the resource, and transfers compensation to the creator.
   
4. **calculateCompensation**
   - Calculates the compensation to be paid to the resource creator when a user accesses it.
   
5. **updateUserReputation**
   - Enables the owner to update the reputation level of a user.
   
6. **updateReputationBonusValue**
   - Allows the owner to update the bonus value assigned to a reputation level.
   
7. **updateContractName**
   - Allows the owner to update the contract name.
   
8. **receive**
   - Enables the contract to receive Ether and triggers a `FundsReceived` event.
   
## Enum and Struct

1. **ReputationLevel** (enum)
   - Represents the different levels of reputation a user can have: Mystic, Luminary, Oracle, Prophet.
   
2. **KnowledgeResource** (struct)
   - Represents a knowledge resource with various attributes.

## External Libraries

- **IERC20**
   - Interface for ERC20 tokens.
   
- **SafeMath**
   - Provides functions to perform safe mathematical operations.
   
- **Ownable**
   - Provides basic authorization control functions.
   
- **ReentrancyGuard**
   - Mitigates reentrancy attacks.

## Security Mechanisms

- The contract implements `ReentrancyGuard` to prevent reentrancy attacks on the `accessResource` function.
- It utilizes `Ownable` to restrict certain functionalities to the owner only.
- The contract employs `SafeMath` to perform secure mathematical operations.
