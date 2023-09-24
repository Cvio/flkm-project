require("dotenv").config();
const express = require("express");
const crypto = require("crypto"); // Required for generating tokens
const bcrypt = require("bcrypt"); // Required for password hashing
const authenticate = require("../auth/authMiddleware");
const User = require("../models/user.model"); // Import your User model
const Project = require("../models/project.model");

const flkmRoutes = express.Router();

// Test endpoint
flkmRoutes.get("/flkm-test", (req, res) => {
  res.send("Hello, flkm!");
});

module.exports = flkmRoutes;
