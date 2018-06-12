// const expectedExceptionPromise = require("../utils/expectedException.js");
// web3.eth.getTransactionReceiptMined = require("../utils/getTransactionReceiptMined.js");
// Promise = require("bluebird");
// Promise.allSeq = require("../utils/sequentialPromise.js");
// Promise.allNamed = require("../utils/sequentialPromiseNamed.js");

// if (typeof web3.version.getNodePromise === "undefined") {
//     Promise.promisifyAll(web3.version, { suffix: "Promise" });
// }
// if (typeof web3.eth.getAccountsPromise === "undefined") {
//     Promise.promisifyAll(web3.eth, { suffix: "Promise" });
// }

// const allArtifacts = {
//     DepositHolder: artifacts.require("./DepositHolder.sol"),
// }

// const constructors = {
//     DepositHolder: (owner) => allArtifacts.DepositHolder.new({ from: owner }),
// };

// contract('DepositHolder', function(accounts) {

//     let holder, owner0, owner1;

//     before("should prepare", function() {
//         assert.isAtLeast(accounts.length, 2);
//         owner0 = accounts[0];
//         owner1 = accounts[1];
//     });

//     Object.keys(constructors).forEach(name => {

//         describe(name, function() {

//             beforeEach("should deploy a new " + name, function() {
//                 return constructors[name](owner0)
//                     .then(instance => holder = instance);
//             });

//             describe("getOwner", function() {
                
//                 it("should have correct initial value", function() {
//                     console.log(holder);
//                     return holder.getOwner()
//                         .then(owner => assert.strictEqual(owner, owner0));
//                 });
//             });
//         });
//     });
// });