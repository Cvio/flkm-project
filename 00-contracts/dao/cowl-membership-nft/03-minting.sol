// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

import "../../../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

import "./01-waning-light-base.sol";
import "./02-metadata.sol";

contract WaningLightMinting is
    Initializable,
    ERC721EnumerableUpgradeable,
    AccessControlUpgradeable,
    PausableUpgradeable
{
    using Strings for uint256;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

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

    function initialize(
        address waningLightBaseAddress,
        address waningLightMetadataAddress,
        uint256 _maxSupply,
        uint256 _mintPrice
    ) external initializer {
        __ERC721Enumerable_init();
        __AccessControl_init();

        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);

        waningLightBase = WaningLightBase(waningLightBaseAddress);
        waningLightMetadata = WaningLightMetadata(waningLightMetadataAddress);

        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        mintedSupply = 0;
    }

    modifier saleIsOpen() {
        require(mintedSupply < maxSupply, "Maximum supply reached");
        _;
    }

    function mintNFT(
        address to
    ) external payable saleIsOpen onlyRole(MINTER_ROLE) {
        require(msg.value >= mintPrice, "Insufficient Ether sent");

        uint256 tokenId = mintedSupply + 1;
        _safeMint(to, tokenId);

        mintedSupply = tokenId;
        emit Minted(msg.sender, tokenId, block.timestamp);

        if (msg.value > mintPrice) {
            uint256 change = msg.value - mintPrice;
            payable(msg.sender).transfer(change);
        }

        // Transfer the mint price to a specific address (e.g., treasury or owner)
        payable(address(this)).transfer(mintPrice);
    }

    function setMintPrice(uint256 newMintPrice) external onlyRole(ADMIN_ROLE) {
        mintPrice = newMintPrice;
    }

    function pauseSale() external onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpauseSale() external onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function _baseURI() internal view override returns (string memory) {
        return waningLightBase.getBaseURI();
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
