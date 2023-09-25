// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// import "@openzeppelin/contracts/security/Pausable.sol";
import "../../../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../../node_modules/@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "../../../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../../../node_modules/@openzeppelin/contracts/security/Pausable.sol";

contract CowlDaoToken is ERC20, Ownable, ReentrancyGuard, Pausable {
    using SafeMath for uint256;

    struct StakeInfo {
        uint256 amount;
        uint256 timestamp;
    }

    enum GovernanceLevel {
        Member,
        Contributor,
        Council
    }

    mapping(address => GovernanceLevel) public governanceLevels;
    mapping(address => StakeInfo) public stakers;
    mapping(address => address) public delegates; // User delegations

    // Event emissions
    event GovernanceLevelChanged(
        address indexed holder,
        GovernanceLevel newLevel
    );
    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount);
    event Voted(address indexed voter, uint256 proposalId, bool support);
    event ProposalCreated(
        uint256 indexed proposalId,
        address proposer,
        string description
    );
    event DelegateChanged(address indexed delegator, address indexed delegatee);

    struct Proposal {
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 endTime;
        bool executed;
    }

    mapping(uint256 => mapping(address => bool)) public voters;

    Proposal[] public proposals;
    uint256 public proposalVotingDuration = 1 days;
    uint256 public minStakeToPropose = 100 * (10 ** decimals()); // Minimum tokens to stake to be able to propose

    constructor() ERC20("CowlDAO", "CDAO") {
        _mint(msg.sender, 1000000 * (10 ** decimals()));
    }

    function setGovernanceLevel(
        address holder,
        GovernanceLevel newLevel
    ) external onlyOwner {
        governanceLevels[holder] = newLevel;
        emit GovernanceLevelChanged(holder, newLevel);
    }

    function propose(string memory description) external {
        require(
            stakers[msg.sender].amount >= minStakeToPropose,
            "Insufficient staked amount to propose"
        );

        Proposal memory newProposal = Proposal({
            description: description,
            forVotes: 0,
            againstVotes: 0,
            endTime: block.timestamp + proposalVotingDuration,
            executed: false
        });

        proposals.push(newProposal);
        emit ProposalCreated(proposals.length - 1, msg.sender, description);
    }

    function vote(uint256 proposalId, bool support) external nonReentrant {
        require(proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp < proposal.endTime, "Voting period has ended");
        require(!voters[proposalId][msg.sender], "Already voted");

        uint256 weight = stakers[msg.sender].amount;
        voters[proposalId][msg.sender] = true;

        if (support) proposal.forVotes += weight;
        else proposal.againstVotes += weight;

        emit Voted(msg.sender, proposalId, support);
    }

    function executeProposal(
        uint256 proposalId
    ) external onlyOwner nonReentrant {
        require(proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[proposalId];
        require(
            block.timestamp >= proposal.endTime,
            "Voting period is not over"
        );
        require(!proposal.executed, "Proposal already executed");
        require(proposal.forVotes > proposal.againstVotes, "Proposal rejected");

        // Implement logic here for executing proposal. This might involve
        // interacting with other contracts or calling specific functions
        // based on the proposal description.

        proposal.executed = true;
    }

    function stake(uint256 amount) external nonReentrant {
        _burn(msg.sender, amount);
        stakers[msg.sender].amount += amount;
        stakers[msg.sender].timestamp = block.timestamp;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external nonReentrant {
        require(
            stakers[msg.sender].amount >= amount,
            "Not enough tokens staked"
        );

        // Calculate rewards earned by staker and distribute them
        // before reducing staked amount and minting unstaked tokens.

        _mint(msg.sender, amount); // + rewards
        stakers[msg.sender].amount -= amount;
        emit Unstaked(msg.sender, amount);
    }

    function delegate(address delegatee) external {
        require(msg.sender != delegatee, "Cannot delegate to self");
        delegates[msg.sender] = delegatee;
        emit DelegateChanged(msg.sender, delegatee);
    }

    // TODO: Implement additional advanced functionalities like
    // - Dynamic Token Supply Adjustment
    // - Multi-tier Governance
    // - Voting Power Boosting
    // - Participatory Budgeting
    // - Conditional Token Vesting
    // - Advanced Utility, etc.

    // Function to pause contract functionalities.
    // This function can only be called by the owner of the contract (onlyOwner modifier),
    // and can only be executed if the contract is not already paused (whenNotPaused modifier).
    // When executed, it will set the _paused variable to true, effectively pausing all functions
    // in the contract that have the whenNotPaused modifier.
    function pause() external onlyOwner whenNotPaused {
        _pause(); // This function from the Pausable contract sets _paused to true and emits the Paused event.
    }

    // Function to unpause contract functionalities.
    // This function can only be called by the owner of the contract (onlyOwner modifier),
    // and can only be executed if the contract is currently paused (whenPaused modifier).
    // When executed, it will set the _paused variable to false, effectively unpausing all
    // functions in the contract that have the whenNotPaused modifier.
    function unpause() external onlyOwner whenPaused {
        _unpause(); // This function from the Pausable contract sets _paused to false and emits the Unpaused event.
    }
}
