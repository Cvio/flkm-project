// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

import "../../../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../../node_modules/@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract RewardDistribution is Ownable {
    IERC20 public rewardToken;

    constructor(IERC20 _rewardToken) {
        rewardToken = _rewardToken;
    }

    function distributeRewards(
        address[] memory recipients,
        uint256[] memory amounts
    ) external onlyOwner {
        require(
            recipients.length == amounts.length,
            "Array lengths do not match"
        );

        for (uint256 i = 0; i < recipients.length; i++) {
            rewardToken.transfer(recipients[i], amounts[i]);
        }
    }
}
