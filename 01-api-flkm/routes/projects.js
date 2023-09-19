// Import necessary modules and dependencies
const express = require("express");
const app = express(); // Create your main Express app instance
const router = express.Router();

// Import your Project model and any other required modules
const Project = require("../models/project.model"); // Replace with the actual model import
// Add any middleware for authentication or authorization if needed

// Create a route for creating projects
router.post("/create-project", async (req, res) => {
  try {
    // Get project details from the request body
    const { projectName /* add more project details here */ } = req.body;

    // Create a new project in your database
    const newProject = new Project({
      projectName,
      // Set other project details here
    });

    // Save the project to the database
    const savedProject = await newProject.save();

    // Send a success response
    res.status(201).json(savedProject);
  } catch (error) {
    console.error("Error creating project:", error);
    res.status(500).json({ message: "Error creating project" });
  }
});

// Mount the router on the main app, specifying the base path
app.use("/api", router); // You can specify a base path like "/api" here

// Start your Express app by listening on a port
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
