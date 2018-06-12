pragma solidity ^0.4.13;

import "./Owned.sol";
import "./interfaces/TollBoothHolderI.sol";

contract TollBoothHolder is Owned, TollBoothHolderI {

    mapping(address => bool) tollBoothHolders; // TODO: Actual Tollbooths instead of address/bool?
    
    function addTollBooth(address tollBooth)
        public
        returns(bool success) { 
            require(!tollBoothHolders[tollBooth]);
            require(tollBooth != address(0));

            tollBoothHolders[tollBooth] = true;

            LogTollBoothAdded(msg.sender, tollBooth);
            return true;
        }

    function isTollBooth(address tollBooth)
        constant
        public
        returns(bool isIndeed) { 
            require(tollBooth != address(0));

            return tollBoothHolders[tollBooth];
        }

    function removeTollBooth(address tollBooth)
        public
        returns(bool success) {
            require(tollBooth != address(0));
            require(tollBoothHolders[tollBooth]);

            delete tollBoothHolders[tollBooth];

            LogTollBoothRemoved(msg.sender, tollBooth);
            return true;
        }    
}