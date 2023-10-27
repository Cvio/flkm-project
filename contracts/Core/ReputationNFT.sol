// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "./CowlMarketplaceBase.sol";

contract ReputationNFT is ERC721Upgradeable, AccessControlUpgradeable {
    CowlMarketplaceBase public marketplaceContract; // Reference to the FederatedMarketplace

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    function initialize(
        address payable _marketplaceContractAddress
    ) public initializer {
        __ERC721_init("ReputationNFT", "R-NFT");
        __AccessControl_init();

        _grantRole(ADMIN_ROLE, msg.sender);

        marketplaceContract = CowlMarketplaceBase(_marketplaceContractAddress);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // Function to check the user's reputation level in the FederatedMarketplace
    function getUserReputationLevel(
        address user
    ) internal view returns (CowlMarketplaceBase.ReputationLevel) {
        return marketplaceContract.userReputation(user);
    }

    // Function to mint an NFT based on a user's reputation level
    function mintNFT(address user) external onlyRole(ADMIN_ROLE) {
        // Check the user's reputation level
        CowlMarketplaceBase.ReputationLevel level = getUserReputationLevel(
            user
        );

        // Mint an NFT based on the user's reputation level
        _safeMint(user, uint256(level));
    }
}
