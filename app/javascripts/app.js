import "../stylesheets/app.css";

import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

import regulator_artifacts from '../../build/contracts/Regulator.json'
import operator_artifacts from '../../build/contracts/TollBoothOperator.json'

var Regulator = contract(regulator_artifacts);
var TollBoothOperator = contract(operator_artifacts);

var regulator;
var operator;

var accounts;
var regulatorAccount;
var operatorAccount;
var vehicleAccount1;
var vehicleAccount2;

window.App = {
  start: function() {
    var self = this;

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
      regulatorAccount = accounts[0];
      operatorAccount = accounts[1];
      vehicleAccount1 = accounts[2];
      vehicleAccount2 = accounts[3];

      self.init();
    });
  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  init: function() {
    var self = this;

    web3.defaultAccount = regulatorAccount;
    this.setStatus("Initializing... (please wait)");
    Regulator.deployed().then(function(instance) {
      regulator = instance;
      return instance;
    }).then(function(instance) {

      self.setStatus("Regulator succesfully deployed..");
      var regulator_address = document.getElementById("regulatorAddress");
      regulator_address.innerHTML = instance.address.valueOf();

      document.getElementById("operatorAddress").value = operatorAccount;

      var events = instance.allEvents();
      events.watch(function(error, event){
          if (error) {
              console.log("Error: " + error);
          } else {
              console.log(event.event + ": " + JSON.stringify(event.args));
          }
      });

    }).catch(function(e) {
      self.setStatus("Error: " + e);
    });
  },

  createOperator: function() {
    var self = this;

    this.setStatus("Initiating transaction... (please wait)");
    
    Regulator.deployed().then(function(instance) {
      
      return instance;
    }).then(function(instance) {

      var operatorAddress = document.getElementById("operatorAddress").value;
      var depositAmount = document.getElementById("depositAmount").value;
      return instance.createNewOperator(operatorAddress, depositAmount, { from: regulatorAccount, gas: 3000000 }); //instance.address
    })
    .then(tx => {
      console.log(tx);
      var newOperator = tx.logs[1].args.newOperator;
      operator = TollBoothOperator.at(newOperator);

      self.setStatus("Operator created: " + newOperator);
    }).catch(function(e) {
      
      self.setStatus("Error: " + e);
    });
  }
};

window.addEventListener('load', function() {
    
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.log("Using Mist/MetaMask");
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.log("No web3 detected. Using localhost")
    //web3 = new Web3(new Web3.providers.HttpProvider("https://api.myetherapi.com/eth"));
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }

  App.start();
});
