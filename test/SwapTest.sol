// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Swap} from "../src/Swap.sol";

contract SwapTest is Test {
    // usdc has 6 decimals
    // usdc contract address
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    Swap public swap;

    address public budi = makeAddr("budi");

    function setUp() public {
        // its contain alchemy RPC , and selected block number
        // selected block number for cached data in local, so it will be more faster to test
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/XsUUNLzsdh6pyu2GHdZY05prytk8xyaA", 21699727);
        swap = new Swap();
    }

    function test_swap() public {
        // memberikan 1000 usdc ke contract address
        // penulisan 1000e6 karena usdc menggunakan 6 decimals
        deal(USDC, address(this), 1000e6);
        IERC20(USDC).approve(address(swap), 1000e6);
        swap.swap(1000e6, 100); // swap usdc to wbtc
        // check wbtc balance
        uint256 wbtcBalance = IERC20(WBTC).balanceOf(address(this));
        console.log("WBTC Balance", wbtcBalance);
    }
}
