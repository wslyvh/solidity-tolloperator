pragma solidity ^0.4.13;

import "./Owned.sol";
import "./interfaces/MultiplierHolderI.sol";

contract MultiplierHolder is Owned, MultiplierHolderI {

    mapping(uint => uint) multipliers;
    
    function setMultiplier(uint vehicleType, uint multiplier)
        fromOwner
        public
        returns(bool success) {
            require(vehicleType > 0);
            require(multipliers[vehicleType] != multiplier);

            if (multiplier == 0)
                delete multipliers[vehicleType];
            else
                multipliers[vehicleType] = multiplier;

            LogMultiplierSet(msg.sender, vehicleType, multiplier);
            return true;
        }

    function getMultiplier(uint vehicleType)
        constant
        public
        returns(uint multiplier) {
            require(vehicleType > 0);

            return multipliers[vehicleType];
        }
}