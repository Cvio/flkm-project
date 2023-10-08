// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

import "../../node_modules/@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "../../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../../node_modules/@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract DataAnalysisContract is
    Initializable,
    AccessControlUpgradeable,
    ChainlinkClient
{
    bytes32 public constant ANALYST_ROLE = keccak256("ANALYST_ROLE");

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    address private datasetNFTContract;

    mapping(bytes32 => string) public analysisResults;
    mapping(bytes32 => string) public datasetIpfsHashes;

    event AnalysisRequested(
        bytes32 requestId,
        string datasetId,
        string datasetUrl
    );
    event AnalysisFulfilled(bytes32 requestId, string result);
    event IpfsHashStored(bytes32 datasetId, string ipfsHash);

    function initialize(
        address _oracle,
        string memory _jobId,
        uint256 _fee,
        address _datasetNFTContract
    ) public initializer {
        __AccessControl_init();
        setPublicChainlinkToken();
        oracle = _oracle;
        jobId = stringToBytes32(_jobId);
        fee = _fee;
        datasetNFTContract = _datasetNFTContract;

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); // Set Deployer as admin
    }

    function requestAnalysis(
        string memory datasetId,
        string memory datasetUrl
    ) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        request.add("datasetId", datasetId);
        request.add("datasetUrl", datasetUrl);

        requestId = sendChainlinkRequestTo(oracle, request, fee);

        emit AnalysisRequested(requestId, datasetId, datasetUrl);
    }

    function fulfill(
        bytes32 _requestId,
        string memory _result
    ) public recordChainlinkFulfillment(_requestId) onlyRole(ANALYST_ROLE) {
        analysisResults[_requestId] = _result;
        emit AnalysisFulfilled(_requestId, _result);
    }

    function storeIpfsHash(
        bytes32 datasetId,
        string memory ipfsHash
    ) public onlyRole(ANALYST_ROLE) {
        require(bytes(ipfsHash).length > 0, "Invalid IPFS Hash");
        datasetIpfsHashes[datasetId] = ipfsHash;
        emit IpfsHashStored(datasetId, ipfsHash);
    }

    function getIpfsHash(
        bytes32 datasetId
    ) public view returns (string memory) {
        require(
            bytes(datasetIpfsHashes[datasetId]).length > 0,
            "IPFS Hash not found"
        );
        return datasetIpfsHashes[datasetId];
    }

    function stringToBytes32(
        string memory source
    ) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        require(tempEmptyStringTest.length > 0, "Empty string provided");

        assembly {
            result := mload(add(source, 32))
        }
    }
}
