// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "../../../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Cowl is Ownable {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public isMinter;
    mapping(address => bool) public isStaker;

    ERC721 public reputationNFT; // Add Reputation NFT contract reference here
    uint256 public stakingRewardRate; // Rewards per staked dataset
    uint256 public stakingDuration; // Duration for which staking is locked
    uint256 public stakingNFTIdCounter; // Counter for staking NFTs

    struct StakingInfo {
        uint256 stakedAmount;
        uint256 stakingStartTime;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event MinterAdded(address indexed minter);
    event MinterRemoved(address indexed minter);

    modifier onlyMinter() {
        require(isMinter[msg.sender], "Not a minter");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply.mul(10 ** _decimals);
        balanceOf[msg.sender] = totalSupply;
        isMinter[msg.sender] = true; // The contract creator is the initial minter
        stakingRewardRate = 100; // Adjust the reward rate as needed
        stakingDuration = 30 days; // Adjust the staking duration as needed
        stakingNFTIdCounter = 1;
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(
            balanceOf[msg.sender] >= _amount,
            "Insufficient balance to stake"
        );

        // Lock the staked amount for the staking duration
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
        stakingData[msg.sender] = StakingInfo({
            stakedAmount: _amount,
            stakingStartTime: block.timestamp
        });

        // Mint a staking NFT as a marker
        reputationNFT.mintWithURI(
            msg.sender,
            string(
                abi.encodePacked("Staking NFT #", uint2str(stakingNFTIdCounter))
            ),
            stakingNFTIdCounter
        );
        stakingNFTIdCounter++;

        emit Staked(msg.sender, _amount);
    }

    function unstake() external {
        require(
            stakingData[msg.sender].stakingStartTime.add(stakingDuration) <=
                block.timestamp,
            "Staking duration not met"
        );

        uint256 stakedAmount = stakingData[msg.sender].stakedAmount;

        // Calculate rewards based on staked amount and reward rate
        uint256 rewards = stakedAmount.mul(stakingRewardRate).div(100);

        // Mint COWL tokens as rewards
        mint(msg.sender, rewards);

        // Unlock the staked amount
        stakingData[msg.sender] = StakingInfo(0, 0);

        emit Unstaked(msg.sender, stakedAmount);
    }

    // Helper function to mint COWL tokens
    function mint(address _to, uint256 _value) internal {
        totalSupply = totalSupply.add(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(
            allowance[_from][msg.sender] >= _value,
            "Insufficient allowance"
        );
        require(balanceOf[_from] >= _value, "Insufficient balance");
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function increaseAllowance(
        address _spender,
        uint256 _addedValue
    ) public returns (bool success) {
        allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(
            _addedValue
        );
        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        return true;
    }

    function decreaseAllowance(
        address _spender,
        uint256 _subtractedValue
    ) public returns (bool success) {
        require(
            allowance[msg.sender][_spender] >= _subtractedValue,
            "Decreased allowance below zero"
        );
        allowance[msg.sender][_spender] = allowance[msg.sender][_spender].sub(
            _subtractedValue
        );
        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        return true;
    }

    function mint(
        address _to,
        uint256 _value
    ) public onlyMinter returns (bool success) {
        totalSupply = totalSupply.add(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        totalSupply = totalSupply.sub(_value);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }

    function addMinter(address _minter) public onlyOwner {
        isMinter[_minter] = true;
        emit MinterAdded(_minter);
    }

    function removeMinter(address _minter) public onlyOwner {
        isMinter[_minter] = false;
        emit MinterRemoved(_minter);
    }
}
