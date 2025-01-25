pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// untuk interaksi dengan router uniswap kita butuh interface dibawah ini
// doc https://docs.uniswap.org/contracts/v3/guides/swaps/single-swaps#a-complete-single-swap-contract
// cara ini adalah cara manual tanpa install library
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

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract Swap {
    address public constant uniswap_router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public constant wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address public constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function swap(uint256 amountIn, uint256 minAmountOut) public {
        // jika ada proses swap wajib ada minAmountOut, terkait keamanan dan audit
        // case slipage, jika alice mau swap 1000USDC dan alice menentukan minimal WBTC yang didapatkan misal 0.09
        // jika ternyata yang didapatkan dibawah 0.09 maka transaction akan gagal

        // contoh slipage case 10%
        // jika budi membeli 1btc dengan 100k
        // dengan slipage 10% maka akan mendapatkan 0.9

        // case terkait issue slipage contohnya adalah sandwich attack

        // transfer dari user ke contract swap
        IERC20(usdc).transferFrom(msg.sender, address(this), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: usdc,
            tokenOut: wbtc,
            fee: 3000, // 0.3
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: minAmountOut, // slipage
            sqrtPriceLimitX96: 0
        });

        IERC20(usdc).approve(uniswap_router, amountIn); // approve kepada Uniswap
        ISwapRouter(uniswap_router).exactInputSingle(params);
    }
}
