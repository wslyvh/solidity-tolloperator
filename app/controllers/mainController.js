'use strict';
app.controller('mainController', ['$rootScope', '$scope', 'localStorageService', function ($rootScope, $scope, localStorageService) {

    var Web3 = require('web3');
    if (typeof web3 !== 'undefined') {
        console.log("Using Mist/MetaMask");

        web3 = new Web3(web3.currentProvider);
    } else {
        console.log("No web3 detected. Using localhost")
        web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
        // web3 = new Web3(new Web3.providers.HttpProvider("https://api.myetherapi.com/eth"));
    }

    $scope.addOperator = function(address, baseFee) { 
        console.log("Adding Operator: " + address + " (fee: " + baseFee + ")");
    };
    $scope.addVehicle = function(address, vehicleType) { 
        console.log("Adding Vehicle: " + address + " (type: " + baseFee + ")");
    };
}]);