pragma solidity ^0.8.17;

import "ds-test/test.sol";
import "../src/Force/ForceFactory.sol";
import "../src/Force/ForceHack.sol";
import "../src/Ethernaut.sol";
import "./utils/vm.sol";

contract FalloutTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        // fund the eoa address
        vm.deal(eoaAddress, 5 ether);
    }

    function testForceHack() public {
        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force ethernautForce = Force(payable(levelAddress));

        // START
        ForceHack forceHack = new ForceHack();
        forceHack.hack{value: 1 ether}(levelAddress);
        // END

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}