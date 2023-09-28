require("dotenv").config();

const express = require("express");
const transferRoutes = express.Router();

// Test endpoint
transferRoutes.get("/test4", (req, res) => {
  res.send("Hello, world!");
});

module.exports = transferRoutes;
