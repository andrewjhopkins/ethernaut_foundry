pragma solidity ^0.8.17;

import "ds-test/test.sol";
import "../src/Telephone/TelephoneFactory.sol";
import "../src/Telephone/TelephoneHack.sol";
import "../src/Ethernaut.sol";
import "./utils/vm.sol";

contract TelephoneTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testTelephoneHack() public {
        return;

        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);

        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone ethernautTelephone = Telephone(payable(levelAddress));

        // START
        TelephoneHack telephoneHack = new TelephoneHack(address(ethernautTelephone));
        telephoneHack.hack();
        // END

        bool levelPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelPassed);
    }
}
