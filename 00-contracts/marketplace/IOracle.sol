// contracts/IOracle.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOracle {
    function requestPrice(string memory asset) external returns (uint256 price);

    function getPrice(uint256 tokenId) external view returns (uint256 price);
}

contract Oracle is IOracle {
    mapping(string => uint256) public prices;
    mapping(uint256 => uint256) public tokenPrices;

    function setPrice(string memory asset, uint256 price) external {
        prices[asset] = price;
    }

    function setTokenPrice(uint256 tokenId, uint256 price) external {
        tokenPrices[tokenId] = price;
    }

    function requestPrice(
        string memory asset
    ) external override returns (uint256 price) {
        // In reality, an oracle request would occur here
        // For simplicity, we just return a stored price
        return prices[asset];
    }

    function getPrice(
        uint256 tokenId
    ) external view override returns (uint256 price) {
        return tokenPrices[tokenId];
    }
}
