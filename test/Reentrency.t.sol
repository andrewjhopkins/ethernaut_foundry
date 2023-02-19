pragma solidity ^0.8.17;

import "ds-test/test.sol";
import "../src/Reentrency/ReentrencyHack.sol";
import "../src/Reentrency/ReentrencyFactory.sol";
import "../src/Ethernaut.sol";
import "./utils/vm.sol";

contract ReentrencyTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        // fund the eoa address
        vm.deal(eoaAddress, 5 ether);
    }

    function testReentrencyHack() public {
        ReentrencyFactory reentrencyFactory = new ReentrencyFactory();
        ethernaut.registerLevel(reentrencyFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(reentrencyFactory);
        Reentrency ethernautReentrency = Reentrency(payable(levelAddress));

        // START
        ReentrencyHack reentrencyHack = new ReentrencyHack(address(ethernautReentrency));
        reentrencyHack.hack{value: 0.4 ether}();
        // END

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
