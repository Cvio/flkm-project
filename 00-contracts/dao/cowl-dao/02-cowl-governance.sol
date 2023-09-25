// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Importing the required interfaces and contracts from the OpenZeppelin library
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Main contract for the DAO Governance
contract CowlDaoGovernance is ReentrancyGuard, Ownable {
    // Reference to the ERC20 token used for voting.
    // It is public so anyone can see which token is used for governance.
    IERC20 public governanceToken;

    // Struct for representing a proposal
    struct Proposal {
        string description; // Description or title of the proposal
        address proposer; // Address of the proposer who created the proposal
        uint256 forVotes; // Total count of votes in favor of the proposal
        uint256 againstVotes; // Total count of votes against the proposal
        uint256 endTime; // Time when the voting period ends for this proposal
        bool executed; // Indicates if the proposal has been executed or not
    }

    // Array to store all proposals. This enables iteration over all proposals and direct access using an ID.
    Proposal[] public proposals;

    // Nested mapping to track who has voted on which proposal.
    // The outer key is the proposal ID and the inner key is the voter's address.
    mapping(uint256 => mapping(address => bool)) public votes;

    // Events to log significant actions for external listeners like frontend interfaces or dApps.
    event ProposalCreated(
        uint256 indexed proposalId,
        string description,
        address indexed proposer,
        uint256 endTime
    );
    event Voted(
        uint256 indexed proposalId,
        address indexed voter,
        bool vote,
        uint256 weight
    );
    event ProposalExecuted(uint256 indexed proposalId);

    // Constant for the voting duration, set to 1 day for now. This can be changed based on requirements.
    uint256 public constant VOTING_DURATION = 1 days;

    // Constructor for initializing the contract with the governance token's address
    constructor(address _governanceToken) {
        governanceToken = IERC20(_governanceToken);
    }

    // External function to allow users to propose a new governance proposal
    function propose(string memory _description) external {
        // Constructing a new proposal object
        Proposal memory newProposal = Proposal({
            description: _description,
            proposer: msg.sender, // msg.sender is the address of the user interacting with the contract
            forVotes: 0,
            againstVotes: 0,
            endTime: block.timestamp + VOTING_DURATION, // Setting end time based on current time + defined voting duration
            executed: false
        });

        // Adding the new proposal to the proposals array
        proposals.push(newProposal);

        // Emitting an event to indicate a new proposal has been created
        emit ProposalCreated(
            proposals.length - 1,
            _description,
            msg.sender,
            newProposal.endTime
        );
    }

    // External function to allow users to vote on a given proposal
    function vote(uint256 _proposalId, bool _vote) external nonReentrant {
        // nonReentrant ensures no recursive calls
        require(_proposalId < proposals.length, "Proposal does not exist"); // Check if proposal exists
        Proposal storage proposal = proposals[_proposalId]; // Retrieving the proposal from storage
        require(block.timestamp < proposal.endTime, "Voting period has ended"); // Ensuring voting period is still active

        uint256 weight = governanceToken.balanceOf(msg.sender); // Retrieving the voter's token balance, which represents their voting power
        require(weight > 0, "Insufficient balance to vote"); // Voter must have a positive balance to vote

        require(!votes[_proposalId][msg.sender], "Already voted"); // Ensuring the user hasn't voted on this proposal before
        votes[_proposalId][msg.sender] = true; // Marking this user as having voted for this proposal

        // Updating the vote count based on user's choice
        if (_vote) {
            proposal.forVotes += weight; // Incrementing 'for' votes
        } else {
            proposal.againstVotes += weight; // Incrementing 'against' votes
        }

        // Emitting an event to indicate a vote has been cast
        emit Voted(_proposalId, msg.sender, _vote, weight);
    }

    // Function for the owner to execute a proposal. For simplicity, only the owner can execute.
    // In a more decentralized scenario, this might be changed to a more complex mechanism.
    function execute(uint256 _proposalId) external nonReentrant onlyOwner {
        // onlyOwner ensures only the contract's owner can call
        require(_proposalId < proposals.length, "Proposal does not exist"); // Check if proposal exists
        Proposal storage proposal = proposals[_proposalId]; // Retrieving the proposal from storage
        require(
            block.timestamp >= proposal.endTime,
            "Voting period is not over"
        ); // Ensuring voting period is over
        require(!proposal.executed, "Proposal already executed"); // Ensuring the proposal hasn't been executed already

        require(proposal.forVotes > proposal.againstVotes, "Proposal rejected"); // For a proposal to be executed, it must have more 'for' votes than 'against' votes

        // Marking the proposal as executed
        proposal.executed = true;

        // Emitting an event to indicate the proposal has been executed
        emit ProposalExecuted(_proposalId);
    }
}
