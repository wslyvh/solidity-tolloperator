pragma solidity ^0.4.13;

import "./Pausable.sol";
import "./DepositHolder.sol";
import "./MultiplierHolder.sol";
import "./RoutePriceHolder.sol";
import "./Regulated.sol";

import "./interfaces/TollBoothOperatorI.sol";

contract TollBoothOperator is Pausable, DepositHolder, MultiplierHolder, Regulated, RoutePriceHolder, TollBoothOperatorI {

    struct VehicleEntry {
        address vehicle;
        uint vehicleType;
        address entryBooth;
        uint deposit;
        uint timestamp;
    }

    struct PendingPaymentQueue { 
        bytes32[] exitHashes;
        uint count;
        uint cleared;
    }

    mapping(bytes32 => PendingPaymentQueue) pendingPaymentsByRoad;
    mapping(bytes32 => VehicleEntry) entries;
    uint collectedFees;

    function TollBoothOperator(bool _initialPauseState, uint _initialDeposit, address _initialRegulator) 
        Pausable(_initialPauseState) DepositHolder(_initialDeposit) Regulated(_initialRegulator)  {
        
    }
    
    function hashSecret(bytes32 secret)
        constant
        public
        returns(bytes32 hashed) { 
            return keccak256(secret);
        }

    function enterRoad(address entryBooth, bytes32 exitSecretHashed)
        whenNotPaused
        public
        payable
        returns (bool success) {
            require(isTollBooth(entryBooth));
            require(msg.value > 0);
            require(entries[exitSecretHashed].timestamp == 0);

            uint vehicleType = getRegulator().getVehicleType(msg.sender);
            uint fee = getDeposit() * getMultiplier(vehicleType); // TODO: SafeMath
            require(msg.value > fee);

            entries[exitSecretHashed].vehicle = msg.sender;
            entries[exitSecretHashed].vehicleType = vehicleType;
            entries[exitSecretHashed].entryBooth = entryBooth;
            entries[exitSecretHashed].deposit = msg.value;
            entries[exitSecretHashed].timestamp = block.timestamp;

            LogRoadEntered(msg.sender, entryBooth, exitSecretHashed, msg.value);
            return true;
        }

    function getVehicleEntry(bytes32 exitSecretHashed)
        constant
        public
        returns(address vehicle, address entryBooth, uint depositedWeis) {

            if (entries[exitSecretHashed].timestamp == 0) {
                vehicle = 0;
                entryBooth = 0;
                depositedWeis = 0;

                return;
            }

            vehicle = entries[exitSecretHashed].vehicle;
            entryBooth = entries[exitSecretHashed].entryBooth;
            depositedWeis = entries[exitSecretHashed].deposit;
        }

    function reportExitRoad(bytes32 exitSecretClear)
        whenNotPaused
        public
        returns (uint status) { 
            require(isTollBooth(msg.sender));
            bytes32 secretHashed = hashSecret(exitSecretClear);
            require(msg.sender != entries[secretHashed].entryBooth);
            require(entries[secretHashed].timestamp > 0);
            require(entries[secretHashed].deposit > 0);
            
            uint routePrice = getRoutePrice(entries[secretHashed].entryBooth, msg.sender);
            if (routePrice == 0) { 
                
                bytes32 route = keccak256(entries[secretHashed].entryBooth, msg.sender);
                pendingPaymentsByRoad[route].exitHashes.push(exitSecretClear);
                pendingPaymentsByRoad[route].count += 1;

                LogPendingPayment(secretHashed, entries[secretHashed].entryBooth, msg.sender);
                return 2;
            }
            
            exitVehicle(secretHashed, msg.sender);
            return 1;
        }

    function getPendingPaymentCount(address entryBooth, address exitBooth)
        constant
        public
        returns (uint count) {
            require(entryBooth != address(0));
            require(exitBooth != address(0));
            require(isTollBooth(entryBooth));
            require(isTollBooth(exitBooth));

            bytes32 route = keccak256(entryBooth, exitBooth);
            
            return pendingPaymentsByRoad[route].count - pendingPaymentsByRoad[route].cleared;
        }

    function clearSomePendingPayments(address entryBooth, address exitBooth, uint count)
        whenNotPaused
        public
        returns (bool success) {
            require(msg.sender != address(0));
            require(isTollBooth(entryBooth));
            require(isTollBooth(exitBooth));
            require(count > 0);
            
            bytes32 route = keccak256(entryBooth, exitBooth);
            require(pendingPaymentsByRoad[route].count > pendingPaymentsByRoad[route].cleared);

            uint startIndex = pendingPaymentsByRoad[route].cleared;
            for (uint i = 0; i < count; ++i) {
                
                if (startIndex <= pendingPaymentsByRoad[route].count) {
                    var exitSecretClear = pendingPaymentsByRoad[route].exitHashes[startIndex];
                    bytes32 secretHashed = hashSecret(exitSecretClear);

                    exitVehicle(secretHashed, exitBooth);

                    startIndex += 1;
                    pendingPaymentsByRoad[route].cleared += 1;
                }
            }

            return true;
        }

    function getCollectedFeesAmount()
        constant
        public
        returns(uint amount) { 
            return collectedFees;
        }

    function withdrawCollectedFees()
        fromOwner
        public
        returns(bool success) { 
            require(collectedFees > 0);
            currentOwner.transfer(collectedFees);
            collectedFees = 0;
// TODO: Check collected fees
            LogFeesCollected(msg.sender, collectedFees);
            return true;
        }

    function setRoutePrice(address entryBooth, address exitBooth, uint priceWeis)
        public
        returns(bool success) {
            
            var result = super.setRoutePrice(entryBooth, exitBooth, priceWeis);

            if (result) { 
                var route = keccak256(entryBooth, exitBooth);
                if (pendingPaymentsByRoad[route].count > pendingPaymentsByRoad[route].cleared) {

                    clearSomePendingPayments(entryBooth, exitBooth, 1);
                }
            }

            return result;
        }

    function exitVehicle(bytes32 exitSecretHashed, address exitBooth) 
        private
        returns(bool success) { 

            uint routePrice = getRoutePrice(entries[exitSecretHashed].entryBooth, exitBooth); 
            uint multiplier = getMultiplier(entries[exitSecretHashed].vehicleType);
            uint finalFee = routePrice * multiplier; 
            uint refund = entries[exitSecretHashed].deposit - finalFee;
            
            entries[exitSecretHashed].vehicle.transfer(refund);
            entries[exitSecretHashed].deposit = 0;
            collectedFees += finalFee;

            LogRoadExited(exitBooth, exitSecretHashed, finalFee, refund);

            return true;
    }
}