pragma solidity ^0.8.17;

import "ds-test/test.sol";
import "../src/Elevator/ElevatorFactory.sol";
import "../src/Elevator/ElevatorHack.sol";
import "../src/Ethernaut.sol";
import "./utils/vm.sol";

contract ElevatorTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testElevatorHack() public {
        ElevatorFactory elevatorFactory = new ElevatorFactory();
        ethernaut.registerLevel(elevatorFactory);

        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(elevatorFactory);
        Elevator ethernautElevator = Elevator(address(levelAddress));

        // START
        ElevatorHack elevatorHack = new ElevatorHack();
        elevatorHack.hack(address(ethernautElevator));

        require(ethernautElevator.top() == true, "Elevator not at top");
        // END

        bool levelPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelPassed);
    }
}