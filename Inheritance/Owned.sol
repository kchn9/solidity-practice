// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Owned {
    address owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not allowed to do this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}