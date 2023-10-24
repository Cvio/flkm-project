const express = require("express");
const multer = require("multer");
const GridFsStorage = require("multer-gridfs-storage");
const Grid = require("gridfs-stream");
const csvParser = require("csv-parser");
const fs = require("fs");
const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const ModelsMetadata = require("../models/modelMetadata");

// Initialize MongoDB and GridFS
let gfs;
const conn = mongoose.createConnection(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

conn.once("open", () => {
  gfs = Grid(conn.db, mongoose.mongo);
  gfs.collection("uploads");
});

const modelRoutes = express.Router();

// Define a Schema
const ModelsSchema = new mongoose.Schema({}, { strict: false });

const storage = new GridFsStorage({
  url: process.env.MONGO_URI,
  file: (req, file) => {
    return {
      filename: `model_${Date.now()}_${file.originalname}`,
      bucketName: "uploads",
    };
  },
});

const upload = multer({ storage });

const Model = require("../models/modelAttributes");
const ModelMetadata = require("../models/modelMetadata");

// Upload Model
modelRoutes.post(
  "/model-upload",
  upload.single("modelFile"),
  async (req, res) => {
    try {
      const newModelId = new mongoose.Types.ObjectId();

      const newModel = new Model({
        modelId: newModelId,
        name: req.body.name,
        version: req.body.version,
        description: req.body.description,
        filePath: req.file.filename,
        ownerId: req.body.ownerId,
      });

      await newModel.save();

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
