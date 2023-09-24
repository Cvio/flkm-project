// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract KnowledgeExchangeContract is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    string public contractName;
    IERC20 public knowledgeToken;

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

    constructor(string memory _contractName, address _knowledgeTokenAddress) {
        contractName = _contractName;
        knowledgeToken = IERC20(_knowledgeTokenAddress);
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
    ) external onlyOwner {
        require(
            userReputation[_user] < _newLevel,
            "Cannot decrease reputation level"
        );
        userReputation[_user] = _newLevel;
    }

    function updateReputationBonusValue(
        ReputationLevel _level,
        uint256 _value
    ) external onlyOwner {
        reputationBonusValues[_level] = _value;
    }

    function updateContractName(string memory _newName) external onlyOwner {
        contractName = _newName;
    }

    // Function to accept Ether. Emit an event to log the received Ether.
    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    event FundsReceived(address indexed sender, uint256 amount);
}
