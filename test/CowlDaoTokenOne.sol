// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

/**
 * @title CowlDaoToken
 * @dev This contract manages the staking, proposals, delegations, and governance levels of the token holders.
 */
contract CowlDaoTokenOne is
    Initializable,
    ERC20Upgradeable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable
{
    function initialize(
        string memory name,
        string memory symbol
    ) public initializer {
        __ERC20_init(name, symbol);
        __AccessControl_init();
        __ReentrancyGuard_init();
        __Pausable_init();

        daoName = name;
        daoSymbol = symbol;

        _mint(_msgSender(), INITIAL_SUPPLY * (10 ** decimals()));

        _grantRole(ADMIN_ROLE, _msgSender());

        minStakeToPropose = 100 * (10 ** decimals()); // Initial minimum stake to propose
        rewardPool = 0;
        _stopped = false;
    }

    string private daoName;
    string private daoSymbol;
    uint256 private INITIAL_SUPPLY = 1000000000;
    uint256 public rewardPool;

    bool private _stopped = false;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    enum GovernanceLevel {
        Member,
        Contributor,
        Council
    }

    mapping(address => GovernanceLevel) public governanceLevels;

    uint256 public lockPeriod = 30 days;
    Proposal[] public proposals;
    uint64 public proposalVotingDuration = 1 days;
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

    mapping(address => address) public delegates;
    mapping(uint256 => mapping(address => bool)) public voters;
    mapping(address => address) public delegateRequests;

    mapping(address => uint256) public votingPower;

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

    function toggleCircuitBreaker() external onlyAdmin {
        _stopped = !_stopped;
        emit StateChanged(msg.sender, _stopped ? "stopped" : "started");
    }
}
