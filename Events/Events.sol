/*
Since we are not able to return any value from contract by return keyword
we use Event type to emit Events which we can catch outside contact.
*/

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Events {
    mapping (address => uint) public balances;

    // it's possbile to flag up to 3 arguments as indexed -> they are hashed
    // what allows to search for them later
    event TokenSent(address _from, address indexed _to, uint _amount);

    constructor() {
        balances[msg.sender] = 100;
    }

    function send(address _to, uint _amount) public {
        require(balances[msg.sender] >= _amount);
        assert(balances[msg.sender] - _amount <= balances[msg.sender]); // redundant
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        emit TokenSent(msg.sender, _to, _amount);
    }

    /*
    Extract of logs object received from transaction made on Goerli testnet
        logs = [{
                    ...
                    "event": "TokenSent",
                    "args": {
                        ...
                        "_from": "0x9D7Aba13e9cA3A11873794C01B7315297B493Dd6",
                        "_to": "0x17795300390F81F5eb7B635584Dd0A96B485483D",
                        "_amount": "42"
                    }
                }]
    */
}
