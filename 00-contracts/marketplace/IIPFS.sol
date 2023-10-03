// contracts/IIPFS.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IIPFS {
    function saveData(string memory _data) external returns (bytes32 hash);

    function getData(bytes32 _hash) external view returns (string memory data);
}

contract IPFS is IIPFS {
    mapping(bytes32 => string) public data;

    function saveData(
        string memory _data
    ) external override returns (bytes32 hash) {
        hash = keccak256(abi.encodePacked(_data));
        data[hash] = _data;
    }

    function getData(
        bytes32 _hash
    ) external view override returns (string memory) {
        return data[_hash];
    }
}
