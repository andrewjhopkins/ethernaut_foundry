pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../src/King/KingHack.sol";
import "../src/King/KingFactory.sol";
import "../src/Ethernaut.sol";
import "./utils/vm.sol";

contract KingTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        // fund the eoa address
        vm.deal(eoaAddress, 5 ether);
    }

    function testKingHack() public {
        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);
        King ethernautKing = King(payable(levelAddress));

        // START
        KingHack kingHack = new KingHack();
        kingHack.hack{value: 1 ether}(payable(levelAddress));
        // END

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
