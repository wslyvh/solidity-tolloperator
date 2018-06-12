var Regulator = artifacts.require("./Regulator.sol");
var TollBoothOperator = artifacts.require("./TollBoothOperator.sol");

module.exports = function(deployer) {
  deployer.deploy(Regulator);
};