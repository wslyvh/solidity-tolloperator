const expectedExceptionPromise = require("../utils/expectedException.js");
web3.eth.getTransactionReceiptMined = require("../utils/getTransactionReceiptMined.js");
Promise = require("bluebird");
Promise.allSeq = require("../utils/sequentialPromise.js");
Promise.allNamed = require("../utils/sequentialPromiseNamed.js");

if (typeof web3.version.getNodePromise === "undefined") {
    Promise.promisifyAll(web3.version, { suffix: "Promise" });
}
if (typeof web3.eth.getAccountsPromise === "undefined") {
    Promise.promisifyAll(web3.eth, { suffix: "Promise" });
}

var Regulator = artifacts.require("./Regulator.sol");
var TollBoothOperator = artifacts.require("./TollBoothOperator.sol");

contract('Regulator', function(accounts) {

    var regulator;
  
    var account0 = accounts[0];
    var owner = account0;
    var account1 = accounts[1];  

    const vehicleType0 = 0;
    const vehicleType1 = 1;
    const vehicleType2 = 2;
    const vehicleType3 = 3;
    
    beforeEach(function() {
        return Regulator.new({from:owner})
            .then(function(instance) {
                regulator = instance;
            })
    });
    
    it("should create a new TollBooth Operator", function() {
        return regulator.createNewOperator(account1, 1000, {from: account0, gas:3000000})
          .then(function(tx) {
              var result = tx;
        });           
    });
});