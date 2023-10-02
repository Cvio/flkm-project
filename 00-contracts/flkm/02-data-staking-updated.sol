// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";

// Incorporating IPFS for decentralized storage
import "./IIPFS.sol";

// Incorporating Interface for Oracles (Replace with the actual interface of the Oracle you choose)
import "./IOracle.sol";

// Interface for the staking contract
interface IDataStakingContract {
    function stakeData(uint256 tokenId, address owner) external;
    function unstakeData(uint256 tokenId, address owner) external;
}

contract DatasetNFTContract is 
    Initializable, 
    ERC721BurnableUpgradeable, 
    ERC721EnumerableUpgradeable, 
    OwnableUpgradeable, 
    AccessControlEnumerableUpgradeable 
{
    bytes32 public constant STAKER_ROLE = keccak256("STAKER_ROLE");
    uint256 public totalMinted;
    address public dataStakingContractAddress;
    IIPFS public ipfs;
    IOracle public oracle;

    event DatasetMinted(address indexed owner, uint256 tokenId, string uri);
    event MetadataSet(uint256 indexed tokenId);
    event DatasetStaked(uint256 tokenId, address indexed staker);
    event DatasetUnstaked(uint256 tokenId, address indexed staker);

    struct DatasetMetadata {
        string description;
        string dataType;
        string source;
        uint256 royaltyPercentage;
    }
    
    mapping(uint256 => DatasetMetadata) public datasetMetadata;
    
    function initialize(
        address _dataStakingContractAddress,
        address _ipfsAddress,
        address _oracleAddress
    ) initializer public {
        __ERC721_init("DatasetToken", "DST");
        __Ownable_init();
        __AccessControl_init();
        __ERC721Enumerable_init();

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(STAKER_ROLE, _dataStakingContractAddress);

        dataStakingContractAddress = _dataStakingContractAddress;
        ipfs = IIPFS(_ipfsAddress);
        oracle = IOracle(_oracleAddress);
    }

    function mintDatasetNFT(address to, string memory uri) external onlyOwner returns (uint256) {
        totalMinted++;
        uint256 newTokenId = totalMinted;

        _mint(to, newTokenId);
        _setTokenURI(newTokenId, uri);

        emit DatasetMinted(to, newTokenId, uri);
        return newTokenId;
    }

    function setMetadata(uint256 tokenId, string memory description, string memory dataType, string memory source, uint256 royaltyPercentage) external {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner");
        DatasetMetadata memory metadata = DatasetMetadata(description, dataType, source, royaltyPercentage);
        datasetMetadata[tokenId] = metadata;
        emit MetadataSet(tokenId);
    }

    function transferDatasetOwnership(uint256 tokenId, address newOwner) external {
        require(ownerOf(tokenId) == msg.sender, "Caller is not the owner");
        _transfer(msg.sender, newOwner, tokenId);
    }

    function stakeDatasetNFT(uint256 tokenId) external onlyRole(STAKER_ROLE) {
        require(_exists(tokenId), "Token does not exist");
        IDataStakingContract(dataStakingContractAddress).stakeData(tokenId, ownerOf(tokenId));
        emit DatasetStaked(tokenId, msg.sender);
    }

    function unstakeDatasetNFT(uint256 tokenId) external onlyRole(STAKER_ROLE) {
        require(_exists(tokenId), "Token does not exist");
        IDataStakingContract(dataStakingContractAddress).unstakeData(tokenId, ownerOf(tokenId));
        emit DatasetUnstaked(tokenId, msg.sender);
    }

    function setDataStakingContractAddress(address _dataStakingContractAddress) external onlyOwner {
        dataStakingContractAddress = _dataStakingContractAddress;
        _setupRole(STAKER_ROLE, _dataStakingContractAddress);
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return ipfs.baseURI();
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721EnumerableUpgradeable, ERC721Upgradeable) {
        super._beforeTokenTransfer(from, to, tokenId);
        
        // Implementing Royalty Logic (can be enhanced with ERC2981)
        if(from != address(0) && to != address(0)) { // not minting and not burning
            uint256 royalty = oracle.getPrice(tokenId) * datasetMetadata[tokenId].royaltyPercentage / 100;
            payable(from).transfer(royalty);
        }
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerableUpgradeable, ERC721EnumerableUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
