// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title CowlDAO
 * @dev Contract for decentralized autonomous organization.
 */
contract CowlDaoBase is
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

    /**
     * @dev This section declares state variables.
     * State variables are used to store data on the blockchain.
     */
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
    uint256 public nextClusterID = 1;
    uint256 public nextKnowledgeID = 1;
    uint256 public nextIdeaID = 1;
    uint256 public nextEthicalProposalID = 1;

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
        uint256 requiredFunds;
        uint256 supportVotes;
        uint256 fundsPledged;
        bool enacted;
        uint256 clusterID;
    }

    // Modification proposal structure
    struct ModificationProposal {
        uint256 knowledgeId;
        address proposer;
        string newContent;
        uint256 votes;
    }

    // Ethical proposal structure
    struct EthicalProposal {
        uint256 knowledgeId;
        address proposer;
        string ethicalConsideration;
        uint256 votes;
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
        uint256 requiredFunds,
        uint256 clusterID
    );
    event GrowthIdeaSupported(
        uint256 ideaID,
        address supporter,
        uint256 pledgedAmount
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

    // Constructor to initialize state variables
    // constructor(IERC20Upgradeable _rewardToken, address _waningLight) {
    //     rewardToken = _rewardToken;
    //     waningLight = IERC721Upgradeable(_waningLight);
    // }

    // Function to initiate a knowledge cluster
    function initiateKnowledgeCluster() external onlyOwner whenNotPaused {
        totalResourcesPerCluster[nextClusterID++] = 0;
    }

    function validateClusterID(uint256 _clusterID) internal view {
        require(
            totalResourcesPerCluster[_clusterID] != 0,
            "Invalid Cluster ID"
        );
    }

    // Function for members to contribute knowledge
    function contributeKnowledge(
        string memory _content,
        uint256 _clusterID
    ) external onlyMember whenNotPaused {
        validateClusterID(_clusterID);
        knowledgeBase[nextKnowledgeID] = Knowledge(
            msg.sender,
            _content,
            0,
            _clusterID
        );
        emit KnowledgeAdded(
            nextKnowledgeID++,
            msg.sender,
            _content,
            _clusterID
        );
        rewards[msg.sender] += rewardAmount;
    }

    // Function to upvote knowledge
    function upvoteKnowledge(
        uint256 _knowledgeId
    ) external onlyMember whenNotPaused {
        require(
            knowledgeBase[_knowledgeId].author != address(0),
            "Invalid Knowledge ID"
        );
        require(!knowledgeVoters[_knowledgeId][msg.sender], "Already voted");
        knowledgeBase[_knowledgeId].upvotes += 1;
        knowledgeVoters[_knowledgeId][msg.sender] = true;
        rewards[msg.sender] += voterRewardAmount;
        rewards[knowledgeBase[_knowledgeId].author] += voterRewardAmount;
    }

    // Function to support growth idea
    function supportGrowthIdea(
        uint256 _ideaID,
        uint256 _pledgedAmount
    ) external onlyMember whenNotPaused {
        require(
            growthIdeas[_ideaID].initiator != address(0),
            "Invalid Idea ID"
        );
        GrowthIdea storage idea = growthIdeas[_ideaID];
        require(!idea.enacted, "Idea already enacted");
        idea.supportVotes++;
        idea.fundsPledged += _pledgedAmount;
        emit GrowthIdeaSupported(_ideaID, msg.sender, _pledgedAmount);
        rewards[msg.sender] += rewardAmount;
    }

    // Function to enact growth idea
    function enactGrowthIdea(
        uint256 _ideaID
    ) external onlyMember whenNotPaused {
        GrowthIdea storage idea = growthIdeas[_ideaID];
        require(!idea.enacted, "Idea already enacted");
        require(
            idea.fundsPledged >= idea.requiredFunds,
            "Not enough funds pledged for this idea."
        );

        idea.enacted = true;
        totalResourcesPerCluster[idea.clusterID] += idea.fundsPledged;

        require(
            rewardToken.transfer(idea.initiator, idea.fundsPledged),
            "Transfer failed"
        );
        emit GrowthIdeaEnacted(_ideaID);
    }

    // Function to propose modification
    function proposeModification(
        uint256 _knowledgeId,
        string memory _newContent
    ) external onlyMember whenNotPaused {
        ModificationProposal memory newProposal = ModificationProposal(
            _knowledgeId,
            msg.sender,
            _newContent,
            0
        );
        modificationProposals.push(newProposal);
        emit ModificationProposed(
            modificationProposals.length - 1,
            _knowledgeId,
            msg.sender,
            _newContent
        );
    }

    // Function to vote on modification
    function voteOnModification(
        uint256 _modificationId
    ) external onlyMember whenNotPaused {
        require(!proposalVoters[_modificationId][msg.sender], "Already voted");
        modificationProposals[_modificationId].votes += 1;
        proposalVoters[_modificationId][msg.sender] = true;
        rewards[msg.sender] += voterRewardAmount;
    }

    // Function to implement modification
    function implementModification(
        uint256 _modificationId
    ) external onlyMember whenNotPaused {
        require(
            modificationProposals[_modificationId].votes >=
                modificationVoteRequirement,
            "Not enough votes"
        );
        uint256 knowledgeId = modificationProposals[_modificationId]
            .knowledgeId;
        knowledgeBase[knowledgeId].content = modificationProposals[
            _modificationId
        ].newContent;
        emit ModificationImplemented(
            _modificationId,
            knowledgeId,
            modificationProposals[_modificationId].proposer,
            modificationProposals[_modificationId].newContent
        );
        rewards[
            modificationProposals[_modificationId].proposer
        ] += authorRewardAmount;
    }

    // Function to propose ethical consideration
    function proposeEthicalConsideration(
        uint256 _knowledgeId,
        string memory _ethicalConsideration
    ) external onlyMember whenNotPaused {
        ethicalProposals[nextEthicalProposalID] = EthicalProposal(
            _knowledgeId,
            msg.sender,
            _ethicalConsideration,
            0
        );
        emit EthicalProposalCreated(
            nextEthicalProposalID++,
            _knowledgeId,
            msg.sender,
            _ethicalConsideration
        );
    }

    // Function to vote on ethical proposal
    function voteOnEthicalProposal(
        uint256 _proposalID
    ) external onlyMember whenNotPaused {
        require(
            !ethicalProposalVoters[_proposalID][msg.sender],
            "Already voted"
        );
        ethicalProposals[_proposalID].votes += 1;
        ethicalProposalVoters[_proposalID][msg.sender] = true;
        rewards[msg.sender] += voterRewardAmount;
    }

    // Function to enact ethical proposal
    function enactEthicalProposal(
        uint256 _proposalID
    ) external onlyMember whenNotPaused {
        require(
            ethicalProposals[_proposalID].votes >= ethicalVoteRequirement,
            "Not enough votes"
        );
        uint256 knowledgeId = ethicalProposals[_proposalID].knowledgeId;
        emit EthicalProposalAccepted(
            _proposalID,
            knowledgeId,
            ethicalProposals[_proposalID].ethicalConsideration
        );
        rewards[ethicalProposals[_proposalID].proposer] += authorRewardAmount;
    }

    // Function to claim rewards
    function claimRewards() external nonReentrant {
        uint256 amount = rewards[msg.sender];
        require(amount > 0, "No rewards to claim");
        rewards[msg.sender] = 0;
        require(rewardToken.transfer(msg.sender, amount), "Transfer failed");
    }

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

    // Function to update DAO parameters
    function updateParameter(
        string memory _param,
        uint256 _value
    ) external onlyOwner {
        if (
            keccak256(abi.encodePacked(_param)) ==
            keccak256(abi.encodePacked("rewardAmount"))
        ) rewardAmount = _value;
        else if (
            keccak256(abi.encodePacked(_param)) ==
            keccak256(abi.encodePacked("modificationVoteRequirement"))
        ) modificationVoteRequirement = _value;
        else if (
            keccak256(abi.encodePacked(_param)) ==
            keccak256(abi.encodePacked("modificationApprovalThreshold"))
        ) modificationApprovalThreshold = _value;
        else if (
            keccak256(abi.encodePacked(_param)) ==
            keccak256(abi.encodePacked("authorRewardAmount"))
        ) authorRewardAmount = _value;
        else if (
            keccak256(abi.encodePacked(_param)) ==
            keccak256(abi.encodePacked("voterRewardAmount"))
        ) voterRewardAmount = _value;
        else if (
            keccak256(abi.encodePacked(_param)) ==
            keccak256(abi.encodePacked("ethicalVoteRequirement"))
        ) ethicalVoteRequirement = _value;
    }
}
