// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

// Define the DAO Analytics contract
contract DAOAnalytics is AccessControlUpgradeable {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    // Structure to store DAO activity data
    struct Activity {
        uint256 timestamp;
        string description;
    }

    // Arrays to store different types of activities
    Activity[] public proposals;
    Activity[] public votes;
    Activity[] public transactions;
    Activity[] public membershipChanges;

    // Event to log new activity
    event NewActivity(
        uint256 indexed activityType,
        uint256 timestamp,
        string description
    );

    function initialize() public initializer {
        __AccessControl_init();

        _grantRole(ADMIN_ROLE, msg.sender);
    }

    // Function to add a new activity
    function addActivity(
        uint256 activityType,
        string memory description
    ) external {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");
        uint256 timestamp = block.timestamp;
        Activity memory newActivity = Activity(timestamp, description);

        if (activityType == 0) {
            proposals.push(newActivity);
        } else if (activityType == 1) {
            votes.push(newActivity);
        } else if (activityType == 2) {
            transactions.push(newActivity);
        } else if (activityType == 3) {
            membershipChanges.push(newActivity);
        } else {
            revert("Invalid activity type");
        }

        emit NewActivity(activityType, timestamp, description);
    }

    // Function to get the total number of activities for each type
    function getActivityCounts() external view returns (uint256[] memory) {
        uint256[] memory counts = new uint256[](4);
        counts[0] = proposals.length;
        counts[1] = votes.length;
        counts[2] = transactions.length;
        counts[3] = membershipChanges.length;
        return counts;
    }

    // Function to get the details of a specific activity type
    function getActivityDetails(
        uint256 activityType
    ) external view returns (Activity[] memory) {
        require(
            activityType >= 0 && activityType <= 3,
            "Invalid activity type"
        );

        if (activityType == 0) {
            return proposals;
        } else if (activityType == 1) {
            return votes;
        } else if (activityType == 2) {
            return transactions;
        } else if (activityType == 3) {
            return membershipChanges;
        }
        // Just in case, though the require statement should handle invalid types
        revert("Invalid activity type");
    }
}
