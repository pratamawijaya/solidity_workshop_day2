// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    // storage
    uint256 public number; // storage index 0
    uint256 public price; // storage index 1

    // contract owner
    address public owner;

    constructor() {
        // set owner to contract creator
        owner = msg.sender;
    }

    /**
     * @notice Sets a new value for the number.
     *
     * This function allows anyone to set a new value for the `number` variable.
     *
     * @param newNumber The new value that will be set as the `number`.
     */
    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function setPrice(uint256 newPrice) public {
        // check the msg sender is owner
        require(msg.sender == owner, "Only owner can change price");
        price = newPrice;
    }

    function increment() public {
        number++;
    }
}
