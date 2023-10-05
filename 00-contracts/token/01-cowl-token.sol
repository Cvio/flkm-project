// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

// import "../../@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
// import "../../@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
// import "../../@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "../../@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract Cowl is Initializable, ERC20Upgradeable, AccessControlUpgradeable {
    using SafeMathUpgradeable for uint256;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant STAKER_ROLE = keccak256("STAKER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    uint8 private tokenDecimals;
    
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
        
        _decimals = _decimals; // set your private _decimals variable
        _mint(admin, _initialSupply * (10 ** uint256(_decimals)));
        
        _setupRole(ADMIN_ROLE, admin);
        _setupRole(MINTER_ROLE, admin); 
        _setupRole(STAKER_ROLE, admin); 

        stakingRewardRate = 100; // example rate, can be adjusted as per the need.
        stakingDuration = 30 days; // example duration, can be adjusted as per the need.
    }

    function decimals() public view virtual override returns (uint8) {
        return tokenDecimals;
    }

    function stake(uint256 _amount) external onlyRole(STAKER_ROLE) {
        require(_amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= _amount, "Insufficient balance to stake");

        // Transfer tokens to the contract's address instead of burning
        transfer(address(this), _amount);
        
        stakingData[msg.sender] = StakingInfo({
            stakedAmount: stakingData[msg.sender].stakedAmount.add(_amount),
            stakingStartTime: block.timestamp
        });

        emit Staked(msg.sender, _amount);
    }

    function unstake() external onlyRole(STAKER_ROLE) {
        StakingInfo storage info = stakingData[msg.sender];
        require(info.stakingStartTime.add(stakingDuration) <= block.timestamp, "Staking duration not met");
        require(info.stakedAmount > 0, "No staked amount found");

        uint256 reward = info.stakedAmount.mul(stakingRewardRate).div(100);
        uint256 totalAmount = info.stakedAmount.add(reward);

        // Transfer staked amount and reward to the user
        _mint(address(this), reward); // Minting only the reward
        transfer(msg.sender, totalAmount);

        delete stakingData[msg.sender];

        emit Unstaked(msg.sender, info.stakedAmount, reward);
    }

    function burn(uint256 amount) external {
        require(hasRole(MINTER_ROLE, msg.sender), "Must have minter role to burn");
        _burn(_msgSender(), amount);
    }
    
    function addRole(address account, bytes32 role) external onlyRole(ADMIN_ROLE) {
        grantRole(role, account);
    }
    
    function removeRole(address account, bytes32 role) external onlyRole(ADMIN_ROLE) {
        revokeRole(role, account);
    }

    function setStakingParameters(uint256 newRate, uint256 newDuration) external onlyRole(ADMIN_ROLE) {
        stakingRewardRate = newRate;
        stakingDuration = newDuration;
    }
}
