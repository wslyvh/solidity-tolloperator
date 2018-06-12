pragma solidity ^0.4.13;

import "./interfaces/RegulatedI.sol";

contract Regulated is RegulatedI {

    address regulatorAddress;

    modifier fromRegulator {
        require(msg.sender == regulatorAddress);
        _;
    }

    function Regulated(address _regulator) {
        require(_regulator != address(0));

        regulatorAddress = _regulator;
    }

    function setRegulator(address newRegulator)
        fromRegulator
        public
        returns(bool success) { 
            require(newRegulator != address(0));
            require(newRegulator != regulatorAddress);

            regulatorAddress = newRegulator;

            LogRegulatorSet(msg.sender, newRegulator);

            return true;
        }

    function getRegulator()
        constant
        public
        returns(RegulatorI _regulator) { 
            return RegulatorI(regulatorAddress);
        }
}