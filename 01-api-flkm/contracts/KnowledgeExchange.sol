// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

// Define the Knowledge Exchange Contract
contract KnowledgeExchangeContract is Ownable {
    using SafeMath for uint256;

    // State variables
    string public contractName;
    IERC20 public knowledgeToken; // Native token of FLKM

    // State variable to store user reputation
    mapping(address => string) public userReputation;
    // Mapping to associate each level with its title
    mapping(ReputationLevel => string) public levelTitles;
    // Mapping for reputation bonus values
    mapping(ReputationLevel => uint256) public reputationBonusValues;

    // 02 - Reputation and Bonus ***********************************************
    enum ReputationLevel {
        Mystic, // 0
        Luminary, // 1
        Oracle, // 2
        Prophet // 3
    }

    // 03 - Data *****************************************************************
    // Structure to represent a knowledge resource
    // Data
    struct KnowledgeResource {
        address creator;
        string title;
        string description;
        uint256 demand; // Score for the resource
        bool exists;
    }

    // Mapping to store knowledge resources
    mapping(uint256 => KnowledgeResource) public knowledgeResources;
    uint256 public nextResourceID = 1;

    // Models
    struct Model {
        address owner;
        uint256 creationDate;
        uint256 shelfLife;
        uint256 price;
        string description; // Description of what the model offers.
        uint256 qualityScore; // Could be an average of community reviews or other metrics.
        bool isEthical; // A flag to show if the model meets ethical standards.
        uint256 endorsements; // Number of users that have endorsed the model.
    }

    struct Review {
        address reviewer;
        uint256 modelId;
        uint256 score; // Rating score for the model.
        string comment; // Feedback about the model.
    }

    mapping(uint256 => Model) public models;
    mapping(uint256 => Review[]) public modelReviews;

    uint256 public nextModelId = 1;

    // 04 - Compensation for Data **********************************************************
    uint256 constant MINIMUM_COMPENSATION = 10;

    // Events to log important contract actions
    event ResourceUploaded(
        uint256 indexed resourceID,
        address indexed creator,
        string title,
        string description
    );
    event ResourceAccessed(uint256 indexed resourceID, address indexed user);

    // 05 - DKE *********************************************************************
    mapping(uint256 => KnowledgeCluster) public knowledgeClusters;
    uint256 public nextClusterID = 1;
    uint256 public nextIdeaID = 1;

    mapping(address => uint256) public funds;

    struct KnowledgeCluster {
        uint256 totalResources; // Represents any form of resources, can be funds, articles, research papers, etc.
        mapping(uint256 => GrowthIdea) growthIdeas;
        mapping(address => bool) hasSupported;
        mapping(uint256 => address[]) supporters;
        // cannot use mapping inside of a struct
    }

    struct GrowthIdea {
        address initiator;
        string idea;
        uint256 requiredFunds;
        uint256 supportVotes;
        uint256 fundsPledged;
        bool enacted;
    }

    // Event to log when a growth idea is executed.
    event GrowthIdeaExecuted(
        address indexed initiator,
        string ideaDescription,
        uint256 fundsAllocated
    );

    //mapping(uint256 => Milestone[]) public ideaMileston;

    // 10 - Helpers *************************************************************
    uint256 constant MAX_DEMAND = 1000; // An arbitrary cap on how much demand a resource can have.
    uint256 constant UNIQUENESS_SCALING_FACTOR = 10; // A scaling factor to make uniqueness calculations meaningful.
    uint256 constant CONTRIBUTION_SCALING_FACTOR = 5; // A scaling factor for calculating user contributions.

    // Event to log when the contract receives Ether
    event FundsReceived(address indexed sender, uint256 amount);

    // Constructor to initialize the contract
    constructor(string memory _contractName, address _knowledgeTokenAddress) {
        contractName = _contractName;
        knowledgeToken = IERC20(_knowledgeTokenAddress);
        levelTitles[ReputationLevel.Mystic] = "Mystic";
        levelTitles[ReputationLevel.Luminary] = "Luminary";
        levelTitles[ReputationLevel.Oracle] = "Oracle";
        levelTitles[ReputationLevel.Prophet] = "Prophet";
    }

    // 02 - Reputation ************************************************************************************************
    // Function to get the reputation rank of a user
    function getUserReputation(
        address _user
    ) internal view returns (string memory) {
        // Implement the logic to fetch and determine the reputation rank of a user.
        // Reputation ranks may be based on user activities, reviews, and engagement.
        // Return the reputation rank as a string (e.g., "Mystic," "Luminary," "Oracle," "Prophet").
        // Users with higher reputation ranks receive reputation-based bonuses.
        // Users with lower reputation ranks receive lower bonuses or none.
        // Adjust the logic based on platform goals and user interactions.
        //return "Mystic"; // Placeholder value, replace with actual
        return userReputation[_user];
    }

    // Function to get reputation level from string
    function getReputationLevel(
        string memory _userReputation
    ) internal view returns (ReputationLevel) {
        for (uint8 i = 0; i < 4; i++) {
            if (
                keccak256(abi.encodePacked(_userReputation)) ==
                keccak256(abi.encodePacked(levelTitles[ReputationLevel(i)]))
            ) {
                return ReputationLevel(i);
            }
        }
        revert("Invalid reputation string provided");
    }

    // Function to update a user's reputation based on their activity or achievements
    function updateUserReputation(
        address _user,
        ReputationLevel _newLevel
    ) external onlyOwner {
        // Check if the new level is higher than the current level
        require(
            (bytes(userReputation[_user]).length == 0 ||
                keccak256(bytes(userReputation[_user])) <
                keccak256(bytes(levelTitles[_newLevel]))),
            "Cannot decrease reputation level"
        );

        // Update the user's reputation
        userReputation[_user] = levelTitles[_newLevel];
    }

    // Function to calculate reputation-based bonus
    function calculateReputationBonus(
        string memory _userReputation
    ) internal view returns (uint256) {
        ReputationLevel level = getReputationLevel(_userReputation);

        // Return the bonus associated with the reputation level.
        return reputationBonusValues[level];
    }

    // 03 - Data ************************************************************************************************
    // Function to upload a knowledge resource
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
            exists: true // Set the resource as existing
        });

        emit ResourceUploaded(nextResourceID, msg.sender, _title, _description);
        nextResourceID++;
    }

    function accessResource(uint256 _resourceID) external {
        require(
            knowledgeResources[_resourceID].exists,
            "Resource does not exist"
        );

        knowledgeResources[_resourceID].demand++;

        uint256 compensationAmount = calculateCompensation(_resourceID);
        knowledgeToken.transferFrom(
            msg.sender,
            knowledgeResources[_resourceID].creator,
            compensationAmount
        );

        emit ResourceAccessed(_resourceID, msg.sender);
    }

    // 04 - Compensation for Data *********************************************************************************
    // Calculate compensation for accessing a resource
    function calculateCompensation(
        uint256 _resourceID
    ) internal view returns (uint256) {
        // Error handling for potential non-existing resource
        require(
            knowledgeResources[_resourceID].exists,
            "Resource does not exist"
        );

        // Resource Demand: Resources with higher demand receive higher compensation.
        // Demand can be determined by the number of accesses and resource importance.
        uint256 demand = knowledgeResources[_resourceID].demand;

        // User Reputation: Users with higher reputation ranks receive a reputation-based bonus.
        // Reputation ranks encourage users to contribute positively to the platform.
        uint256 reputationBonus = calculateReputationBonus(
            getUserReputation(msg.sender)
        );

        // Resource Uniqueness: Unique or rare resources receive higher compensation.
        uint256 uniquenessFactor = calculateUniquenessFactor(_resourceID);

        // Contributions: Users who contribute significantly to the platform may receive extra compensation.
        uint256 contributionBonus = calculateContributionBonus(msg.sender);

        // Simplify compensation calculation and ensure minimum compensation
        uint256 compensation = demand +
            reputationBonus +
            uniquenessFactor +
            contributionBonus;

        return
            (compensation < MINIMUM_COMPENSATION)
                ? MINIMUM_COMPENSATION
                : compensation;
    }

    // Function to calculate resource uniqueness factor
    function calculateUniquenessFactor(
        uint256 _resourceID
    ) internal view returns (uint256) {
        // Ensure the resource exists before calculating its uniqueness factor
        require(
            knowledgeResources[_resourceID].exists,
            "Resource does not exist"
        );

        // Here, I'm using the `demand` as a proxy for rarity:
        // rarer resources might have less demand (but this is a simplification).
        uint256 rarityFactor = MAX_DEMAND.sub(
            knowledgeResources[_resourceID].demand
        );

        // For true uniqueness you'd need other metrics, perhaps an "originality" score,
        // number of similar resources, etc. but those would need new data structures or external systems.

        // Just as an example, a scaling factor is applied to ensure this value remains meaningful.
        return rarityFactor.mul(UNIQUENESS_SCALING_FACTOR); // Placeholder, replace with actual logic.
    }

    // Function to count the number of resources uploaded by a given user.
    function countUserResources(
        address _userAddress
    ) internal view returns (uint256) {
        uint256 count = 0;
        // Iterate through all resources. This can be expensive in terms of gas!
        for (uint256 i = 1; i < nextResourceID; i++) {
            if (knowledgeResources[i].creator == _userAddress) {
                count++;
            }
        }
        return count;

        // NOTE: This method isn't optimal due to the potential high gas cost.
        // Ideally, you'd maintain a separate mapping to keep track of resources per user,
        // or a counter incremented every time a user uploads a new resource.
    }

    // Function to calculate the total demand of all resources uploaded by a given user.
    function calculateTotalUserDemand(
        address _userAddress
    ) internal view returns (uint256) {
        uint256 totalDemand = 0;
        // Iterate through all resources. This can be expensive in terms of gas!
        for (uint256 i = 1; i < nextResourceID; i++) {
            if (knowledgeResources[i].creator == _userAddress) {
                totalDemand += knowledgeResources[i].demand;
            }
        }
        return totalDemand;

        // NOTE: Similar to the above function, iterating through all resources is costly.
        // You might consider maintaining a separate mapping or state variable to store the cumulative
        // demand for each user. This way, you can update it incrementally rather than recalculating.
    }

    // Function to calculate contribution-based bonus for a user
    function calculateContributionBonus(
        address _userAddress
    ) internal view returns (uint256) {
        // This might be a function of the number of resources uploaded, their demand, and perhaps
        // other metrics related to the user's activity on the platform.

        uint256 resourcesUploaded = countUserResources(_userAddress); // You'd need to implement countUserResources
        uint256 totalUserDemand = calculateTotalUserDemand(_userAddress); // Another function you might need

        // Here, the bonus is proportional to the resources uploaded and their overall demand.
        return
            resourcesUploaded.mul(CONTRIBUTION_SCALING_FACTOR).add(
                totalUserDemand
            );

        // Alternatively, you could have a more intricate function taking into account other
        // contributions such as reviews, ratings, collaborations, etc.
    }

    // 11 - Models *********************************************************************************************************
    // Add compensation, payment, or incorporated into data compensation logic
    // Allow users to add their models to the marketplace.
    function addModel(
        uint256 _shelfLife,
        uint256 _price,
        string memory _description
    ) external {
        Model memory newModel = Model({
            owner: msg.sender,
            creationDate: block.timestamp,
            shelfLife: _shelfLife,
            price: _price,
            description: _description,
            qualityScore: 0,
            isEthical: false,
            endorsements: 0
        });

        models[nextModelId] = newModel;
        nextModelId++;
    }

    // Allow users to review and rate models.
    function reviewModel(
        uint256 _modelId,
        uint256 _score,
        string memory _comment
    ) external {
        Review memory newReview = Review({
            reviewer: msg.sender,
            modelId: _modelId,
            score: _score,
            comment: _comment
        });

        modelReviews[_modelId].push(newReview);

        // Update the model's quality score. For simplicity, just taking an average here.
        models[_modelId].qualityScore =
            (models[_modelId].qualityScore + _score) /
            2;
    }

    // Function for purchasing the model. For simplicity, this will transfer funds.
    function purchaseModel(uint256 _modelId) external payable {
        require(
            msg.value == models[_modelId].price,
            "Incorrect payment amount."
        );
        require(
            block.timestamp <=
                models[_modelId].creationDate + models[_modelId].shelfLife,
            "Model has expired."
        );

        // Transfer the funds to the model's owner.
        payable(models[_modelId].owner).transfer(msg.value);

        // A more complex implementation might provide the buyer with some token or access right.
    }

    // Endorse a model.
    function endorseModel(uint256 _modelId) external {
        models[_modelId].endorsements++;

        // You could add logic here to reward endorsers or increase the model's visibility/rank.
    }

    // Check if a model meets ethical guidelines. Create guidelines that are voted in and used to rate?
    // For the sake of this example, we're making it a manual check by the contract owner, but it could be more decentralized.
    function markModelAsEthical(uint256 _modelId) external onlyOwner {
        models[_modelId].isEthical = true;
    }

    // 12 - Compensation for Models ****************************************************************************************************

    // 05 - Decentralized Knowledge Evolution (DKE) Functions ***************************************************************************

    /*
    Collective Knowledge Cluster (CKC): The idea is to create a space
    that's not just a decision-making entity but a collaborative space
    where members can drive progress through collective wisdom.
    
    Proposing Ideas vs. Proposals: Instead of a bureaucratic-sounding
    'proposal', members 'propose growth ideas', making the process seem
    more organic and focused on development.
    
    Endorsements & Pledges: Instead of merely voting, members endorse ideas
    and can also pledge funds directly to the growth ideas they believe in.
    
    Enacting Ideas: If a growth idea has garnered enough endorsements and
    funds, it gets enacted. This makes the DAO more dynamic and focused on actions rather than just decision-making.
    */

    // Function to initiate a new Collective Knowledge Cluster (CKC)
    function initiateKnowledgeCluster() external onlyOwner {
        // Logic to initiate a new Knowledge Cluster
        // A CKC is a collaborative space for humans to drive progress through collective wisdom.

        // sarsar issues with mapping inside of a struct
        // knowledgeClusters[nextClusterID] = KnowledgeCluster({
        //     totalResources: 0
        // });

        nextClusterID++;
    }

    // Function to introduce a growth idea to the CKC
    function proposeGrowthIdea(
        uint256 _clusterID,
        string memory _idea,
        uint256 _requiredFunds
    ) external {
        // Propose a new growth idea to the CKC. Ideas could be projects, research, initiatives, etc.
        address thinker = msg.sender;

        // sarsar issues with mapping inside of a struct
        // knowledgeClusters[_clusterID].growthIdeas[nextIdeaID] = GrowthIdea({
        //     initiator: thinker,
        //     idea: _idea,
        //     requiredFunds: _requiredFunds,
        //     supportVotes: 0,
        //     fundsPledged: 0
        // });

        nextIdeaID++;
    }

    // Function to rally behind a growth idea within a CKC
    function supportGrowthIdea(
        uint256 _clusterID,
        uint256 _ideaID,
        bool _endorse,
        uint256 _pledgedAmount
    ) external {
        // Show your support or concerns for a proposed growth idea by endorsing and/or pledging funds.

        address supporter = msg.sender;
        require(
            !knowledgeClusters[_clusterID].hasSupported[supporter],
            "Already showed support for this idea"
        );

        knowledgeClusters[_clusterID].hasSupported[supporter] = true;
        knowledgeClusters[_clusterID].supporters[_ideaID].push(supporter);

        if (_endorse) {
            knowledgeClusters[_clusterID].growthIdeas[_ideaID].supportVotes++;
            knowledgeClusters[_clusterID]
                .growthIdeas[_ideaID]
                .fundsPledged += _pledgedAmount;
        }
    }

    // Function to enact a growth idea within a CKC
    function enactGrowthIdea(uint256 _clusterID, uint256 _ideaID) external {
        // If a growth idea meets collective criteria (e.g., enough endorsements or pledged funds), it gets enacted.

        require(
            knowledgeClusters[_clusterID].growthIdeas[_ideaID].fundsPledged >=
                knowledgeClusters[_clusterID]
                    .growthIdeas[_ideaID]
                    .requiredFunds,
            "Not enough funds pledged for this idea."
        );

        // Execute the growth idea.
        executeGrowthIdea(knowledgeClusters[_clusterID].growthIdeas[_ideaID]);

        knowledgeClusters[_clusterID].growthIdeas[_ideaID].enacted = true;
    }

    function executeGrowthIdea(GrowthIdea memory _idea) internal {
        // Ensure that the DAO has sufficient funds to allocate.
        require(
            funds[address(this)] >= _idea.fundsPledged,
            "DAO does not have enough funds to support this idea."
        );

        // Deduct funds from the DAO.
        funds[address(this)] -= _idea.fundsPledged;

        // Transfer the funds to the initiator of the idea.
        funds[_idea.initiator] += _idea.fundsPledged;

        // Emit an event for transparency and logging purposes.
        emit GrowthIdeaExecuted(
            _idea.initiator,
            _idea.idea,
            _idea.fundsPledged
        );
    }

    // Update the contract name (only callable by the contract owner)
    function updateContractName(string memory _newName) external onlyOwner {
        contractName = _newName;
    }

    // Fallback function to receive Ether
    fallback() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    receive() external payable {
        // custom function code
    }
}
