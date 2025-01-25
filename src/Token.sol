// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    string public constant TOKEN_NAME = "Fufufafa Official";
    string public constant TOKEN_SYMBOL = "FUFA";
    uint256 public constant INITIAL_SUPPLY = 100_000_000_000 * 10 ** 18; // 100 bilion

    constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}
