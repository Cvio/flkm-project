require("dotenv").config();
const express = require("express");
const crypto = require("crypto"); // Required for generating tokens
const bcrypt = require("bcrypt"); // Required for password hashing
const authenticate = require("../auth/auth-middleware");
const User = require("../models/user"); // Import your User model
const Project = require("../models/project");

const projectRoutes = express.Router();

// Test endpoint
projectRoutes.get("/project-test", (req, res) => {
  res.send("Hello, project!");
});

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

// Federated Learning Project API Endpoints
projectRoutes.get("/projects", async (req, res) => {
  // List FLN projects
  // ...
});

projectRoutes.post(
  "/create-project",
  authenticate,
  //upload.single(datasetId),
  async (req, res) => {
    try {
      const {
        projectName,
        description,
        datasetId, // selected from the marketplace
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
        ownerId,
      } = req.body;

      // Get the file path of the uploaded dataset
      //const datasetFilePath = req.file;

      // Create a new project in your database
      const newProject = new Project({
        projectName,
        description,
        dataset: datasetId,
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
        ownerId,
      });
      newProject.ownerId = req.user.userId;
      // save the project to the database
      const savedProject = await newProject.save();

      res.status(201).json(savedProject);
    } catch (error) {
      console.error("Error creating project:", error);
      res.status(500).json({ message: "Error creating project" });
    }
  }
);

module.exports = projectRoutes;
