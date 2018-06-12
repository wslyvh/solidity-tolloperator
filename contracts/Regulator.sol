pragma solidity ^0.4.13;

import "./Owned.sol";
import "./TollboothOperator.sol";
import "./interfaces/RegulatorI.sol";

contract Regulator is Owned, RegulatorI {

    event LogOperatorCreation(address indexed sender);

    mapping(address => uint) vehicles;
    mapping(address => bool) approvedOperators; // TODO: Use Array/Count to iterate
    
    function setVehicleType(address vehicle, uint vehicleType)
        fromOwner
        public
        returns(bool success) {
            require(vehicle != address(0));
            require(vehicles[vehicle] != vehicleType);

            vehicles[vehicle] = vehicleType;

            LogVehicleTypeSet(msg.sender, vehicle, vehicleType);
            return true;
        }

    function getVehicleType(address vehicle)
        constant
        public
        returns(uint vehicleType) {
            require(vehicle != address(0));

            return vehicles[vehicle];
        }

    function createNewOperator(address owner, uint deposit)
        fromOwner
        public
        returns(TollBoothOperatorI newOperator) {

            require(owner != address(0));
            require(owner != msg.sender);

            var operator = new TollBoothOperator(true, deposit, address(this));
            operator.setOwner(owner);
            approvedOperators[operator] = true;

            LogTollBoothOperatorCreated(msg.sender, address(operator), owner, deposit);
            return operator;
        }

    function removeOperator(address operator)
        fromOwner
        public
        returns(bool success) {
            require(operator != address(0));
            require(approvedOperators[operator]);

            delete approvedOperators[operator];
            
            LogTollBoothOperatorRemoved(msg.sender, operator);
            return true;
        }

    function isOperator(address operator)
        constant
        public
        returns(bool indeed) {
            //require(operator != address(0));
            
            return approvedOperators[operator];
        }
}