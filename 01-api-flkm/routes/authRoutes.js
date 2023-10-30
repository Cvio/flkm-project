require("dotenv").config();
const express = require("express");
const crypto = require("crypto"); // Required for generating tokens
const bcrypt = require("bcrypt"); // Required for password hashing
const jwt = require("jsonwebtoken");

const authenticate = require("../auth/auth-middleware");
const User = require("../models/user"); // Import your User model
const Project = require("../models/project");

// this is ridiculous - find out why this has to be wrapped to work
const { Web3 } = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));

const authRoutes = express.Router();

// test endpoint
authRoutes.get("/auth-test", (req, res) => {
  res.send("Hello, auth!");
});

// Authentication & User Management API Endpoints
authRoutes.post("/register", async (req, res) => {
  // import smart contract
  const contractArtifact = require("../../build/contracts/ReputationNFT.json");
  // smart contract ABI and address
  const contractABI = contractArtifact.abi;
  const contractAddress = "0xcFD44D960dFEE1B202CF9915b4350E856E81752f";
  const userAddress = "0xeB6B42BFA9BCB83a72453AA2ef4D414BB9848b08";
  // Init contract
  const contract = new web3.eth.Contract(contractABI, contractAddress);

  try {
    const { username, email, password, ethereumAddress } = req.body;

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Generate email verification token
    const emailVerificationToken = crypto.randomBytes(20).toString("hex");

    console.log("Generated Token:", emailVerificationToken);

    const { sendVerificationEmail } = require("../services/email-service");

    // create a new user
    const user = new User({
      username,
      email,
      password: hashedPassword,
      emailVerificationToken,
      ethereumAddress: "0xeB6B42BFA9BCB83a72453AA2ef4D414BB9848b08",
    });

    // validate the ethereum address
    if (
      !user.ethereumAddress ||
      !/^0x[a-fA-F0-9]{40}$/.test(user.ethereumAddress)
    ) {
      return res.status(400).json({ message: "Invalid Ethereum address" });
    }

    await user.save();

    // Send verification email
    sendVerificationEmail(email, emailVerificationToken);
    try {
      // Mint NFT after successful registration
      const mintTx = await contract.methods
        .mintNFT(userAddress)
        .send({ from: userAddress });

      // Log the transaction hash and owner address to the console
      console.log("Mint Transaction:", mintTx.transactionHash);
      console.log("Owner Address:", userAddress);
    } catch (error) {
      console.log("testing");
    }

    // Send a single response
    res.status(201).json({
      message: "User registered and NFT minted successfully.",
      //mintTransaction: mintTx.transactionHash,
      ownerAddress: userAddress,
    });
  } catch (error) {
    console.error("Error:", error);
    res
      .status(500)
      .json({ message: "An error occurred", error: error.message });
  }
});

// Route to verify the email using the verification token
authRoutes.get("/verify-email/:token", async (req, res) => {
  try {
    const user = await User.findOne({
      emailVerificationToken: req.params.token,
    });

    if (!user) return res.status(404).send("Invalid verification link.");

    user.emailVerified = true;
    user.emailVerificationToken = undefined; // Clear the verification token
    await user.save();

    res.send("Email verified successfully. You can now log in.");
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});

authRoutes.post("/login", async (req, res) => {
  try {
    const secretKey = process.env.SECRET_KEY;
    const { username, password } = req.body;

    // Find the user by username
    const user = await User.findOne({ username });
    console.log("User found:", user);

    if (!user) {
      console.log("User not found");
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Compare passwords
    // Inside the /login route
    console.log("Password from request:", password);

    // Compare passwords
    const passwordMatch = await bcrypt.compare(password, user.password);

    console.log("Hashed password in DB:", user.password);
    console.log("Password match:", passwordMatch);

    if (!passwordMatch) {
      console.log("Password does not match");
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate a JWT
    const token = jwt.sign({ userId: user._id }, secretKey, {
      expiresIn: "1h",
    });

    res.status(200).json({ token });
  } catch (error) {
    console.error("Error:", error.message);
    res.status(500).json({ message: "Error logging in" });
  }
});

// // Route to request a password reset email
// router.post("/api/auth/reset-password", async (req, res) => {
//   // Implement the logic to send a password reset email here
// });

// // Route to reset the password using the reset token
// router.post("/api/auth/reset-password/:token", async (req, res) => {
//   // Implement the logic to reset the password here
// });

// // Route to request an email verification link
// router.post("/api/auth/send-verification", async (req, res) => {
//   // Implement the logic to send an email verification link here
// });

module.exports = authRoutes;
