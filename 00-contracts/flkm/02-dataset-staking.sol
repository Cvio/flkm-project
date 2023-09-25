pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DatasetStaking is ReentrancyGuard {
    using SafeMath for uint256;

    IERC20 public cowlToken;

    uint256 public constant requiredStakeAmount = 100 * 1e18;
    uint256 public constant initialReputation = 50;

    struct Dataset {
        address owner;
        uint256 stakedAmount;
        uint256 reputation;
        bool isActive;
        string ipfsHash;
        string filecoinDealId;
    }

    mapping(address => Dataset) public datasets;
    mapping(address => uint256) public rewards;

    event DatasetStaked(address indexed user, uint256 amount, string ipfsHash);
    event DatasetUpdated(
        address indexed dataset,
        uint256 reputation,
        bool isActive
    );
    event RewardClaimed(address indexed user, uint256 amount);
    event DatasetTransitionedToFilecoin(
        address indexed dataset,
        string filecoinDealId
    );

    modifier onlyOwnerOf(address _dataset) {
        require(
            msg.sender == datasets[_dataset].owner,
            "Not the owner of the dataset"
        );
        _;
    }

    constructor(address _cowlToken) {
        cowlToken = IERC20(_cowlToken);
    }

    function stakeDataset(string memory _ipfsHash) external nonReentrant {
        uint256 balance = cowlToken.balanceOf(msg.sender);
        require(balance >= requiredStakeAmount, "Insufficient balance");

        require(
            cowlToken.transferFrom(
                msg.sender,
                address(this),
                requiredStakeAmount
            ),
            "Transfer failed"
        );

        // Create a new dataset entry
        datasets[msg.sender] = Dataset({
            owner: msg.sender,
            stakedAmount: requiredStakeAmount,
            reputation: initialReputation,
            isActive: true,
            ipfsHash: _ipfsHash,
            filecoinDealId: ""
        });

        emit DatasetStaked(msg.sender, requiredStakeAmount, _ipfsHash);
    }

    function updateDataset(
        address _dataset,
        uint256 _newReputation,
        bool _newStatus
    ) external onlyOwnerOf(_dataset) {
        Dataset storage dataset = datasets[_dataset];
        dataset.reputation = _newReputation;
        dataset.isActive = _newStatus;

        emit DatasetUpdated(_dataset, _newReputation, _newStatus);
    }

    function transitionToFilecoin(
        address _dataset,
        string memory _filecoinDealId
    ) external onlyOwnerOf(_dataset) {
        Dataset storage dataset = datasets[_dataset];
        require(dataset.isActive, "Dataset is not active");

        dataset.filecoinDealId = _filecoinDealId;

        emit DatasetTransitionedToFilecoin(_dataset, _filecoinDealId);
    }

    function claimRewards() external nonReentrant {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");

        rewards[msg.sender] = 0;
        require(cowlToken.transfer(msg.sender, reward), "Transfer failed");

        emit RewardClaimed(msg.sender, reward);
    }

    function withdrawStake() external nonReentrant {
        Dataset storage dataset = datasets[msg.sender];
        require(dataset.stakedAmount > 0, "No staked amount available");

        uint256 amountToWithdraw = dataset.stakedAmount;
        dataset.stakedAmount = 0;
        require(
            cowlToken.transfer(msg.sender, amountToWithdraw),
            "Transfer failed"
        );
    }

    // Additional functionalities and internal logic can be added here.
    // - Access Management
    // - Rewards Calculation
    // - Penalty & Reputation System
    // - Interaction with other smart contracts
}
