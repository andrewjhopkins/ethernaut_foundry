// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import '../Level.sol';
import './Reentrency.sol';

contract ReentrencyFactory is Level {

  uint public insertCoin = 1 ether;

  function createInstance(address _player) override public payable returns (address) {
    _player;
    require(msg.value >= insertCoin);
    Reentrency instance = new Reentrency();
    require(address(this).balance >= insertCoin);
    payable(address(instance)).transfer(insertCoin);
    return address(instance);
  }

  function validateInstance(address payable _instance, address _player) override public returns (bool) {
    _player;
    Reentrency instance = Reentrency(_instance);
    return address(instance).balance == 0;
  }

  receive() external payable {}
}