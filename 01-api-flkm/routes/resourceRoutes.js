const express = require("express");
const multer = require("multer");
const csvParser = require("csv-parser");
const fs = require("fs");
const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const ResourceMetadata = require("../models/resourceMetadata");

resourceRoutes = express.Router();

// Connect to MongoDB
// mongoose.connect("mongodb://localhost:27017/csvdb", {
//   useNewUrlParser: true,
//   useUnifiedTopology: true,
// });

// Define a Schema
const ResourceSchema = new mongoose.Schema({}, { strict: false });
// const Resource = mongoose.model("Resource", ResourceSchema, "resources");

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: storage });

resourceRoutes.post(
  "/upload-resource",
  upload.single("file"),
  async (req, res) => {
    try {
      console.log(req.body);
      const ownerId = req.body.ownerId;
      const resourceId = uuidv4();
      const resourceAttributes = JSON.parse(req.body.resourceAttributes);
      const name = resourceAttributes.name;
      const filePath = req.file.path;

      const results = [];

      // Parse CSV from file path
      fs.createReadStream(filePath)
        .pipe(csvParser())
        .on("data", (data) => {
          data.ownerId = ownerId;
          data.resourceId = resourceId;
          results.push(data);
        })
        .on("end", async () => {
          // Dynamically create a model with the specified collection name
          const DynamicModel = mongoose.model(name, ResourceSchema, name);
          // Store in MongoDB under the specified collection name
          await DynamicModel.insertMany(results);

          // Create and save a new metadata document
          const newResourceMetadata = new ResourceMetadata({
            collectionName: name,
            ownerId: ownerId,
            createdAt: new Date(),
            // more metadata fields?
          });

          await newResourceMetadata.save(); // Save the metadata document.
          res.status(200).json({
            message: `CSV Uploaded and Stored in MongoDB with Resource ID: ${resourceId}`,
          });
        });
    } catch (error) {
      res.status(500).send(error.message);
    }
  }
);

resourceRoutes.get("/resource-list", async (req, res) => {
  try {
    // Get the list of all collections (dynamic tables) in the database
    const collectionNames = await mongoose.connection.db
      .listCollections()
      .toArray();

    let resources = [];

    for (const collection of collectionNames) {
      // Create a dynamic model for each collection
      const DynamicModel = mongoose.model(
        collection.name,
        new mongoose.Schema({}, { strict: false })
      );

      // Retrieve documents (or any other necessary data) from the dynamic collection
      const docs = await DynamicModel.find({}).lean(); // .lean() for performance, optional
      resources.push({ collectionName: collection.name, data: docs });
    }

    res.status(200).json(resources);
  } catch (error) {
    console.error("Error fetching resources: ", error);
    res.status(500).send("Error fetching resources");
  }
});

resourceRoutes.get("/resource-list/:ownerId", async (req, res) => {
  try {
    console.log("Resource route reached!");
    const { ownerId } = req.params;
    console.log("Owner ID: ", ownerId);

    // Query the "ResourceMetadata" collection to find documents where ownerId matches the provided ownerId
    const metadata = await ResourceMetadata.find({ ownerId }).lean();

    if (metadata.length > 0) {
      res.status(200).json(metadata);
    } else {
      res
        .status(200)
        .json({ message: "No resources found for provided ownerId" });
    }
  } catch (error) {
    console.error("Error fetching resources: ", error);
    res.status(500).send("Error fetching resources");
  }
});

resourceRoutes.get("/fetch-resources/:resourceId", async (req, res) => {
  try {
    const { resourceId } = req.params;
    const Model = mongoose.model(resourceId); // Get the model by resourceId
    const resources = await Model.find({}); // Fetch all documents from the collection
    res.status(200).json(resources); // Send the fetched resources as JSON
  } catch (error) {
    res.status(500).send(error.message);
  }
});

module.exports = resourceRoutes;
