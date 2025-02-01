// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// interface for aave
interface ILendingPool {
    function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
    function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf)
        external;
}

// interface for uniswap
interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

// interface for balancer
// https://github.com/balancer/docs-developers/blob/main/resources/flash-loans.md
interface IFlashloan {
    function flashLoan(address recipient, address[] memory tokens, uint256[] memory amounts, bytes calldata userData)
        external;
}

contract FlashLoan {
    // router address (uniswap)
    address public router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    // pool address aave
    address public lendingPool = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    // vault balancer address
    address public balancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    // kita mau supply weth untuk berhutang usdc
    address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function loopingSupply() public {
        // disini kita punya 1WETH
        uint256 amount = 1e18;

        // dari 1weth kita trasfer ke smartcontract
        IERC20(weth).transferFrom(msg.sender, address(this), amount);

        // menyiapkan parameter flashloan
        address[] memory tokens = new address[](1);
        tokens[0] = weth;
        uint256[] memory amounts = new uint256[](1);
        // meminjam WETH sebanyak 1 WETH
        amounts[0] = 1e18;

        // execute interface flashLoan
        IFlashloan(balancerVault).flashLoan(address(this), tokens, amounts, "");
    }

    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external {
        require(msg.sender == balancerVault, "Not Balancer vault");

        // #### logic flashloan ####
        // flashloan pinjam 1WETH
        // supply WETH ke AAVE = 2 WETH
        // borrow USDC  ke WETH = 3300 USDC swap ke WETH untuk mendapatkan 1 WETH
        // membayar flashLoan 1 WETH

        // supply 2 weth ke aave
        IERC20(weth).approve(lendingPool, 2e18);
        ILendingPool(lendingPool).supply(weth, 2e18, address(this), 0);

        // pnijam 3300 usdc ke lending pool
        ILendingPool(lendingPool).borrow(usdc, 3300e6, 2, 0, address(this));
        IERC20(usdc).approve(router, 3300e6);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: usdc,
            tokenOut: weth,
            fee: 500,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: 3300e6,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        uint256 amountOut = ISwapRouter(router).exactInputSingle(params);

        IERC20(weth).transfer(balancerVault, 1e18);

        // sisanya jadikan supply
        uint256 dust = IERC20(weth).balanceOf(address(this));
        IERC20(weth).approve(lendingPool, dust);
        ILendingPool(lendingPool).supply(weth, dust, address(this), 0);
    }
}
