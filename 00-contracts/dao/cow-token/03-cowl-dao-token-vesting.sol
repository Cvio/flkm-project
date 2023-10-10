// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../../../node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract VestingContract is Initializable, AccessControlUpgradeable {
    using SafeMathUpgradeable for uint256;

    IERC20Upgradeable public token;
    mapping(address => uint256) public vestedAmount;
    mapping(address => uint256) public claimedAmount;
    uint256 public vestingDuration;
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    function initialize(
        IERC20Upgradeable _token,
        uint256 _vestingDuration,
        address initialOwner
    ) public initializer {
        token = _token;
        vestingDuration = _vestingDuration;

        _grantRole(OWNER_ROLE, initialOwner);
        _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
    }

    function addVesting(
        address beneficiary,
        uint256 amount
    ) external onlyRole(OWNER_ROLE) {
        vestedAmount[beneficiary] = vestedAmount[beneficiary].add(amount);
    }

    function claim() external {
        require(
            block.timestamp >= vestingDuration,
            "Vesting period is not over"
        );
        uint256 pending = vestedAmount[msg.sender].sub(
            claimedAmount[msg.sender]
        );
        require(pending > 0, "Nothing to claim");

        claimedAmount[msg.sender] = claimedAmount[msg.sender].add(pending);
        token.transfer(msg.sender, pending);
    }
}
