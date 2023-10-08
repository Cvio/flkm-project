// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

/**
 * @title ExtendedERC721Upgradeable
 * @dev Extension of ERC721Upgradeable to include the _exists() function.
 */
contract ExtendedERC721Upgradeable is ERC721Upgradeable {
    /**
     * @dev Checks if a token with the given tokenId has been minted.
     * @param tokenId The ID of the token to check.
     * @return True if the token exists, false otherwise.
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    uint256[50] private __gap; // Reserved storage space for future upgrades
}
