const PORT = process.env.PORT || 3000;
require("dotenv").config();
const express = require("express");
const app = express();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("./models/user.model"); // Import User model
const Project = require("./models/project.model");
const authenticate = require("./auth/authMiddleware");
const Web3 = require("web3");
const web3 = new Web3("HTTP://127.0.0.1:8545");
web3.setProvider(provider);

// Set up multer storage and upload configuration
const multer = require("multer"); // import multer

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/"); // define the upload destination directory
  },
  filename: (req, file, cb) => {
    cb(null, new Date().toISOString() + file.originalname); // define the file name
  },
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 1024 * 1024 }, // 1 MB file size limit
  fileFilter: (req, file, cb) => {
    if (file.mimetype === "text/csv") {
      cb(null, true); // allow CSV files
    } else {
      cb(new Error("Invalid file type. Only CSV files are allowed."));
    }
  },
});

// Use the cors middleware
const cors = require("cors");
app.use(cors());

// Initialize passport.js
const passport = require("./passport");
app.use(passport.initialize());

// Use the body-parser middleware
const bodyParser = require("body-parser");
app.use(bodyParser.json());

// Connect to MongoDB
const mongoose = require("mongoose");
const mongodbUri = process.env.MONGODB_URI;
mongoose
  .connect(mongodbUri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(async () => {
    console.log("Connected to MongoDB");

    // Fetch documents from a collection and display them
    const MyModel = mongoose.model(
      "MyModel",
      new mongoose.Schema({ name: String })
    );

    try {
      const documents = await MyModel.find({});
      console.log("Fetched documents:", documents);
    } catch (error) {
      console.error("Error fetching documents:", error.message);
    }
  })
  .catch((error) => {
    console.error("Error connecting to MongoDB:", error.message);
  });

// Authentication & User Management API Endpoints
app.post("/register", async (req, res) => {
  console.log("Request body:", req.body);
  try {
    const { username, email, password } = req.body;

    console.log("Received password:", password);

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);
    //const hashedPassword = password;

    console.log("Hashed password:", hashedPassword); // Add this line

    // Create a new user document
    const user = new User({
      username,
      email,
      password: hashedPassword,
      //MATIC or Token balance
    });

    await user.save();

    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error registering user", error: error.message });
  }
});

