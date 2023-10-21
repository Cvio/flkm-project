// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title CowlDaoToken
 * @dev This contract manages the staking, proposals, delegations, and governance levels of the token holders.
 */
contract CowlDaoToken is
    Initializable,
    ERC20Upgradeable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable
{
    using SafeMathUpgradeable for uint256;

    // --------------------- Initializer ---------------------
    // Making contract upgradeable - removing constructor and using initializer
    function initialize(
        string memory name,
        string memory symbol
    ) public initializer {
        __ERC20_init(name, symbol);
        __AccessControl_init();
        __ReentrancyGuard_init();
        __Pausable_init();

        daoName = name; // DAO name
        daoSymbol = symbol; // DAO symbol

        _mint(_msgSender(), INITIAL_SUPPLY * (10 ** decimals()));

        _grantRole(ADMIN_ROLE, _msgSender());

        minStakeToPropose = 100 * (10 ** decimals()); // Initial minimum stake to propose
        rewardPool = 0; // Initial value for the reward pool
        _stopped = false; // Initial circuit breaker state
    }

    // --------------------- Variables Section ---------------------
    // The below section organizes and groups related variables together for clarity and readability

    // ** Basic Token and DAO Information **
    string private daoName;
    string private daoSymbol;
    uint256 private INITIAL_SUPPLY = 1000000000;
    uint256 public rewardPool; // Rewards available for stakers

    // ** Security and Emergency Handling **
    bool private _stopped = false; // Circuit breaker variable to stop contract in emergencies

    // ** Roles and Governance Levels **
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    enum GovernanceLevel {
        Member,
        Contributor,
        Council
    }

    mapping(address => GovernanceLevel) public governanceLevels;

    // ** Staking and Proposals **
    uint256 public lockPeriod = 30 days;
    Proposal[] public proposals;
    uint256 public proposalVotingDuration = 1 days;
    uint256 public minStakeToPropose = 100 * (10 ** decimals()); // Minimum tokens to stake to be able to propose

    struct StakeInfo {
        uint256 amount;
        uint256 timestamp;
    }
    mapping(address => StakeInfo) public stakers;

    struct Proposal {
        address contractAddress;
        bytes callData;
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 endTime;
        bool executed;
    }

    // ** Delegation and Voting **
    mapping(address => address) public delegates;
    mapping(uint256 => mapping(address => bool)) public voters;
    mapping(address => address) public delegateRequests;

    // ** Advanced Utility and Functions **
    mapping(address => uint256) public votingPower; // Multi-tier governance voting power

    event GovernanceLevelChanged(
        address indexed holder,
        GovernanceLevel newLevel
    );
    event MinStakeToProposeChanged(uint256 newMinStake);
    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount);
    event ProposalCreated(
        uint256 indexed proposalId,
        address proposer,
        string description
    );
    event Voted(address indexed voter, uint256 proposalId, bool support);
    event DelegateChanged(
        address indexed delegator,
        address indexed delegatee,
        uint256 balance
    );
    event StateChanged(address indexed by, string change);
    event ProposalFailed(uint256 indexed proposalId);
    event ProposalExecuted(uint256 indexed proposalId);
    event DelegateRequest(address indexed delegator, address indexed delegatee);

    modifier stopInEmergency() {
        require(!_stopped, "Contract is stopped due to an emergency");
        _;
    }

    modifier onlyInEmergency() {
        require(_stopped, "Can only be accessed during an emergency");
        _;
    }

    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");
        _;
    }

    // ** Administrative Functions **

    function setMinStakeToPropose(
        uint256 _minStakeToPropose
    ) external onlyAdmin {
        minStakeToPropose = _minStakeToPropose;
        emit MinStakeToProposeChanged(_minStakeToPropose);
    }

    function setGovernanceLevel(
        address holder,
        GovernanceLevel newLevel
    ) external onlyAdmin {
        governanceLevels[holder] = newLevel;
        emit GovernanceLevelChanged(holder, newLevel);
    }

    function toggleCircuitBreaker() external onlyAdmin {
        _stopped = !_stopped;
        emit StateChanged(msg.sender, _stopped ? "stopped" : "started");
    }

    // ** Staking and Reward Distribution Functions **

    function stake(uint256 amount) external nonReentrant stopInEmergency {
        _burn(msg.sender, amount); // Remove the staked tokens from circulation
        stakers[msg.sender].amount += amount;
        stakers[msg.sender].timestamp = block.timestamp;

        // Reward users based on stake amount and duration
        uint256 reward = calculateReward(msg.sender);
        _mint(msg.sender, reward); // Mint new tokens as rewards
        rewardPool -= reward; // Reduce the rewardPool balance

        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external nonReentrant stopInEmergency {
        require(
            stakers[msg.sender].amount >= amount,
            "Not enough tokens staked"
        );

        uint256 penalty = 0;
        if (block.timestamp < stakers[msg.sender].timestamp + lockPeriod) {
            penalty = amount / 10; // 10% penalty if within lock period
        }

        uint256 amountAfterPenalty = amount - penalty;
        _mint(msg.sender, amountAfterPenalty); // Return the unstaked tokens to circulation
        stakers[msg.sender].amount -= amount;

        emit Unstaked(msg.sender, amountAfterPenalty);
    }

    function calculateReward(address staker) internal view returns (uint256) {
        StakeInfo memory info = stakers[staker];
        uint256 reward = (info.amount * (block.timestamp - info.timestamp)) /
            (365 days); // Placeholder example logic
        return reward;
    }

    // ** Proposal Creation and Execution Functions **

    function propose(
        address _contractAddress,
        bytes memory _callData,
        string memory description
    ) external {
        require(
            stakers[msg.sender].amount >= minStakeToPropose,
            "Insufficient staked amount to propose"
        );

        Proposal memory newProposal = Proposal({
            contractAddress: _contractAddress,
            callData: _callData,
            description: description,
            forVotes: 0,
            againstVotes: 0,
            endTime: block.timestamp + proposalVotingDuration,
            executed: false
        });

        proposals.push(newProposal);
        emit ProposalCreated(proposals.length - 1, msg.sender, description);
    }

    function vote(uint256 proposalId, bool support) external stopInEmergency {
        require(!voters[proposalId][msg.sender], "Already voted");
        voters[proposalId][msg.sender] = true;

        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp < proposal.endTime, "Voting period has ended");

        uint256 weight = votingPower[msg.sender];
        if (support) proposal.forVotes += weight;
        else proposal.againstVotes += weight;

        emit Voted(msg.sender, proposalId, support);
    }

    function executeProposal(uint256 proposalId) external stopInEmergency {
        Proposal storage proposal = proposals[proposalId];
        require(
            block.timestamp >= proposal.endTime,
            "Voting period is not over yet"
        );
        require(!proposal.executed, "Proposal has already been executed");
        require(
            proposal.forVotes > proposal.againstVotes,
            "Proposal did not pass"
        );

        (bool success, ) = proposal.contractAddress.call(proposal.callData);
        require(success, "Execution failed");

        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }

    // ** Delegation and Governance Level Functions **

    function delegate(address delegatee) external stopInEmergency {
        require(msg.sender != delegatee, "Cannot delegate to self");
        require(
            delegates[msg.sender] != delegatee,
            "Already delegated to this address"
        );

        // Delegation logic here (updating delegatee's voting power etc.)

        emit DelegateChanged(msg.sender, delegatee, balanceOf(msg.sender));
    }

    function delegateRequest(address delegatee) external stopInEmergency {
        require(msg.sender != delegatee, "Cannot delegate to self");
        delegateRequests[msg.sender] = delegatee;
        emit DelegateRequest(msg.sender, delegatee);
    }

    function acceptDelegateRequest(address delegator) external stopInEmergency {
        require(
            delegateRequests[delegator] == msg.sender,
            "No delegation request from this address"
        );

        delegates[delegator] = msg.sender;
        delete delegateRequests[delegator];

        emit DelegateChanged(delegator, msg.sender, balanceOf(delegator));
    }

    // ** View Functions for Reading State **

    function getProposal(
        uint256 proposalId
    ) external view returns (Proposal memory) {
        return proposals[proposalId];
    }

    function totalProposals() external view returns (uint256) {
        return proposals.length;
    }

    function isDelegatee(
        address delegator,
        address delegatee
    ) external view returns (bool) {
        return delegates[delegator] == delegatee;
    }

    receive() external payable {}
}
