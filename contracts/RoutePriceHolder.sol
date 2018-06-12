pragma solidity ^0.4.13;

import "./Owned.sol";
import "./TollBoothHolder.sol";
import "./interfaces/RoutePriceHolderI.sol";

contract RoutePriceHolder is Owned, TollBoothHolder, RoutePriceHolderI {

    event LogTest(address sender, string description, uint value);

    mapping(bytes32 => uint) routePrices;

    function setRoutePrice(address entryBooth, address exitBooth, uint priceWeis)
        public
        returns(bool success) {
            //LogTest(msg.sender, "Trying to set route price from RoutePriceHolder...", 0);

            require(entryBooth != address(0));
            require(exitBooth != address(0));
            require(isTollBooth(entryBooth));
            require(isTollBooth(exitBooth));
            require(entryBooth != exitBooth);
            var hashedRoute = keccak256(entryBooth, exitBooth);
            //require(routePrices[hashedRoute] != priceWeis);

            routePrices[hashedRoute] = priceWeis;

            LogRoutePriceSet(msg.sender, entryBooth, exitBooth, priceWeis);
            
            return true;
        }

    function getRoutePrice(address entryBooth, address exitBooth)
        constant
        public
        returns(uint priceWeis) {
            if (entryBooth == address(0) || exitBooth == address(0) || !isTollBooth(entryBooth) || !isTollBooth(exitBooth))
                return 0;
               
            return routePrices[keccak256(entryBooth, exitBooth)];
        }
}