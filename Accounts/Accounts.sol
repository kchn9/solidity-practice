// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract PaymentsLedger {
    struct Payment {
        uint timestamp;
        uint amount;
    }

    struct Account {
        uint balance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }

    mapping (address => Account) public accounts;

    function getPayment(uint _id) public view returns(Payment memory) {
        return accounts[msg.sender].payments[_id];
    }

    function depositMoney() public payable {
        Payment memory newPayment = Payment(block.timestamp, msg.value);
        accounts[msg.sender].payments[accounts[msg.sender].numPayments] = newPayment;
        accounts[msg.sender].numPayments++;
        accounts[msg.sender].balance += msg.value;
    }

    function withdrawAll(address payable _to) public {
        // implements checks-effects-interaction pattern
        uint toWithdraw = accounts[msg.sender].balance;
        Payment memory newPayment = Payment(block.timestamp, toWithdraw);
        accounts[msg.sender].payments[accounts[msg.sender].numPayments] = newPayment;
        accounts[msg.sender].numPayments++;
        accounts[msg.sender].balance = 0;
        _to.transfer(toWithdraw); // interact with external address last
        // more: https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html
    }

    function withdraw(address payable _to, uint _amount) public {
        uint balance = accounts[msg.sender].balance;
        require(balance > _amount, "Not enough money");
        Payment memory newPayment = Payment(block.timestamp, _amount);
        accounts[msg.sender].payments[accounts[msg.sender].numPayments] = newPayment;
        accounts[msg.sender].numPayments++;
        accounts[msg.sender].balance -= _amount;
        _to.transfer(_amount);
    }
}