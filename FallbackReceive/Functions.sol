// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Funtions {
    mapping(address => uint) public balanceReceived;

    function receiveMoney() public payable {
        assert(balanceReceived[msg.sender] + msg.value >= balanceReceived[msg.sender]);
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount <= balanceReceived[msg.sender], "not enough funds");
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }

    // called when calldata is empty
    receive() external payable {
        receiveMoney();
    }

    function bytesToUint(bytes memory b) internal pure returns (uint256){
        uint256 number;
        for(uint i=0;i<b.length;i++){
            number = number + uint(uint8(b[i])*(2**(8*(b.length-(i+1)))));
        }
        return number;
    }

    // called when calldata is not empty
    fallback() external {
        withdrawMoney(payable(msg.sender), bytesToUint(msg.data));
    }
}