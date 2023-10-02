// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

interface IDatasetNFTContract {
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract DataStakingContract is Initializable, AccessControlUpgradeable, ReentrancyGuardUpgradeable {
    
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

    function initialize(
        address _admin,
        address _rewardToken,
        address _datasetNFTContract,
        uint256 _initialRewardRate
    ) initializer public {
        __AccessControl_init();
        __ReentrancyGuard_init();

        rewardToken = IERC20Upgradeable(_rewardToken);
        datasetNFTContract = IDatasetNFTContract(_datasetNFTContract);
        rewardRate = _initialRewardRate;
        
        _setupRole(ADMIN_ROLE, _admin);
    }

    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Not an admin");
        _;
    }

    function setRewardRate(uint256 newRate) external onlyAdmin {
        rewardRate = newRate;
        emit RewardRateChanged(newRate);
    }

    function stake(uint256 tokenId) external nonReentrant {
        address owner = datasetNFTContract.ownerOf(tokenId);
        require(owner == msg.sender, "Not the owner of the token");

        stakes[msg.sender].push(Stake(tokenId, block.timestamp));

        emit Staked(msg.sender, tokenId);
    }

    function unstake(uint256 tokenId) external nonReentrant {
        address owner = datasetNFTContract.ownerOf(tokenId);
        require(owner == msg.sender, "Not the owner of the token");

        uint256 reward = _calculateReward(msg.sender, tokenId);
        _removeStake(msg.sender, tokenId);
        
        rewardToken.transfer(msg.sender, reward); // Do a safe transfer in production code.
        
        emit Unstaked(msg.sender, tokenId, reward);
    }

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

    function setRewardRate(uint256 newRate) external onlyAdmin {
        rewardRate = newRate;
        emit RewardRateChanged(newRate);
    }
    
    function setBonusRate(uint256 newRate) external onlyAdmin {
        bonusRate = newRate;
        emit BonusRateChanged(newRate);
    }

    function _calculateReward(address staker, uint256 tokenId) internal view returns (uint256) {
        uint256 len = stakes[staker].length;
        for (uint256 i = 0; i < len; i++) {
            if (stakes[staker][i].tokenId == tokenId) {
                uint256 timeStaked = block.timestamp - stakes[staker][i].timestamp;
                return timeStaked * rewardRate; // In real implementation, you might have different reward rates for different tokens.
            }
        }
        revert("Token not staked");
    }

    event RewardRateChanged(uint256 newRate);
    event BonusRateChanged(uint256 newRate);
}
