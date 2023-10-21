// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

contract CowlDaoBaseOne is
    Initializable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable
{
    function initialize(
        IERC20Upgradeable _rewardToken,
        address _waningLight
    ) public initializer {
        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();

        rewardToken = _rewardToken;
        waningLight = IERC721Upgradeable(_waningLight);

        _grantRole(OWNER_ROLE, msg.sender);
        _setRoleAdmin(ADMIN_ROLE, OWNER_ROLE);

        parameters[ParamType.RewardAmount] = 1000;
        parameters[ParamType.ModificationVoteRequirement] = 10;
        parameters[ParamType.ModificationApprovalThreshold] = 5;
        parameters[ParamType.AuthorRewardAmount] = 500;
        parameters[ParamType.VoterRewardAmount] = 50;
        parameters[ParamType.EthicalVoteRequirement] = 10;
    }

    // Define roles
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    // Define state variables
    IERC20Upgradeable public rewardToken;
    IERC721Upgradeable public waningLight;

    // Enum for Parameter Type
    enum ParamType {
        RewardAmount,
        ModificationVoteRequirement,
        ModificationApprovalThreshold,
        AuthorRewardAmount,
        VoterRewardAmount,
        EthicalVoteRequirement
    }

    mapping(ParamType => uint256) public parameters;

    // Define State variable for Circuit Breaker Pattern
    bool private _stopped = false;

    // ID counters for various entities.
    uint32 public nextClusterID = 1;
    uint32 public nextKnowledgeID = 1;
    uint32 public nextIdeaID = 1;
    uint32 public nextEthicalProposalID = 1;

    // Reward and vote requirements.
    uint256 public rewardAmount = 1000;
    uint256 public modificationVoteRequirement = 10;
    uint256 public modificationApprovalThreshold = 5;
    uint256 public authorRewardAmount = 500;
    uint256 public voterRewardAmount = 50;
    uint256 public ethicalVoteRequirement = 10; // Required votes to pass an ethical proposal.

    // Modifier to restrict functions to DAO roles
    modifier onlyMember() {
        require(waningLight.balanceOf(msg.sender) > 0, "Not a DAO member");
        _;
    }

    modifier onlyOwner() {
        require(hasRole(OWNER_ROLE, msg.sender), "Must have owner role");
        _;
    }

    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Must have admin role");
        _;
    }

    modifier onlyOwnerOrAdmin() {
        require(
            hasRole(OWNER_ROLE, msg.sender) || hasRole(ADMIN_ROLE, msg.sender),
            "Must have owner or admin role"
        );
        _;
    }

    // Knowledge structure
    struct Knowledge {
        address author;
        string content;
        uint256 upvotes;
        uint256 clusterID;
    }

    // Growth idea structure
    struct GrowthIdea {
        address initiator;
        string idea;
        uint64 requiredFunds;
        uint64 fundsPledged;
        uint64 supportVotes;
        bool enacted;
        uint256 clusterID;
    }

    // Modification proposal structure
    struct ModificationProposal {
        uint256 knowledgeId;
        address proposer;
        string newContent;
        uint64 votes;
    }

    // Ethical proposal structure
    struct EthicalProposal {
        uint256 knowledgeId;
        address proposer;
        string ethicalConsideration;
        uint64 votes;
    }

    // Mapping to store knowledge, growth ideas, and resources
    mapping(uint256 => Knowledge) public knowledgeBase;
    mapping(uint256 => GrowthIdea) public growthIdeas;
    mapping(uint256 => uint256) public totalResourcesPerCluster;
    mapping(address => uint256) public rewards;
    mapping(uint256 => mapping(address => bool)) public knowledgeVoters;
    mapping(uint256 => mapping(address => bool)) public proposalVoters;
    ModificationProposal[] public modificationProposals;

    mapping(uint256 => EthicalProposal) public ethicalProposals;
    mapping(uint256 => mapping(address => bool)) public ethicalProposalVoters;

    // Event declarations
    event KnowledgeAdded(
        uint256 knowledgeID,
        address author,
        string content,
        uint256 clusterID
    );
    event GrowthIdeaProposed(
        uint256 ideaID,
        address initiator,
        string idea,
        uint64 requiredFunds,
        uint256 clusterID
    );
    event GrowthIdeaSupported(
        uint256 ideaID,
        address supporter,
        uint64 pledgedAmount
    );
    event GrowthIdeaEnacted(uint256 ideaID);
    event ModificationProposed(
        uint256 modificationID,
        uint256 knowledgeId,
        address proposer,
        string newContent
    );
    event ModificationImplemented(
        uint256 modificationID,
        uint256 knowledgeId,
        address proposer,
        string newContent
    );
    event EthicalProposalCreated(
        uint256 proposalID,
        uint256 knowledgeId,
        address proposer,
        string ethicalConsideration
    );
    event EthicalProposalAccepted(
        uint256 proposalID,
        uint256 knowledgeId,
        string ethicalConsideration
    );
}
