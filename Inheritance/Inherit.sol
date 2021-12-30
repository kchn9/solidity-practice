// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Owned.sol";

contract TokenMint is Owned {
    uint public amount;
    uint tokenPrice = 1 ether;
    mapping(address => uint) public balances;

    constructor() {
        amount = 100;
    }

    function mint() public onlyOwner {
        assert(amount + 1 > amount); // redundant since 0.8.0 -> rollover causes error now
        amount++;
    }

    function burn() public onlyOwner {
        assert(amount - 1 < amount); // redundant since 0.8.0 -> rollover causes error now
        amount--;
    }

    function buy() public payable {
        uint _amountToBuy = msg.value / tokenPrice;
        require(amount >= _amountToBuy, "Not enough tokens in mint");
        assert(balances[msg.sender] + _amountToBuy > balances[msg.sender]); // redundant since 0.8.0 -> rollover causes error now
        balances[msg.sender] += _amountToBuy;
    }

    function sell(uint _amountToSell) public {
        require(_amountToSell <= balances[msg.sender], "You don't have enough tokens");
        assert(balances[msg.sender] - _amountToSell <= balances[msg.sender]); // redundant since 0.8.0 -> rollover causes error now
        balances[msg.sender] -= _amountToSell;
        uint _toSend = _amountToSell * tokenPrice;
        payable(msg.sender).transfer(_toSend);
    }

    receive() external payable {
        buy();
    }
}