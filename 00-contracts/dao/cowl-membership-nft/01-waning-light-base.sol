// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";

import "../../../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts/utils/Strings.sol";

contract WaningLightBase is
    Initializable,
    ERC721URIStorageUpgradeable,
    AccessControlUpgradeable
{
    using Strings for uint256;
    uint256 private _tokenIdCounter;

    // Define roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Event for metadata change
    event MetadataChanged(uint256 tokenId, string newURI);

    // Mapping for roles and contributions
    mapping(address => string) public roles;
    mapping(address => string) public contributions;
    mapping(uint256 => string) private _tokenURIs;
    string private _baseURIExtended;

    function initialize() public initializer {
        __ERC721_init("WaningLight", "WL");
        __AccessControl_init();

        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    // Only members with minter role can mint
    function mint(address to) external onlyRole(MINTER_ROLE) {
        _safeMint(to, _tokenIdCounter);
        _tokenIdCounter++;
    }

    function burn(uint256 tokenId) external onlyRole(ADMIN_ROLE) {
        _burn(tokenId);
    }

    function mintWithTokenURI(
        address to,
        string memory _tokenURI
    ) external onlyRole(MINTER_ROLE) {
        _safeMint(to, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, _tokenURI);
        _tokenIdCounter++;

        emit MetadataChanged(_tokenIdCounter, _tokenURI);
    }

    function setRole(
        address member,
        string memory role
    ) external onlyRole(ADMIN_ROLE) {
        roles[member] = role;
    }

    function setContribution(
        address member,
        string memory contribution
    ) external onlyRole(ADMIN_ROLE) {
        contributions[member] = contribution;
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721URIStorageUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseURIExtended;
    }

    function setBaseURI(string memory baseURI_) external onlyRole(ADMIN_ROLE) {
        _baseURIExtended = baseURI_;
    }

    function getBaseURI() external view returns (string memory) {
        return _baseURI();
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

    function setTokenURI(
        uint256 tokenId,
        string memory uri
    ) external onlyRole(ADMIN_ROLE) {
        require(
            _exists(tokenId),
            "MetadataLogic: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = uri;
    }

    // use in Remix but not in Truffle?

    // function _exists(uint256 tokenId) external view returns (bool) {
    //     return _ownerOf(tokenId) != address(0);
    // }
}
