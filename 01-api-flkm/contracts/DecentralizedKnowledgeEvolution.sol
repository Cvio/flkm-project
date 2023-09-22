// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DecentralizedKnowledgeEvolution is Ownable {

    IERC20 public rewardToken;
    uint256 public modificationApprovalThreshold = 10; // Example threshold
    uint256 public authorRewardAmount = 50; // Example amount
    uint256 public voterRewardAmount = 5; // Example amount

    struct Knowledge {
        address author;
        string content;
        uint256 upvotes;
    }

    struct ModificationProposal {
        uint256 knowledgeId;
        address proposer;
        string newContent;
        uint256 votes;
    }

    Knowledge[] public knowledgeBase;
    ModificationProposal[] public modificationProposals;

    mapping(address => uint256) public rewards;
    mapping(uint256 => mapping(address => bool)) public knowledgeVoters;
    mapping(uint256 => mapping(address => bool)) public proposalVoters;

    event KnowledgeContributed(uint256 knowledgeId, address indexed author);
    event KnowledgeUpvoted(uint256 knowledgeId, address indexed voter);
    event ModificationProposed(uint256 modificationId, address indexed proposer);
    event ModificationImplemented(uint256 modificationId, address indexed executor);

    constructor(address _rewardToken) {
        rewardToken = IERC20(_rewardToken);
    }

    function contributeKnowledge(string memory _content) external {
        Knowledge memory newKnowledge;
        newKnowledge.author = msg.sender;
        newKnowledge.content = _content;
        knowledgeBase.push(newKnowledge);
        rewards[msg.sender] += authorRewardAmount; // Reward the contributor
        emit KnowledgeContributed(knowledgeBase.length - 1, msg.sender);
    }

    function upvoteKnowledge(uint256 _knowledgeId) external {
        require(!knowledgeVoters[_knowledgeId][msg.sender], "Already voted");
        knowledgeBase[_knowledgeId].upvotes += 1;
        knowledgeVoters[_knowledgeId][msg.sender] = true;
        rewards[msg.sender] += voterRewardAmount; // Reward the voter
        rewards[knowledgeBase[_knowledgeId].author] += voterRewardAmount; // Reward the author
        emit KnowledgeUpvoted(_knowledgeId, msg.sender);
    }

    function proposeModification(uint256 _knowledgeId, string memory _newContent) external {
        ModificationProposal memory newProposal;
        newProposal.knowledgeId = _knowledgeId;
        newProposal.proposer = msg.sender;
        newProposal.newContent = _newContent;
        modificationProposals.push(newProposal);
        emit ModificationProposed(modificationProposals.length - 1, msg.sender);
    }

    function voteOnModification(uint256 _modificationId) external {
        require(!proposalVoters[_modificationId][msg.sender], "Already voted");
        modificationProposals[_modificationId].votes += 1;
        proposalVoters[_modificationId][msg.sender] = true;
        rewards[msg.sender] += voterRewardAmount; // Reward the voter

        if (modificationProposals[_modificationId].votes >= modificationApprovalThreshold) {
            implementModification(_modificationId);
        }
    }

    function implementModification(uint256 _modificationId) public {
        require(modificationProposals[_modificationId].votes >= modificationApprovalThreshold, "Not enough votes");
        Knowledge storage original = knowledgeBase[modificationProposals[_modificationId].knowledgeId];
        original.content = modificationProposals[_modificationId].newContent;
        rewards[modificationProposals[_modificationId].proposer] += authorRewardAmount; // Reward the proposer
        emit ModificationImplemented(_modificationId, msg.sender);
    }

    function claimRewards() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");
        rewards[msg.sender] = 0;
        rewardToken.transfer(msg.sender, reward);
    }

    function updateParameter(string memory parameter, uint256 value) external onlyOwner {
        if (keccak256(abi.encodePacked(parameter)) == keccak256(abi.encodePacked("modificationApprovalThreshold"))) {
            modificationApprovalThreshold = value;
        } else if (keccak256(abi.encodePacked(parameter)) == keccak256(abi.encodePacked("authorRewardAmount"))) {
            authorRewardAmount = value;
        } else if (keccak256(abi.encodePacked(parameter)) == keccak256(abi.encodePacked("voterRewardAmount"))) {
            voterRewardAmount = value;
        } else {
            revert("Invalid parameter");
        }
    }
}
