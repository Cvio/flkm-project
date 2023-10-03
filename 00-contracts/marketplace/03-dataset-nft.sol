// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract DatasetNFTContract is ERC721, AccessControl {
    uint256 public totalMinted;
    string public baseTokenURI;

    struct DatasetMetadata {
        string description;
        string dataType;
        string source;
        uint256 royaltyPercentage;
    }

    mapping(uint256 => DatasetMetadata) public datasetMetadata;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event MintedDatasetNFT(uint256 tokenId, address to);
    event MetadataUpdated(uint256 tokenId);
    event BaseUriUpdated(string newUri);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseTokenURI
    ) ERC721(_name, _symbol) {
        baseTokenURI = _baseTokenURI;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setBaseTokenURI(
        string memory _newBaseTokenURI
    ) external onlyOwner {
        baseTokenURI = _newBaseTokenURI;
    }

    function mintDatasetNFT(
        address to,
        string memory description,
        string memory dataType,
        string memory source,
        uint256 royaltyPercentage
    ) external onlyOwner returns (uint256) {
        totalMinted++;
        uint256 newTokenId = totalMinted;

        _mint(to, newTokenId);

        DatasetMetadata memory metadata = DatasetMetadata(
            description,
            dataType,
            source,
            royaltyPercentage
        );
        datasetMetadata[newTokenId] = metadata;

        return newTokenId;
    }

    function setMetadata(
        uint256 tokenId,
        string memory description,
        string memory dataType,
        string memory source,
        uint256 royaltyPercentage
    ) external onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        datasetMetadata[tokenId] = DatasetMetadata(
            description,
            dataType,
            source,
            royaltyPercentage
        );
    }

    function transferDatasetOwnership(
        uint256 tokenId,
        address newOwner
    ) external {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner");
        safeTransferFrom(msg.sender, newOwner, tokenId);
    }

    // For royalties (using EIP-2981)
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
        return (owner(), (datasetMetadata[_tokenId].royaltyPercentage * _salePrice) / 100);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
}
