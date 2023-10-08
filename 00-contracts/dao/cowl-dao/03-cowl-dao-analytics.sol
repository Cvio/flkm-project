// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Import necessary libraries and interfaces
// import "@openzeppelin/contracts/access/Ownable.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

// Define the DAO Analytics contract
contract DAOAnalytics is Ownable {
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

    // Function to add a new activity
    function addActivity(
        uint256 activityType,
        string memory description
    ) external onlyOwner {
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
    }
}
