 //SPDX-License-Identifier: MIT

///@author Omeguhh
///@notice Copied contract from my original repo from May of last year. Here for gas comparisons   only. Uncommented "checkUserBalance" and added "userEthBalance" to test against huff fns.

pragma solidity ^0.8.3;

contract SolSharedWallet{

    address payable owner;
    uint public allowance;
    mapping(address => uint) public userAllowance;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    modifier isOwner {
        require(msg.sender == owner);
        _;
    }

    function seeBalance() external view returns(uint) {
        return address(this).balance;
    }

    /*function setAllowance(uint _amount) external isOwner {
        allowance = _amount;
    }*/

    function setUserAllowance(address _user, uint _amount) external  {
        userAllowance[_user] = _amount;
    }

    function withdrawFunds(address payable _to, uint _amount) external {
        if(_to != owner) {
            require(_amount <= userAllowance[_to], "You cannot withdraw this amount");
            _to.transfer(_amount);
        } else {
            _to.transfer(_amount);
        }
    }

    function checkUserBalance() public view returns(uint256) {
         return userAllowance[msg.sender];
     }

    function userEthBalance(address _user) public view returns(uint256) {
        return address(_user).balance;
    }

}

