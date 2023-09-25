// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../../../../node_modules/@openzeppelin/contracts/utils/Strings.sol";
import "./01-eternal-light-base.sol"; // Adjust the import path as necessary.

contract MetadataLogicContract is EternalLightBase {
    using Strings for uint256;

    event BaseURIChanged(string newBaseURI);
    event TokenURISet(uint256 tokenId, string uri);

    mapping(uint256 => string) private _tokenURIs;
    string private _baseURIExtended;

    // Only the owner can set the Base URI.
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIExtended = baseURI_;
        emit BaseURIChanged(_baseURIExtended);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseURIExtended;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(
            _exists(tokenId),
            "MetadataLogic: URI query for nonexistent token"
        );

        string memory uri = _tokenURIs[tokenId];
        string memory base = _baseURI();

        if (bytes(uri).length > 0) {
            return
                bytes(base).length > 0
                    ? string(abi.encodePacked(base, uri))
                    : uri;
        }
        return
            bytes(base).length > 0
                ? string(abi.encodePacked(base, tokenId.toString()))
                : "";
    }

    function setTokenURI(uint256 tokenId, string memory uri) public onlyOwner {
        require(
            _exists(tokenId),
            "MetadataLogic: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = uri;
        emit TokenURISet(tokenId, uri);
    }
}
