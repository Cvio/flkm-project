// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../../../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../../../../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract CowlDAO is Ownable, ReentrancyGuard {
    IERC20 public rewardToken;
    IERC721 public eternalLight;
    uint256 public nextClusterID = 1;
    uint256 public nextKnowledgeID = 1;
    uint256 public nextIdeaID = 1;
    uint256 public rewardAmount = 1000;
    uint256 public modificationVoteRequirement = 10;

    // Newly Added State Variables
    uint256 public modificationApprovalThreshold = 5;
    uint256 public authorRewardAmount = 500;
    uint256 public voterRewardAmount = 50;

    uint256 public nextEthicalProposalID = 1;
    uint256 public ethicalVoteRequirement = 10; // Number of votes required to pass an ethical proposal

    modifier onlyMember() {
        require(eternalLight.balanceOf(msg.sender) > 0, "Not a DAO member");
        _;
    }

    struct Knowledge {
        address author;
        string content;
        uint256 upvotes;
        uint256 clusterID;
    }

    struct GrowthIdea {
        address initiator;
        string idea;
        uint256 requiredFunds;
        uint256 supportVotes;
        uint256 fundsPledged;
        bool enacted;
        uint256 clusterID;
    }

    struct ModificationProposal {
        uint256 knowledgeId;
        address proposer;
        string newContent;
        uint256 votes;
    }

    struct EthicalProposal {
        uint256 knowledgeId;
        address proposer;
        string ethicalConsideration;
        uint256 votes;
    }

    mapping(uint256 => Knowledge) public knowledgeBase;
    mapping(uint256 => GrowthIdea) public growthIdeas;
    mapping(uint256 => uint256) public totalResourcesPerCluster;
    mapping(address => uint256) public rewards;
    mapping(uint256 => mapping(address => bool)) public knowledgeVoters;
    mapping(uint256 => mapping(address => bool)) public proposalVoters;
    ModificationProposal[] public modificationProposals;

    mapping(uint256 => EthicalProposal) public ethicalProposals;
    mapping(uint256 => mapping(address => bool)) public ethicalProposalVoters;

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

    constructor(IERC20 _rewardToken, address _eternalLight) {
        rewardToken = _rewardToken;
        eternalLight = IERC721(_eternalLight); // Initialized the NFT contract address
    }

    function initiateKnowledgeCluster() external onlyOwner {
        totalResourcesPerCluster[nextClusterID++] = 0;
    }

    function contributeKnowledge(
        string memory _content,
        uint256 _clusterID
    ) external {
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

    function upvoteKnowledge(uint256 _knowledgeId) external {
        require(!knowledgeVoters[_knowledgeId][msg.sender], "Already voted");
        knowledgeBase[_knowledgeId].upvotes += 1;
        knowledgeVoters[_knowledgeId][msg.sender] = true;
        rewards[msg.sender] += voterRewardAmount;
        rewards[knowledgeBase[_knowledgeId].author] += voterRewardAmount;
    }

    function supportGrowthIdea(
        uint256 _ideaID,
        uint256 _pledgedAmount
    ) external {
        GrowthIdea storage idea = growthIdeas[_ideaID];
        require(!idea.enacted, "Idea already enacted");
        idea.supportVotes++;
        idea.fundsPledged += _pledgedAmount;
        emit GrowthIdeaSupported(_ideaID, msg.sender, _pledgedAmount);
        rewards[msg.sender] += rewardAmount;
    }

    function enactGrowthIdea(uint256 _ideaID) external {
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

    function proposeModification(
        uint256 _knowledgeId,
        string memory _newContent
    ) external {
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

    function voteOnModification(uint256 _modificationId) external {
        require(!proposalVoters[_modificationId][msg.sender], "Already voted");
        modificationProposals[_modificationId].votes += 1;
        proposalVoters[_modificationId][msg.sender] = true;
        rewards[msg.sender] += voterRewardAmount;
    }

    function implementModification(uint256 _modificationId) external {
        require(
            modificationProposals[_modificationId].votes >=
                modificationVoteRequirement,
            "Not enough votes to modify content"
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
    }

    function createEthicalProposal(
        uint256 _knowledgeId,
        string memory _ethicalConsideration
    ) external {
        EthicalProposal memory newProposal = EthicalProposal(
            _knowledgeId,
            msg.sender,
            _ethicalConsideration,
            0
        );
        ethicalProposals[nextEthicalProposalID] = newProposal;
        emit EthicalProposalCreated(
            nextEthicalProposalID++,
            _knowledgeId,
            msg.sender,
            _ethicalConsideration
        );
    }

    function voteOnEthicalProposal(uint256 _proposalId) external {
        require(
            !ethicalProposalVoters[_proposalId][msg.sender],
            "Already voted"
        );
        ethicalProposals[_proposalId].votes += 1;
        ethicalProposalVoters[_proposalId][msg.sender] = true;
        rewards[msg.sender] += voterRewardAmount; // Reward the voter
    }

    function implementEthicalProposal(uint256 _proposalId) external {
        require(
            ethicalProposals[_proposalId].votes >= ethicalVoteRequirement,
            "Not enough votes to implement ethical consideration"
        );
        uint256 knowledgeId = ethicalProposals[_proposalId].knowledgeId;
        Knowledge storage knowledge = knowledgeBase[knowledgeId];

        // ??? modify the knowledge content based on the ethical considerations.
        // For example, flagging it as 'unethical' or appending the ethical considerations to the content.

        emit EthicalProposalAccepted(
            _proposalId,
            knowledgeId,
            ethicalProposals[_proposalId].ethicalConsideration
        );
    }

    function claimRewards() external nonReentrant {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");
        rewards[msg.sender] = 0;
        // Reentrancy guard
        rewardToken.transfer(msg.sender, reward);
    }

    function updateParameter(
        string memory _parameter,
        uint256 _value
    ) external onlyOwner {
        if (
            keccak256(abi.encodePacked(_parameter)) ==
            keccak256(abi.encodePacked("rewardAmount"))
        ) rewardAmount = _value;
        else if (
            keccak256(abi.encodePacked(_parameter)) ==
            keccak256(abi.encodePacked("modificationVoteRequirement"))
        ) modificationVoteRequirement = _value;
        else revert("Invalid Parameter");
    }
}
