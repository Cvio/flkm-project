// module.exports = async (callback) => {
//   try {
//     const Web3 = require("web3");
//     const web3 = new Web3(
//       new Web3.providers.HttpProvider("http://localhost:7545")
//     ); // Replace with your Ganache port if different

//     let accounts = await web3.eth.getAccounts();
//     console.log(accounts);

//     callback(null);
//   } catch (error) {
//     console.error(error);
//     callback(error);
//   }
// };

// cmd: truffle exec scripts/accts.js
// this script gets the accounts from the local ganache blockchain
// It will get the value from the truffle-config.js file. if you
// change the port there, you need to change it here too.

module.exports = async (callback) => {
  try {
    let accounts = await web3.eth.getAccounts();
    console.log(accounts);
    callback(null);
  } catch (error) {
    console.error(error);
    callback(error);
  }
};
