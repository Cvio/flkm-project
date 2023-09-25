require("dotenv").config();
const express = require("express");
const etherRoutes = express.Router();
const Web3 = require("web3"); // Import the web3 library
nodeUrl = process.env.ETHEREUM_NODE_URL;
const web3 = new Web3.Web3BaseWallet(nodeUrl); // Connect to a node

etherRoutes.get("/ether-test", (req, res) => {
  res.send("Hello, ether!");
});

// Define an API endpoint to get the balance of an Ethereum wallet
// etherRoutes.get("/getBalance/:walletAddress", async (req, res) => {
//   try {
//     const walletAddress = req.params.walletAddress;

//     // Spawn a Python child process and pass the wallet address as an argument
//     const pythonProcess = spawn("python", [pythonScriptPath, walletAddress]);

//     // Capture the output of the Python script
//     pythonProcess.stdout.on("data", (data) => {
//       const balanceInWei = parseInt(data.toString().trim());
//       const balanceInEther = balanceInWei / 1e18; // Convert Wei to Ether

//       res.json({ balanceInEther });
//     });

//     pythonProcess.stderr.on("data", (data) => {
//       console.error(`Python script error: ${data}`);
//       res.status(500).json({ error: "Internal server error" });
//     });
//   } catch (error) {
//     console.error("Error calling Python script:", error);
//     res.status(500).json({ error: "Internal server error" });
//   }
// });

module.exports = etherRoutes;
