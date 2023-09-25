// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../flkm/01-knowledge-exchange.sol"; // Import the KnowledgeExchangeContract

contract ReputationNFT is ERC721, Ownable {
    KnowledgeExchangeContract public knowledgeContract; // Reference to the KnowledgeExchangeContract

    constructor(
        address _knowledgeContractAddress
    ) ERC721("ReputationNFT", "R-NFT") {
        knowledgeContract = KnowledgeExchangeContract(
            _knowledgeContractAddress
        );
    }

    // Function to check the user's reputation level in the KnowledgeExchangeContract
    function getUserReputationLevel(
        address user
    ) internal view returns (KnowledgeExchangeContract.ReputationLevel) {
        return knowledgeContract.userReputation(user);
    }

    // Function to mint an NFT based on a user's reputation level
    function mintNFT(address user) external {
        // Check the user's reputation level
        KnowledgeExchangeContract.ReputationLevel level = getUserReputationLevel(
                user
            );

        // Mint an NFT based on the user's reputation level
        _mint(user, uint256(level));
    }
}
