// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./01-eternal-light-base.sol";
import "../../../../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract EternalLightMetadata is ERC721Enumerable, Ownable {
    using Strings for uint256;

    EternalLightBase public eternalLightBase;
    mapping(uint256 => string) private _tokenDetails;

    constructor(address eternalLightBaseAddress) ERC721("", "") {
        eternalLightBase = EternalLightBase(eternalLightBaseAddress);
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function setTokenDetails(
        uint256 tokenId,
        string memory details
    ) external onlyOwner {
        require(
            eternalLightBase.ownerOf(tokenId) == address(this),
            "Token not owned by this contract"
        );
        _tokenDetails[tokenId] = details;
    }

    function tokenDetails(
        uint256 tokenId
    ) external view returns (string memory) {
        return _tokenDetails[tokenId];
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        string memory uri = eternalLightBase.tokenURI(tokenId);
        string memory details = _tokenDetails[tokenId];
        return string(abi.encodePacked(uri, details));
    }
}
