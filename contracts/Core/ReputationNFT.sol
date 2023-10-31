// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import "./CowlMarketplaceBase.sol";

contract ReputationNFT is
    ERC721Upgradeable,
    ERC721URIStorageUpgradeable,
    AccessControlUpgradeable
{
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
        override(
            ERC721Upgradeable,
            ERC721URIStorageUpgradeable,
            AccessControlUpgradeable
        )
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

    function showUserReputationLevel(
        address user
    ) external view returns (CowlMarketplaceBase.ReputationLevel) {
        return getUserReputationLevel(user);
    }

    // Function to mint an NFT based on a user's reputation level
    function mintNFT(
        address user,
        string memory tokenURI
    ) external onlyRole(ADMIN_ROLE) {
        // Check the user's reputation level
        CowlMarketplaceBase.ReputationLevel level = getUserReputationLevel(
            user
        );

        // Mint an NFT based on the user's reputation level
        uint256 tokenId = uint256(level);
        _safeMint(user, tokenId);

        // Set the token URI (IPFS CID)
        _setTokenURI(tokenId, tokenURI);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    )
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
