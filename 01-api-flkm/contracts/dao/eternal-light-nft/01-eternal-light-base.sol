// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "../../../../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract EternalLightBase is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    constructor() ERC721("", "") {}

    function mint(address to) external onlyOwner {
        _safeMint(to, _tokenIdCounter);
        _tokenIdCounter++;
    }

    function burn(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }

    // Function to allow owner to mint with a specific URI
    function mintWithURI(
        address to,
        string memory tokenURI
    ) external onlyOwner {
        _safeMint(to, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, tokenURI);
        _tokenIdCounter++;
    }
}
