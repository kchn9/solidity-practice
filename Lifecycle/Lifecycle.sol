// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LifecycleContract {
    bool public isPaused;
    address owner;

    modifier notPaused {
        require(!isPaused);
        _;
    }

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    receive() payable external {
    }

    constructor() {
        owner = msg.sender;
    }

    function pause() public ownerOnly {
        isPaused = !isPaused;
    }

    function receiveToken() public payable notPaused {}

    function withdraw(address payable _to) public notPaused ownerOnly {
        _to.transfer(address(this).balance);
    }

    function destroy(address payable _to) public ownerOnly {
        selfdestruct(_to);
    }
}