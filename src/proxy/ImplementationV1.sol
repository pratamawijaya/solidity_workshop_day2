// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * pada smart contract terdapat istilah delegateCall yang mana penjelasannya sebagai berikut
 *
 * delegatecall is a low-level function that allows one contract to execute the code of another contract
 * while keeping its context (i.e., msg.sender, msg.value, and storage) intact. This means that when you make a delegatecall from Contract A to Contract B, Contract B's functions will be executed as if they were part of Contract A.
 */
contract ImplementationV1 is Initializable {
    uint256 public price;

    constructor() {
        _disableInitializers();
    }

    function initialize(address _assetToken) public initializer {}
}
