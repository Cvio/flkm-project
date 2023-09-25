# CowlDAO Knowledge Base

## Attributes

### `rewardToken: IERC20`

- The token used to reward users.

### `eternalLight: IERC721`

- The NFT representing membership in the DAO.

### `nextClusterID: uint256`

- The ID to be assigned to the next knowledge cluster.

### `nextKnowledgeID: uint256`

- The ID to be assigned to the next knowledge contribution.

### `nextIdeaID: uint256`

- The ID to be assigned to the next growth idea.

### `rewardAmount: uint256`

- The amount of `rewardToken` to be awarded for contributing knowledge.

### `modificationVoteRequirement: uint256`

- The number of votes required to approve a modification proposal.

### `modificationApprovalThreshold: uint256`

- The threshold for approving modification proposals.

### `authorRewardAmount: uint256`

- The amount of `rewardToken` to be awarded to the author of a knowledge piece when it receives an upvote.

### `voterRewardAmount: uint256`

- The amount of `rewardToken` to be awarded to a user for voting on knowledge pieces or proposals.

### `nextEthicalProposalID: uint256`

- The ID to be assigned to the next ethical proposal.

### `ethicalVoteRequirement: uint256`

- The number of votes required to pass an ethical proposal.

## Functions

### `initiateKnowledgeCluster()`

- **Modifiers:** `onlyOwner`, `whenNotPaused`
- **Description:** Initiates a new knowledge cluster.
- **Usage:** Only the owner can initiate a new cluster when the contract is not paused.

### `contributeKnowledge(string memory _content, uint256 _clusterID)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to contribute knowledge to a specific cluster.
- **Usage:** Only a DAO member can contribute when the contract is not paused. The contributor receives `rewardAmount` of `rewardToken`.

### `upvoteKnowledge(uint256 _knowledgeId)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to upvote a knowledge piece.
- **Usage:** Only a DAO member can upvote knowledge when the contract is not paused. The voter and the author of the knowledge piece receive `voterRewardAmount` of `rewardToken`.

### `supportGrowthIdea(uint256 _ideaID, uint256 _pledgedAmount)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to support a growth idea by pledging funds.
- **Usage:** Only a DAO member can support growth ideas when the contract is not paused. The supporter receives `rewardAmount` of `rewardToken`.

### `enactGrowthIdea(uint256 _ideaID)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to enact a growth idea if it has received enough support.
- **Usage:** Can only be executed when the contract is not paused, by a DAO member, and if the idea has enough funds pledged.

### `proposeModification(uint256 _knowledgeId, string memory _newContent)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to propose a modification to a knowledge piece.
- **Usage:** Only a DAO member can propose modifications when the contract is not paused.

### `voteOnModification(uint256 _modificationId)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to vote on a modification proposal.
- **Usage:** Only a DAO member can vote on modifications when the contract is not paused. The voter receives `voterRewardAmount` of `rewardToken`.

### `implementModification(uint256 _modificationId)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to implement a modification proposal if it has received enough votes.
- **Usage:** Can only be executed when the contract is not paused, by a DAO member, and if the modification proposal has enough votes.

### `createEthicalProposal(uint256 _knowledgeId, string memory _ethicalConsideration)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to create an ethical proposal for a knowledge piece.
- **Usage:** Only a DAO member can create ethical proposals when the contract is not paused.

### `voteOnEthicalProposal(uint256 _proposalId)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to vote on an ethical proposal.
- **Usage:** Only a DAO member can vote on ethical proposals when the contract is not paused. The voter receives `voterRewardAmount` of `rewardToken`.

### `implementEthicalProposal(uint256 _proposalId)`

- **Modifiers:** `onlyMember`, `whenNotPaused`
- **Description:** Allows a DAO member to implement an ethical proposal if it has received enough votes.
- **Usage:** Can only be executed when the contract is not paused, by a DAO member, and if the ethical proposal has enough votes.

### `claimRewards()`

- **Modifiers:** `nonReentrant`
- **Description:** Allows a user to claim their earned rewards.
- **Usage:** Can be executed by any user having rewards, and is protected by a reentrancy guard.

### `updateParameter(string memory _parameter, uint256 _value)`

- **Modifiers:** `onlyOwner`
- **Description:** Allows the owner to update the value of certain parameters of the DAO.
- **Usage:** Only the owner can update parameters.

### `pause()`

- **Modifiers:** `onlyOwner`, `whenNotPaused`
- **Description:** Allows the owner to pause the contract in case of an emergency.
- **Usage:** Only the owner can pause the contract when it is not paused.

### `unpause()`

- **Modifiers:** `onlyOwner`, `whenPaused`
- **Description:** Allows the owner to unpause the contract.
- **Usage:** Only the owner can unpause the contract when it is paused.

## Notes

- All functionalities involving token transfers should handle possible errors properly to avoid loss of funds.
- The owner should be careful when pausing and unpausing the contract, and should communicate clearly with the DAO members regarding any such changes.
