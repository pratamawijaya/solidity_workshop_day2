// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {Token} from "../src/Token.sol";

contract MyTokenTest is Test {
    Token public token;

    function setUp() public {
        token = new Token();
    }

    function test_mint() public {
        token.mint(address(this), 1000);
        assertEq(token.balanceOf(address(this)), 1000, "balance should 1000");
    }

    function test_mint_exceed_total_supply() public {
        assertEq(token.MAX_SUPPLY(), 10_000);
        vm.expectRevert("Max Supply exceeded");
        token.mint(address(this), 100_0000);
    }
}
