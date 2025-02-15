pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SultanToken} from "src/SultanToken.sol";

contract SultanTokenScript is Script {
    SultanToken public sultanToken;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        sultanToken = new SultanToken("Sultan Jogja Token", "SULT");
        console.log("MemeToken deployed at:", address(sultanToken));

        vm.stopBroadcast();
    }
}

// command to deploy
// forge script script/SultanToken.s.sol:SultanTokenScript --broadcast -vvv --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_KEY>
// forge script script/SultanToken.s.sol:SultanTokenScript --broadcast -vvv --rpc-url $RPC_URL --private-key $PRIVATE_KEY
