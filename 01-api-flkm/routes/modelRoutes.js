const express = require("express");
const multer = require("multer");
const csvParser = require("csv-parser");
const fs = require("fs");
const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const ModelsMetadata = require("../models/modelMetadata");

modelRoutes = express.Router();

// Define a Schema
const ModelsSchema = new mongoose.Schema({}, { strict: false });

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: storage });

const Model = require("../models/modelAttributes");
const ModelMetadata = require("../models/modelMetadata");

// Upload Model
modelRoutes.post(
  "/models/upload",
  upload.single("modelFile"),
  async (req, res) => {
    try {
      // Upload file to S3
      const s3Params = {
        Bucket: process.env.AWS_BUCKET_NAME,
        Key: `models/${req.file.originalname}`,
        Body: req.file.buffer,
      };

      const s3Upload = await s3.upload(s3Params).promise();

      // Generate a new model ID
      const newModelId = new mongoose.Types.ObjectId();

      // Save primary attributes to MongoDB
      const newModel = new Model({
        modelId: newModelId,
        name: req.body.name, // Assuming the name is passed in the request
        version: req.body.version,
        description: req.body.description,
        filePath: s3Upload.Location,
        ownerId: req.body.ownerId, // Assuming the ownerId is passed in the request
      });

      await newModel.save();

      // Create a new metadata entry
      const newModelMetadata = new ModelMetadata({
        modelId: newModelId,
        downloadCount: 0,
        lastAccessed: new Date(),
        rating: 0,
      });

      await newModelMetadata.save();

      res.status(201).json({ modelId: newModelId, status: "uploaded" });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  }
);

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
