// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExceptionHandling {
    mapping (address => uint) balances;
    event ErrorLogging(string reason);

    function receiveEther() public payable {
        assert(balances[msg.sender] + msg.value >= balances[msg.sender]); // check invariants, if false consuming all gas
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount); // check inputs, if false returns remaining gas
        assert(balances[msg.sender] - _amount <= balances[msg.sender]);
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function willThrow() external pure {
        require(false, "Error message");
    }

    function tryCatch() public {
        try this.willThrow() {
            // works
        } catch Error(string memory reason) {
            emit ErrorLogging(reason); // emits reason in logs of transaction and prevents to revert
        }
    }
}