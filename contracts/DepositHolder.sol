pragma solidity ^0.4.13;

import "./Owned.sol";
import "./interfaces/DepositHolderI.sol";

contract DepositHolder is Owned, DepositHolderI {

    uint deposit;

    function DepositHolder(uint initialDeposit) {
        require(initialDeposit > 0);

        deposit = initialDeposit;
    }
    
    function setDeposit(uint depositWeis)
        fromOwner
        public
        returns(bool success) {
            require(depositWeis > 0);
            require(depositWeis != deposit);

            deposit = depositWeis;

            LogDepositSet(msg.sender, depositWeis);
            return true;
        }

    function getDeposit()
        constant
        public
        returns(uint weis) {
            return deposit;
        }
}