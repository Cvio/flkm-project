// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
// import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

import "../../node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract KnowledgeExchangeContract is
    Initializable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable
{
    using SafeMathUpgradeable for uint256;
    string public contractName;
    IERC20Upgradeable public knowledgeToken;

    // Define the roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    enum ReputationLevel {
        Supplicant,
        Initiate,
        Mystic,
        Luminary,
        Oracle,
        Prophet
    }

    mapping(address => ReputationLevel) public userReputation;
    mapping(ReputationLevel => uint256) public reputationBonusValues;

    struct Vote {
        address nominated;
        ReputationLevel proposedLevel;
        uint256 forVotes;
        uint256 againstVotes;
    }

    mapping(uint256 => Vote) public votes;
    mapping(uint256 => mapping(address => bool)) public voteTrackers; // New mapping to track user votes
    uint256 public nextVoteID = 1;

    event VoteStarted(
        uint256 indexed voteID,
        address indexed nominated,
        ReputationLevel proposedLevel
    );
    event Voted(uint256 indexed voteID, address indexed voter, bool support);

    mapping(address => uint256) public userResourceCount;
    mapping(address => uint256) public userTotalDemand;

    struct KnowledgeResource {
        address creator;
        string title;
        string description;
        uint256 demand;
        bool exists;
    }

    mapping(uint256 => KnowledgeResource) public knowledgeResources;
    uint256 public nextResourceID = 1;

    uint256 constant MINIMUM_COMPENSATION = 10;
    uint256 constant MAX_DEMAND = 1000;
    uint256 constant UNIQUENESS_SCALING_FACTOR = 10;
    uint256 constant CONTRIBUTION_SCALING_FACTOR = 5;

    event ResourceUploaded(
        uint256 indexed resourceID,
        address indexed creator,
        string title,
        string description
    );
    event ResourceAccessed(uint256 indexed resourceID, address indexed user);

    function initialize(
        string memory _contractName,
        address _knowledgeTokenAddress
    ) public initializer {
        __AccessControl_init(); // Initialize AccessControl
        __ReentrancyGuard_init(); // Initialize ReentrancyGuard

        // Grant the sender the admin role
        _setupRole(ADMIN_ROLE, msg.sender);

        contractName = _contractName;
        knowledgeToken = IERC20Upgradeable(_knowledgeTokenAddress);
    }

    function uploadResource(
        string memory _title,
        string memory _description
    ) external {
        require(
            knowledgeToken.balanceOf(msg.sender) >= 100,
            "Insufficient knowledge tokens"
        );

        knowledgeResources[nextResourceID] = KnowledgeResource({
            creator: msg.sender,
            title: _title,
            description: _description,
            demand: 0,
            exists: true
        });

        userResourceCount[msg.sender]++;
        emit ResourceUploaded(nextResourceID, msg.sender, _title, _description);
        nextResourceID++;
    }

    function accessResource(uint256 _resourceID) external nonReentrant {
        require(
            knowledgeResources[_resourceID].exists,
            "Resource does not exist"
        );

        knowledgeResources[_resourceID].demand++;
        userTotalDemand[knowledgeResources[_resourceID].creator]++;

        uint256 compensationAmount = calculateCompensation(_resourceID);
        knowledgeToken.transferFrom(
            msg.sender,
            knowledgeResources[_resourceID].creator,
            compensationAmount
        );

        emit ResourceAccessed(_resourceID, msg.sender);
    }

    function calculateCompensation(
        uint256 _resourceID
    ) internal view returns (uint256) {
        require(
            knowledgeResources[_resourceID].exists,
            "Resource does not exist"
        );

        uint256 demand = knowledgeResources[_resourceID].demand;
        uint256 reputationBonus = reputationBonusValues[
            userReputation[msg.sender]
        ];
        uint256 uniquenessFactor = MAX_DEMAND.sub(demand).mul(
            UNIQUENESS_SCALING_FACTOR
        );
        uint256 contributionBonus = userResourceCount[msg.sender]
            .mul(CONTRIBUTION_SCALING_FACTOR)
            .add(userTotalDemand[msg.sender]);

        uint256 compensation = demand
            .add(reputationBonus)
            .add(uniquenessFactor)
            .add(contributionBonus);
        return
            (compensation < MINIMUM_COMPENSATION)
                ? MINIMUM_COMPENSATION
                : compensation;
    }

    function updateUserReputation(
        address _user,
        ReputationLevel _newLevel
    ) external {
        require(hasRole(ADMIN_ROLE, msg.sender), "Must have admin role");
        userReputation[_user] = _newLevel;
    }

    function updateReputationBonusValue(
        ReputationLevel _level,
        uint256 _value
    ) external {
        require(hasRole(ADMIN_ROLE, msg.sender), "Must have admin role");
        reputationBonusValues[_level] = _value;
    }

    // Start a new vote
    function startVote(address _user, ReputationLevel _proposedLevel) external {
        votes[nextVoteID] = Vote({
            nominated: _user,
            proposedLevel: _proposedLevel,
            forVotes: 0,
            againstVotes: 0
        });
        emit VoteStarted(nextVoteID, _user, _proposedLevel);
        nextVoteID++;
    }

    // Cast vote
    function castVote(uint256 _voteID, bool _support) external {
        require(!voteTrackers[_voteID][msg.sender], "User has already voted");

        voteTrackers[_voteID][msg.sender] = true; // Mark the user as voted
        if (_support) {
            votes[_voteID].forVotes++;
        } else {
            votes[_voteID].againstVotes++;
        }
        emit Voted(_voteID, msg.sender, _support);
    }

    // End a vote and update reputation
    function endVote(uint256 _voteID) external {
        require(
            votes[_voteID].forVotes > votes[_voteID].againstVotes,
            "Vote did not pass"
        );

        // You can also add a requirement for minimum quorum etc.

        userReputation[votes[_voteID].nominated] = votes[_voteID].proposedLevel;

        // Clean up to free storage and gas refund
        delete votes[_voteID];
    }

    function updateContractName(string memory _newName) external {
        require(hasRole(ADMIN_ROLE, msg.sender), "Must have admin role");
        contractName = _newName;
    }

    // Function to accept Ether. Emit an event to log the received Ether.
    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    event FundsReceived(address indexed sender, uint256 amount);
}
