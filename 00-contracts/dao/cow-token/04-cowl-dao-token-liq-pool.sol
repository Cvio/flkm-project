// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "../../../node_modules/@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract LiquidityPool is ERC20Upgradeable, ReentrancyGuardUpgradeable {
    IERC20Upgradeable public tokenA;
    IERC20Upgradeable public tokenB;

    event LiquidityAdded(
        address indexed provider,
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );
    event LiquidityRemoved(
        address indexed provider,
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );
    event Swapped(address indexed swapper, uint256 amountIn, uint256 amountOut);

    function initialize(address _tokenA, address _tokenB) public initializer {
        __ERC20_init("LiquidityToken", "LPT");
        __ReentrancyGuard_init();
        tokenA = IERC20Upgradeable(_tokenA);
        tokenB = IERC20Upgradeable(_tokenB);
    }

    function addLiquidity(
        uint256 amountA,
        uint256 amountB
    ) external nonReentrant {
        require(amountA > 0 && amountB > 0, "Invalid amounts");

        uint256 _totalA = tokenA.balanceOf(address(this));
        uint256 _totalB = tokenB.balanceOf(address(this));

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        uint256 liquidityMinted;
        if (totalSupply() == 0) {
            liquidityMinted = amountA + amountB;
        } else {
            uint256 liquidityA = (totalSupply() * amountA) / _totalA;
            uint256 liquidityB = (totalSupply() * amountB) / _totalB;
            liquidityMinted = liquidityA < liquidityB ? liquidityA : liquidityB;
        }

        _mint(msg.sender, liquidityMinted); // Mint LP tokens to the liquidity provider
        emit LiquidityAdded(msg.sender, amountA, amountB, liquidityMinted);
    }

    function removeLiquidity(uint256 liquidityAmount) external nonReentrant {
        require(
            liquidityAmount > 0 && balanceOf(msg.sender) >= liquidityAmount,
            "Invalid liquidity amount"
        );

        uint256 amountA = (tokenA.balanceOf(address(this)) * liquidityAmount) /
            totalSupply();
        uint256 amountB = (tokenB.balanceOf(address(this)) * liquidityAmount) /
            totalSupply();

        _burn(msg.sender, liquidityAmount); // Burn LP tokens from the liquidity provider
        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB, liquidityAmount);
    }

    function swap(uint256 amountIn, bool isTokenAtoB) external nonReentrant {
        require(amountIn > 0, "Invalid input amount");

        uint256 amountOut;
        if (isTokenAtoB) {
            amountOut = getAmountOut(
                amountIn,
                tokenA.balanceOf(address(this)),
                tokenB.balanceOf(address(this))
            );
            tokenA.transferFrom(msg.sender, address(this), amountIn);
            tokenB.transfer(msg.sender, amountOut);
        } else {
            amountOut = getAmountOut(
                amountIn,
                tokenB.balanceOf(address(this)),
                tokenA.balanceOf(address(this))
            );
            tokenB.transferFrom(msg.sender, address(this), amountIn);
            tokenA.transfer(msg.sender, amountOut);
        }

        emit Swapped(msg.sender, amountIn, amountOut);
    }

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) public pure returns (uint256) {
        return (amountIn * reserveOut) / (reserveIn + amountIn);
    }
}
