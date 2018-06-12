pragma solidity ^0.4.13;

import "./interfaces/OwnedI.sol";

contract Owned is OwnedI { 

    address currentOwner;

    modifier fromOwner {
        require(msg.sender == currentOwner);
        _;
    }

    function Owned() public { 
        currentOwner = msg.sender;
    }
    
    function setOwner(address newOwner) 
        fromOwner
        returns(bool success) {
            require(newOwner != address(0));
            require(newOwner != currentOwner);

            currentOwner = newOwner;

            LogOwnerSet(msg.sender, newOwner);
            return true;
        }

    function getOwner() 
        constant
        returns(address owner) { 
            return currentOwner;
        }
}