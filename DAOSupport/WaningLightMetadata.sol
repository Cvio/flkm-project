// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../DAOCore/WaningLightBase.sol";

contract WaningLightMetadata is
    ERC721EnumerableUpgradeable,
    AccessControlUpgradeable
{
    using Strings for uint256;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    WaningLightBase public waningLightBase;
    mapping(uint256 => string) private _tokenDetails;

    function initialize(address waningLightBaseAddress) external initializer {
        __ERC721Enumerable_init();
        __AccessControl_init();

        _grantRole(ADMIN_ROLE, msg.sender);

        waningLightBase = WaningLightBase(waningLightBaseAddress);
    }

    function setTokenDetails(
        uint256 tokenId,
        string memory details
    ) external onlyRole(ADMIN_ROLE) {
        require(
            waningLightBase.ownerOf(tokenId) == address(this),
            "Token not owned by this contract"
        );
        _tokenDetails[tokenId] = details;
    }

    function tokenDetails(
        uint256 tokenId
    ) external view returns (string memory) {
        return _tokenDetails[tokenId];
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC721EnumerableUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
