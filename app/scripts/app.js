import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

import regulator_artifacts from '../../build/contracts/Regulator.json'

var app = angular.module('TollBoothOperations', ['ngRoute', 'LocalStorageModule', 'angular-loading-bar']);

app.config(function ($routeProvider) {

    Regulator.setProvider(web3.currentProvider);
    
        web3.eth.getAccounts(function(err, accs) {
          if (err != null) {
            alert("There was an error fetching your accounts.");
            return;
          }
    
          if (accs.length == 0) {
            alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
            return;
          }
    
          accounts = accs;
          account = accounts[0];
          account2 = accounts[1];
    
          self.init();
        });

    $routeProvider.when("/", {
        controller: "mainController",
        templateUrl: "./views/regulator.htm"
    });
});

app.constant('config', {
    appName: 'Tollbooth-Operations',
    appVersion: 1.0
});

app.run(['$rootScope', 'config', function ($rootScope, config) {
    $rootScope.config = config;
}]);

app.config(['cfpLoadingBarProvider', function (cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeSpinner = false;
}]);