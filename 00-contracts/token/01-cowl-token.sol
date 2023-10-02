// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract Cowl is Initializable, ERC20Upgradeable, AccessControlUpgradeable {
    using SafeMathUpgradeable for uint256;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant STAKER_ROLE = keccak256("STAKER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    uint256 public stakingRewardRate;
    uint256 public stakingDuration;
    
    struct StakingInfo {
        uint256 stakedAmount;
        uint256 stakingStartTime;
    }

    mapping(address => StakingInfo) public stakingData; 

    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount, uint256 reward);

    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply,
        address admin
    ) public initializer {
        __ERC20_init(_name, _symbol);
        __AccessControl_init();
        
        _setupDecimals(_decimals);
        _mint(admin, _initialSupply * (10 ** uint256(_decimals)));
        
        _setupRole(ADMIN_ROLE, admin);
        _setupRole(MINTER_ROLE, admin); 
        _setupRole(STAKER_ROLE, admin); 

        stakingRewardRate = 100; // example rate, can be adjusted as per the need.
        stakingDuration = 30 days; // example duration, can be adjusted as per the need.
    }

    function stake(uint256 _amount) external onlyRole(STAKER_ROLE) {
        require(_amount > 0, "Amount must be greater than 0");
        require(
            balanceOf(msg.sender) >= _amount,
            "Insufficient balance to stake"
        );

        _burn(msg.sender, _amount);
        
        StakingInfo storage info = stakingData[msg.sender];
        info.stakedAmount = info.stakedAmount.add(_amount);
        info.stakingStartTime = block.timestamp;

        emit Staked(msg.sender, _amount);
    }

    function unstake() external onlyRole(STAKER_ROLE) {
        StakingInfo storage info = stakingData[msg.sender];

        require(
            info.stakingStartTime.add(stakingDuration) <= block.timestamp,
            "Staking duration not met"
        );

        uint256 stakedAmount = info.stakedAmount;
        uint256 reward = stakedAmount.mul(stakingRewardRate).div(100);

        _mint(msg.sender, stakedAmount.add(reward));
        delete stakingData[msg.sender];

        emit Unstaked(msg.sender, stakedAmount, reward);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender) || hasRole(STAKER_ROLE, msg.sender), "Must have minter or staker role to burn");
        _burn(_msgSender(), amount);
    }
    
    function addRole(address account, bytes32 role) public onlyRole(ADMIN_ROLE) {
        grantRole(role, account);
    }
    
    function removeRole(address account, bytes32 role) public onlyRole(ADMIN_ROLE) {
        revokeRole(role, account);
    }

    function setStakingParameters(uint256 newRate, uint256 newDuration) public onlyRole(ADMIN_ROLE) {
        stakingRewardRate = newRate;
        stakingDuration = newDuration;
    }
}
