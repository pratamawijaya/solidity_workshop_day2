// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {Swap} from "../src/Swap.sol";

contract SwapTest is Test {
    Swap public swap;

    address public budi = makeAddr("budi");

    function setUp() public {
        swap = new Swap();
    }

    function test_swap() public {
        swap.swap(100);
    }
}
