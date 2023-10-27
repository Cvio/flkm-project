// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./CowlMarketplace.sol";

contract ReputationNFT is ERC721, Ownable {
    CowlMarketplaceBase public knowledgeContract; // Reference to the FederatedMarketplace

    constructor(
        address payable _knowledgeContractAddress
    ) ERC721("ReputationNFT", "R-NFT") {
        knowledgeContract = CowlMarketplace(_knowledgeContractAddress);
    }

    // Function to check the user's reputation level in the FederatedMarketplace
    function getUserReputationLevel(
        address user
    ) internal view returns (CowlMarketplaceBase.ReputationLevel) {
        return knowledgeContract.userReputation(user);
    }

    // Function to mint an NFT based on a user's reputation level
    function mintNFT(address user) external {
        // Check the user's reputation level
        CowlMarketplaceBase.ReputationLevel level = getUserReputationLevel(
            user
        );

        // Mint an NFT based on the user's reputation level
        _mint(user, uint256(level));
    }
}
