// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    address public contractOwner = 0x636C16881D405cdE477f56546825c88862be5189;
    address public budi = makeAddr("xxbudixx");

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function testFuzz_SetPrice(uint256 x) public {
        counter.setPrice(x);
        assertEq(counter.price(), x);
        // vm.prank(budi);
        // counter.setPrice(200);
        // vm.expectRevert("only owner can set price");
    }
}
