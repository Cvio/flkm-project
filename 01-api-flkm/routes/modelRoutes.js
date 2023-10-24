const express = require("express");
const multer = require("multer");
const fs = require("fs");
const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const ModelMetadata = require("../models/modelMetadata");

const modelRoutes = express.Router();

// Define a Schema
const ModelSchema = new mongoose.Schema({}, { strict: false });

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: storage });

modelRoutes.post("/model-upload", upload.single("file"), async (req, res) => {
  try {
    const ownerId = req.body.ownerId;
    const modelId = uuidv4();
    const modelAttributes = JSON.parse(req.body.modelAttributes);
    const name = modelAttributes.name;
    const filePath = req.file.path;

    // Read the model file and store its content
    const modelContent = fs.readFileSync(filePath, "utf8");

    const newModel = {
      ownerId,
      modelId,
      modelContent,
      // other attributes
    };

    // Dynamically create a model with the specified collection name
    const DynamicModel = mongoose.model(name, ModelSchema, name);

    // Store in MongoDB under the specified collection name
    await new DynamicModel(newModel).save();

    // Create and save a new metadata document
    const newModelMetadata = new ModelMetadata({
      collectionName: name,
      ownerId: ownerId,
      createdAt: new Date(),
      // more metadata fields?
    });

    await newModelMetadata.save();
    res.status(200).json({
      message: `Model Uploaded and Stored in MongoDB with Model ID: ${modelId}`,
    });
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// Download Model
modelRoutes.get("/models/download/:modelId", (req, res) => {
  // Fetch model file and metadata from database and storage
  // Return Model file and metadata
  res.download(`./models/${req.params.modelId}.model`);
});

// List Models
modelRoutes.get("/models/list", (req, res) => {
  // Fetch all model metadata from database
  // Return array of model metadata
  res.json([{ modelId: "123", version: "1.0", description: "Sample model" }]);
});

// Update Model
modelRoutes.put(
  "/models/update/:modelId",
  upload.single("updatedModelFile"),
  (req, res) => {
    // Update model file and metadata in database and storage
    // Return update status
    res.json({ status: "updated" });
  }
);

// Delete Model
modelRoutes.delete("/models/delete/:modelId", (req, res) => {
  // Delete model file and metadata from database and storage
  // Return deletion status
  res.json({ status: "deleted" });
});

// Model Metrics
modelRoutes.get("/models/metrics/:modelId", (req, res) => {
  // Fetch model metrics from database
  // Return model metrics
  res.json({ accuracy: "95%", loss: "5%" });
});

module.exports = modelRoutes;
