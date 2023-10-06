// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract DatasetNFTContract is
    Initializable,
    ERC721Upgradeable,
    AccessControlUpgradeable
{
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

    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _baseTokenURI
    ) public initializer {
        __ERC721_init(_name, _symbol);
        __AccessControl_init();

        baseTokenURI = _baseTokenURI;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC721Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setBaseTokenURI(
        string memory _newBaseTokenURI
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        baseTokenURI = _newBaseTokenURI;
    }

    function mintDatasetNFT(
        address to,
        string memory description,
        string memory dataType,
        string memory source,
        uint256 royaltyPercentage,
        string memory ipfsHash
    ) external onlyRole(DEFAULT_ADMIN_ROLE) returns (uint256) {
        totalMinted++;
        uint256 newTokenId = totalMinted;
    
        _mint(to, newTokenId);
    
        DatasetMetadata memory metadata = DatasetMetadata(
            description,
            dataType,
            source,
            royaltyPercentage,
            ipfsHash  // Add IPFS hash here
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
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
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
    function royaltyInfo(
        uint256 _tokenId,
        uint256 _salePrice
    ) external view returns (address receiver, uint256 royaltyAmount) {
        return (
            ownerOf(_tokenId),
            (datasetMetadata[_tokenId].royaltyPercentage * _salePrice) / 100
        );
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }
}
