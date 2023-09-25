### Knowledge Base for DAOGovernance Contract

#### **Attributes:**

1. **`governanceToken`**:

   - **Type**: IERC20
   - **Purpose**: Holds the token used for voting within the DAO.
   - **Importance**: Vital for enabling voting functionality, representing users' voting power.

2. **`proposals`**:

   - **Type**: Array of `Proposal` Structs
   - **Purpose**: Stores all the proposals created in the DAO.
   - **Importance**: Maintains a record of all proposals, enabling user review and voting.

3. **`votes`**:

   - **Type**: Nested Mapping (ProposalId to (VoterAddress to Boolean))
   - **Purpose**: Records whether a particular address has voted on a specific proposal.
   - **Importance**: Prevents double-voting, ensuring each address can only vote once per proposal.

4. **`VOTING_DURATION`**:
   - **Type**: Constant Unsigned Integer
   - **Purpose**: Specifies the duration for which voting on a proposal is open.
   - **Importance**: Defines the voting period, ensuring transparency and predictability.

#### **Events:**

1. **`ProposalCreated`**:

   - **Emitted When**: A new proposal is created.
   - **Parameters**:
     - `proposalId` (uint256): ID of the new proposal.
     - `description` (string): Description of the proposal.
     - `proposer` (address): Address of the proposer.
     - `endTime` (uint256): Timestamp when voting ends.
   - **Purpose**: Notifies about newly created proposals.

2. **`Voted`**:

   - **Emitted When**: A vote on a proposal is cast.
   - **Parameters**:
     - `proposalId` (uint256): ID of the proposal.
     - `voter` (address): Address of the voter.
     - `vote` (bool): True for “for”, false for “against”.
     - `weight` (uint256): Weight of the vote, based on token balance.
   - **Purpose**: Informs about individual voting actions, allowing for transparency and verification.

3. **`ProposalExecuted`**:
   - **Emitted When**: A proposal is executed.
   - **Parameters**:
     - `proposalId` (uint256): ID of the executed proposal.
   - **Purpose**: Informs that a proposal has been executed, indicating its acceptance and enactment.

#### **Functions:**

1. **`constructor`**:

   - **Parameters**: `_governanceToken` (address): Address of the ERC20 governance token.
   - **Purpose**: Initializes the governanceToken attribute with the provided address.

2. **`propose`**:

   - **Parameters**: `_description` (string): Description of the new proposal.
   - **Purpose**: Allows users to create a new proposal with a specified description.
   - **Importance**: Enables community-driven development by allowing users to propose changes or features.

3. **`vote`**:

   - **Parameters**:
     - `_proposalId` (uint256): ID of the proposal to vote on.
     - `_vote` (bool): The vote; true for “for”, false for “against”.
   - **Purpose**: Allows token holders to cast a vote on a proposal.
   - **Importance**: Core for allowing DAO members to express their preference, crucial for decentralized decision-making.

4. **`execute`**:
   - **Parameters**: `_proposalId` (uint256): ID of the proposal to execute.
   - **Purpose**: Allows the owner to execute a proposal with more “for” votes post the voting period.
   - **Importance**: Ensures only proposals with majority support are enacted, maintaining DAO integrity.

### Why are they needed in this project?

- **Governance Token**: Represents voting power and vested interest in the DAO’s decisions.
- **Proposals**: Allow users to propose changes or features, fostering community-driven innovations.
- **Votes Mapping**: Ensures the integrity of the voting process by preventing double-voting.
- **Voting Duration**: Establishes a clear timeframe for each voting cycle, ensuring fairness and transparency.
- **Events**: Inform the network and external entities, allowing for reactions to on-chain activities.
- **Functions**: Facilitate the creation, voting, and execution of proposals, allowing the community to influence the project’s direction.

This project utilizes these elements to create a robust and transparent governance mechanism, fostering decentralized decision-making and community engagement.
