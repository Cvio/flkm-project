// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

import "../../../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../../node_modules/@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "../../../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract VestingContract is Ownable {
    using SafeMath for uint256;

    IERC20 public token;
    mapping(address => uint256) public vestedAmount;
    mapping(address => uint256) public claimedAmount;
    uint256 public vestingDuration;

    constructor(IERC20 _token, uint256 _vestingDuration) {
        token = _token;
        vestingDuration = _vestingDuration;
    }

    function addVesting(
        address beneficiary,
        uint256 amount
    ) external onlyOwner {
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
