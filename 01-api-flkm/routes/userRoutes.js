require("dotenv").config();
const express = require("express");
const crypto = require("crypto"); // Required for generating tokens
const bcrypt = require("bcrypt"); // Required for password hashing
const authenticate = require("../auth/auth-middleware");
const User = require("../models/user"); // Import your User model
const Project = require("../models/project");

const userRoutes = express.Router();

// Test endpoint
userRoutes.get("/account-test", (req, res) => {
  res.send("Hello, account!");
});

userRoutes.get("/user-data", authenticate, async (req, res) => {
  try {
    const userId = req.user.userId;

    // Note: Assuming User is your user model, and Project is your project model.
    const userData = await User.findById(userId).select("username email");
    const userProjects = await Project.find({ ownerId: userId }).select(
      "projectName description"
    );

    if (!userData) return res.status(404).json({ message: "User not found" });

    res.status(200).json({ userData, userProjects }); // Changed status to 200 as it's a successful GET request
  } catch (error) {
    console.error("Error fetching user data:", error);
    res.status(500).json({ message: "Error fetching user data" });
  }
});

userRoutes.get("/user-projects", authenticate, async (req, res) => {
  try {
    // access the authenticated user's data using req.user
    const userId = req.user.userId;

    // Fetch user's projects from MongoDB where ownerId matches userId
    const userProjects = await Project.find({ ownerId: userId });

    // Check if there are any projects found
    if (!userProjects.length) {
      return res
        .status(404)
        .json({ message: "No projects found for this user" });
    }

    res.status(200).json(userProjects);
  } catch (error) {
    console.error("Error fetching user projects:", error);
    res.status(500).json({ message: "Error fetching user projects" });
  }
});

// Additional account-related routes can be added here

module.exports = userRoutes;
