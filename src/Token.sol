// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    string public constant TOKEN_NAME = "Fufufafa Official";
    string public constant TOKEN_SYMBOL = "FUFA";
    uint256 public constant MAX_SUPPLY = 10_000;

    address public owner;

    constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL) {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        // mint must be owner
        require(msg.sender == owner, "Only Owner can mint");
        // check the total supply
        require(totalSupply() + amount <= MAX_SUPPLY, "Max Supply exceeded");
        _mint(to, amount);
    }
}
