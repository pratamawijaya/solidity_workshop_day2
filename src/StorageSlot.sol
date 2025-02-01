pragma solidity ^0.8.13;

// forge inspect StorageSlot storage-layout --pretty
contract StorageSlot {
    uint256 public price;
    address public owner;
    uint96 public decimals;
    uint256 public totalSupply;

    /*
    *
    ╭-------------+---------+------+--------+-------+---------------------------------╮
    | Name        | Type    | Slot | Offset | Bytes | Contract                        |
    +=================================================================================+
    | price       | uint256 | 0    | 0      | 32    | src/StorageSlot.sol:StorageSlot |
    |-------------+---------+------+--------+-------+---------------------------------|
    | owner       | address | 1    | 0      | 20    | src/StorageSlot.sol:StorageSlot |
    |-------------+---------+------+--------+-------+---------------------------------|
    | decimals    | uint96  | 1    | 20     | 12    | src/StorageSlot.sol:StorageSlot |
    |-------------+---------+------+--------+-------+---------------------------------|
    | totalSupply | uint256 | 2    | 0      | 32    | src/StorageSlot.sol:StorageSlot |
    ╰-------------+---------+------+--------+-------+---------------------------------╯

    * pada contoh diatas decimals masih menggunakan slot 1 karena secara bytes masih mencukupi yaitu 96/8 = 12bytes
    * yang mana sisa byte sebelumnya pada storage owner adalah 20, 20+12 = 32Bytes
    */
}