app.post("/login", async (req, res) => {
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

app.post("/api/logout", async (req, res) => {
  // User logout logic
  // ...
});

app.post("/api/account/create", async (req, res) => {
  try {
    const account = await web3.eth.accounts.create();
    res.json(account);
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
});

app.get("/api/account/balance/:address", async (req, res) => {
  try {
    const balanceWei = await web3.eth.getBalance(req.params.address);
    const balance = web3.utils.fromWei(balanceWei, "ether");
    res.json({ balance });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
});

app.post("/api/transfer", async (req, res) => {
  try {
    const { fromPrivateKey, toAddress, amount } = req.body;
    const fromAccount = await web3.eth.accounts.privateKeyToAccount(
      fromPrivateKey
    );

    const tx = {
      from: fromAccount.address,
      to: toAddress,
      value: web3.utils.toWei(amount.toString(), "ether"),
      gas: 21000,
      nonce: await web3.eth.getTransactionCount(fromAccount.address, "latest"),
    };

    const signedTx = await fromAccount.signTransaction(tx);
    const receipt = await web3.eth.sendSignedTransaction(
      signedTx.rawTransaction
    );

    res.json({ transactionHash: receipt.transactionHash });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
});

// Test Polygon network connection
app.get("/api/testnet/check", async (req, res) => {
  try {
    const networkId = await web3.eth.net.getId();
    res.json({ networkId });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`FLKM backend listening at http://localhost:${port}`);
});

app.get("/user", async (req, res) => {
  try {
    res.status(201).json({ message: "User data here" });
  } catch (error) {
    console.error("Error:", error.message);
    res.status(500).json({ message: "Error getting user data" });
  }
});

app.get("/user-data", authenticate, async (req, res) => {
  try {
    // access the authenticated user's data using req.user
    const userId = req.user.userId;

    // fetch user data from MongoDB
    const userData = await User.findById(userId).select(
      "username email hbarBalance"
    );

    if (!userData) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(201).json(userData);
  } catch (error) {
    console.error("Error fetching user data:", error);
    res.status(500).json({ message: "Error fetching user data" });
  }
});

app.post("/api/token", async (req, res) => {
  // Generate JWT token logic
  // ...
});

// User Dashboard API Endpoints
app.get("/api/dashboard", authenticate, async (req, res) => {
  // Fetch user dashboard data
  // ...
});

// Federated Learning Project API Endpoints
app.get("/api/projects", async (req, res) => {
  // List FLN projects
  // ...
});

app.post("/project/create", upload.single("dataset"), async (req, res) => {
  try {
    // get project details from the request body
    const {
      projectName,
      description,
      dataset,
      modelType,
      learningRate,
      privacySettings,
      participants,
      startDate,
      endDate,
      accessControl,
      dataPreprocessing,
      evaluationMetrics,
      acceptanceCriteria,
    } = req.body;

    // Get the file path of the uploaded dataset
    //const datasetFilePath = req.file;

    // Create a new project in your database
    const newProject = new Project({
      projectName,
      description,
      dataset, // save the file path in the database
      modelType,
      learningRate,
      privacySettings,
      participants,
      startDate,
      endDate,
      accessControl,
      dataPreprocessing,
      evaluationMetrics,
      acceptanceCriteria,
    });

    // save the project to the database
    const savedProject = await newProject.save();

    res.status(201).json(savedProject);
  } catch (error) {
    console.error("Error creating project:", error);
    res.status(500).json({ message: "Error creating project" });
  }
});

app.get("/api/projects/:id", async (req, res) => {
  // Get specific project details
  // ...
});

app.put("/api/projects/:id", async (req, res) => {
  // Update project details
  // ...
});

app.delete("/api/projects/:id", async (req, res) => {
  // Delete a project
  // ...
});

app.post("/api/projects/:id/dataset", async (req, res) => {
  // Upload dataset for a project
  // ...
});

app.get("/api/projects/:id/participants", async (req, res) => {
  // Get project participants
  // ...
});

app.post("/api/projects/:id/participants", async (req, res) => {
  // Add a participant to the project
  // ...
});

app.put("/api/projects/:id/participants/:participantId", async (req, res) => {
  // Update participant details
  // ...
});

app.delete(
  "/api/projects/:id/participants/:participantId",
  async (req, res) => {
    // Remove a participant from the project
    // ...
  }
);

// Federated Learning Training API Endpoints
app.post("/api/projects/:id/training", async (req, res) => {
  // Start training session
  // ...
});

app.post("/api/projects/:id/training/stop", async (req, res) => {
  // Stop training session
  // ...
});

app.post("/api/projects/:id/models", async (req, res) => {
  // Upload models for training
  // ...
});

app.post("/api/projects/:id/models/validate", async (req, res) => {
  // Validate uploaded models
  // ...
});

// Federated Learning Evaluation API Endpoints
app.post("/api/projects/:id/evaluation", async (req, res) => {
  // Set evaluation criteria
  // ...
});

app.get("/api/projects/:id/results", async (req, res) => {
  // Get training results and metrics
  // ...
});

// Data Privacy and Security API Endpoints
app.post("/api/security/encryption", async (req, res) => {
  // Implement data encryption
  // ...
});

app.post("/api/security/compliance", async (req, res) => {
  // Ensure GDPR compliance and data privacy
  // ...
});

app.post("/api/security/storage/ipfs", async (req, res) => {
  // IPFS data storage
  // ...
});

app.get("/api/security/storage/ipfs", async (req, res) => {
  // Retrieve data from IPFS storage
  // ...
});

app.post("/api/security/storage/filecoin", async (req, res) => {
  // Filecoin data storage
  // ...
});

app.get("/api/security/storage/filecoin", async (req, res) => {
  // Retrieve data from Filecoin storage
  // ...
});

// Federated Learning Knowledge Marketplace API Endpoints
app.get("/api/flkm/resources", async (req, res) => {
  // List knowledge resources
  // ...
});

app.post("/api/flkm/resources", async (req, res) => {
  // Upload knowledge resources
  // ...
});

app.get("/api/flkm/resources/:id", async (req, res) => {
  // Get a specific resource
  // ...
});

app.post("/api/flkm/resources/:id/access", async (req, res) => {
  // Manage access control for resources
  // ...
});

app.get("/api/flkm/smart-contracts", async (req, res) => {
  // List deployed smart contracts
  // ...
});

// Federated Learning Collaboration API Endpoints
app.get("/api/flkm/collaborations", async (req, res) => {
  // List collaborations
  // ...
});

app.post("/api/flkm/collaborations", async (req, res) => {
  // Create a new collaboration
  // ...
});

app.get("/api/flkm/collaborations/:id", async (req, res) => {
  // Get specific collaboration details
  // ...
});

app.put("/api/flkm/collaborations/:id", async (req, res) => {
  // Update collaboration details
  // ...
});

app.delete("/api/flkm/collaborations/:id", async (req, res) => {
  // Delete a collaboration
  // ...
});

app.post("/api/flkm/collaborations/:id/contributions", async (req, res) => {
  // Contribute to a collaboration
  // ...
});

app.get(
  "/api/flkm/collaborations/:id/contributions/rewards",
  async (req, res) => {
    // Calculate and distribute rewards
    // ...
  }
);

// Data Monetization API Endpoints
app.post("/api/flkm/monetization/terms", async (req, res) => {
  // Set terms for data monetization
  // ...
});

app.get("/api/flkm/monetization/terms", async (req, res) => {
  // Get data monetization terms
  // ...
});

app.post("/api/flkm/monetization/tracking", async (req, res) => {
  // Track data contributions and calculate earnings
  // ...
});

app.get("/api/flkm/monetization/transactions", async (req, res) => {
  // View transaction records
  // ...
});

app.post("/api/flkm/monetization/payout", async (req, res) => {
  // Request payout of earnings
  // ...
});

// AI Model Repository API Endpoints
app.get("/api/flkm/models", async (req, res) => {
  // List AI models
  // ...
});

app.post("/api/flkm/models", async (req, res) => {
  // Upload AI models
  // ...
});

app.get("/api/flkm/models/:id", async (req, res) => {
  // Get a specific AI model
  // ...
});

app.post("/api/flkm/models/:id/access", async (req, res) => {
  // Manage access control for AI models
  // ...
});

app.post("/api/flkm/models/:id/version", async (req, res) => {
  // Manage model versions and updates
  // ...
});

// Test endpoint
app.get("/test", (req, res) => {
  res.send("Hello, world!");
});

// Test endpoint
app.post("/test", (req, res) => {
  console.log("Request body:", req.body);
  res.status(200).json({ message: "Test endpoint reached" });
});

// ... (Remaining code for server configuration and listening)

app.listen(port, () => {
  console.log(`FLKM backend listening at http://localhost:${port}`);
});
