pragma solidity ^0.8.13;

import {ERC20Upgradeable} from "openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import {ReentrancyGuardUpgradeable} from
    "openzeppelin-contracts-upgradeable/contracts/utils/ReentrancyGuardUpgradeable.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract VaultUpgradable is Initializable, ReentrancyGuardUpgradeable, ERC20Upgradeable {
    // list event
    event Deposit(address user, uint256 amount);

    // list error
    error AmountCannotBeZero();

    address public assetToken;
    address public owner;

    constructor() {
        _disableInitializers();
    }

    function initialize(address _assetToken) external initializer {
        __ERC20_init("Deposito Vault", "DEPO");
        __ReentrancyGuard_init();

        assetToken = _assetToken;
        owner = msg.sender;

        // prevent inflation
        IERC20(assetToken).transferFrom(msg.sender, address(this), 1000);
        _mint(address(this), 1000);
    }

    function deposit(uint256 amount) public {
        // check the msg.sender amount
        if (amount == 0) revert AmountCannotBeZero();

        // shares yang akan diperoleh = deposit amount / total asset * total shares
        uint256 shares = 0;
        uint256 totalAssets = IERC20(assetToken).balanceOf(address(this));

        if (totalSupply() == 0) {
            shares = amount;
        } else {
            // di solidity jika ada kali dan bagi maka kali harus didahulukkan
            shares = (amount * totalSupply()) / totalAssets;
        }
        // check calculate shares is success
        require(shares > 0, "Failed to calculate shares");

        _mint(msg.sender, shares);

        IERC20(assetToken).transferFrom(msg.sender, address(this), amount);

        // sent event deposit
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 shares) public {
        // check the msg.sender shares balance
        require(balanceOf(msg.sender) >= shares, "Insufficient shares");

        uint256 totalAssets = IERC20(assetToken).balanceOf(address(this));
        uint256 amount = (shares * totalAssets) / totalSupply();

        _burn(msg.sender, shares);

        IERC20(assetToken).transfer(msg.sender, amount);
    }

    function distributeYield(uint256 amount) public {
        // only owner can call this function
        require(msg.sender == owner, "Only the owner can distribute yield");
        // check if there is enough asset token in the vault
        require(IERC20(assetToken).balanceOf(address(this)) >= amount, "Insufficient balance");

        IERC20(assetToken).transferFrom(msg.sender, address(this), amount);
    }
}
