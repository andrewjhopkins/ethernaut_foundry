pragma solidity ^0.8.17;

import '../Level.sol';
import './Telephone.sol';

contract TelephoneFactory is Level {

  function createInstance(address _player) override public payable returns (address) {
    _player;
    Telephone instance = new Telephone();
    return address(instance);
  }

  function validateInstance(address payable _instance, address _player) override public returns (bool) {
    Telephone instance = Telephone(_instance);
    return instance.owner() == _player;
  }
}