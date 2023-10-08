// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../../node_modules/@openzeppelin/contracts/security/Pausable.sol";
import "../../../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./01-waning-light-base.sol";
import "./02-metadata.sol";
import "./03-metadata-logic.sol";

contract WaningLightMinting is ERC721Enumerable, Ownable, Pausable {
    using SafeMath for uint256;

    WaningLightBase public waningLightBase;
    WaningLightMetadata public waningLightMetadata;

    uint256 public maxSupply;
    uint256 public mintPrice;
    uint256 public mintedSupply;

    event Minted(
        address indexed minter,
        uint256 indexed tokenId,
        uint256 timestamp
    );

    constructor(
        address waningLightBaseAddress,
        address waningLightMetadataAddress,
        uint256 _maxSupply,
        uint256 _mintPrice
    ) ERC721("WaningLight", "EL") {
        waningLightBase = WaningLightBase(waningLightBaseAddress);
        waningLightMetadata = WaningLightMetadata(waningLightMetadataAddress);
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        mintedSupply = 0;
    }

    modifier saleIsOpen() {
        require(_saleIsOpen(), "Sale is not open");
        _;
    }

    function mintNFT(address to) external payable saleIsOpen whenNotPaused {
        require(msg.value >= mintPrice, "Insufficient Ether sent");
        require(mintedSupply < maxSupply, "Maximum supply reached");

        uint256 tokenId = mintedSupply.add(1);
        _safeMint(to, tokenId);

        mintedSupply = tokenId;
        emit Minted(msg.sender, tokenId, block.timestamp);

        if (msg.value > mintPrice) {
            uint256 change = msg.value.sub(mintPrice);
            payable(msg.sender).transfer(change);
        }

        // Transfers the mint price to the owner
        payable(owner()).transfer(mintPrice);
    }

    function setMintPrice(uint256 newMintPrice) external onlyOwner {
        mintPrice = newMintPrice;
    }

    function pauseSale() external onlyOwner {
        _pause();
    }

    function unpauseSale() external onlyOwner {
        _unpause();
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return waningLightMetadata.baseURI(); // Accessing the public function from WaningLightMetadata
    }

    function _saleIsOpen() internal view returns (bool) {
        return mintedSupply < maxSupply;
    }
}
