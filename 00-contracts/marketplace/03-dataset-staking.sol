// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "../../node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./02-federated-marketplace.sol";

interface IDatasetNFTContract {
    function ownerOf(uint256 tokenId) external view returns (address);
}

/**
 * @title DataStakingContract
 * @dev A contract for staking NFT tokens and earning rewards in a specified ERC20 token.
 */
contract DataStakingContract is
    Initializable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable
{
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    IERC20Upgradeable public rewardToken;
    IDatasetNFTContract public datasetNFTContract;

    uint256 public rewardRate; // Reward rate in token per second per token staked.
    uint256 public bonusRate; // Hypothetical additional parameter to adjust rewards.

    struct Stake {
        uint256 tokenId;
        uint256 timestamp;
    }

    mapping(address => Stake[]) public stakes;

    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId, uint256 reward);
    event RewardRateChanged(uint256 newRate);
    event BonusRateChanged(uint256 newRate);

    /**
     * @dev Initializes the contract with the specified admin, reward token, dataset NFT contract, and initial reward rate.
     * @param _admin The address of the admin.
     * @param _rewardToken The address of the ERC20 token used for rewards.
     * @param _datasetNFTContract The address of the dataset NFT contract.
     * @param _initialRewardRate The initial reward rate in token per second per token staked.
     */
    function initialize(
        address _admin,
        address _rewardToken,
        address _datasetNFTContract,
        uint256 _initialRewardRate
    ) public initializer {
        __AccessControl_init();
        __ReentrancyGuard_init();

        rewardToken = IERC20Upgradeable(_rewardToken);
        datasetNFTContract = IDatasetNFTContract(_datasetNFTContract);
        rewardRate = _initialRewardRate;

        _grantRole(ADMIN_ROLE, _admin);
    }

    /**
     * @dev Modifier to check if the caller has the admin role.
     */
    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Not an admin");
        _;
    }

    /**
     * @dev Stakes the specified token for the caller.
     * @param tokenId The ID of the token to stake.
     */
    function stake(uint256 tokenId) external nonReentrant {
        address owner = datasetNFTContract.ownerOf(tokenId);
        require(owner == msg.sender, "Not the owner of the token");

        stakes[msg.sender].push(Stake(tokenId, block.timestamp));

        emit Staked(msg.sender, tokenId);
    }

    /**
     * @dev Unstakes the specified token for the caller and transfers the earned rewards.
     * @param tokenId The ID of the token to unstake.
     */
    function unstake(uint256 tokenId) external nonReentrant {
        address owner = datasetNFTContract.ownerOf(tokenId);
        require(owner == msg.sender, "Not the owner of the token");

        uint256 reward = _calculateReward(msg.sender, tokenId);
        _removeStake(msg.sender, tokenId);

        rewardToken.transfer(msg.sender, reward); // Do a safe transfer in production code.

        emit Unstaked(msg.sender, tokenId, reward);
    }

    /**
     * @dev Removes the specified stake for the specified staker.
     * @param staker The address of the staker.
     * @param tokenId The ID of the token to remove the stake for.
     */
    function _removeStake(address staker, uint256 tokenId) internal {
        uint256 len = stakes[staker].length;
        for (uint256 i = 0; i < len; i++) {
            if (stakes[staker][i].tokenId == tokenId) {
                if (i != len - 1) {
                    stakes[staker][i] = stakes[staker][len - 1];
                }
                stakes[staker].pop();
                break;
            }
        }
    }

    /**
     * @dev Sets the reward rate.
     * @param newRate The new reward rate in token per second per token staked.
     */
    function setRewardRate(uint256 newRate) external onlyAdmin {
        rewardRate = newRate;
        emit RewardRateChanged(newRate);
    }

    /**
     * @dev Sets the bonus rate.
     * @param newRate The new bonus rate.
     */
    function setBonusRate(uint256 newRate) external onlyAdmin {
        bonusRate = newRate;
        emit BonusRateChanged(newRate);
    }

    /**
     * @dev Calculates the reward for the specified staker and token.
     * @param staker The address of the staker.
     * @param tokenId The ID of the token to calculate the reward for.
     * @return The reward in the ERC20 token.
     */
    function _calculateReward(
        address staker,
        uint256 tokenId
    ) internal view returns (uint256) {
        uint256 len = stakes[staker].length;
        for (uint256 i = 0; i < len; i++) {
            if (stakes[staker][i].tokenId == tokenId) {
                uint256 timeStaked = block.timestamp -
                    stakes[staker][i].timestamp;
                return timeStaked * rewardRate; // In real implementation, you might have different reward rates for different tokens.
            }
        }
        revert("Token not staked");
    }

    /**
     * @dev Checks if the specified token exists.
     * @param tokenId The ID of the token to check.
     * @return A boolean indicating whether the token exists.
     */
    // function _exists(uint256 tokenId) internal view returns (bool) {
    //     return _ownerOf(tokenId) != address(0);
    // }
}
