// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract RewardDistribution is Initializable, AccessControlUpgradeable {
    IERC20Upgradeable public rewardToken;
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    function initialize(
        IERC20Upgradeable _rewardToken,
        address initialOwner
    ) public initializer {
        rewardToken = _rewardToken;

        _grantRole(OWNER_ROLE, initialOwner);
        _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
    }

    function distributeRewards(
        address[] memory recipients,
        uint256[] memory amounts
    ) external onlyRole(OWNER_ROLE) {
        require(
            recipients.length == amounts.length,
            "Array lengths do not match"
        );

        for (uint256 i = 0; i < recipients.length; i++) {
            rewardToken.transfer(recipients[i], amounts[i]);
        }
    }
}
