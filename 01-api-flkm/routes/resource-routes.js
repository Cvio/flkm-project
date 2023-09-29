const express = require("express");
const multer = require("multer");
const csvParser = require("csv-parser");
const fs = require("fs");
const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

resourceRoutes = express.Router();

// Connect to MongoDB
// mongoose.connect("mongodb://localhost:27017/csvdb", {
//   useNewUrlParser: true,
//   useUnifiedTopology: true,
// });

// Define a Schema
const CsvSchema = new mongoose.Schema({}, { strict: false });
const CsvModel = mongoose.model("Csv", CsvSchema);

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
      const ownerId = req.body.ownerId; // Get the owner ID from the request body
      const resourceId = uuidv4(); // Generate a unique Resource ID
      const filePath = req.file.path; // Get the path of the uploaded file
      const buffer = req.file.buffer; // Get the buffer of the uploaded file

      const results = [];
      const Schema = mongoose.Schema;
      const DynamicSchema = new Schema(
        {
          ownerId: { type: String, required: true },
        },
        { strict: false, collection: resourceId }
      );
      const DynamicModel = mongoose.model(resourceId, DynamicSchema);

      // Parse CSV from file path
      fs.createReadStream(filePath)
        .pipe(csvParser())
        .on("data", (data) => {
          data.ownerId = ownerId;
          results.push(data);
        })
        .on("end", async () => {
          // Store in MongoDB
          await DynamicModel.insertMany(results);
          res
            .status(200)
            .send(
              `CSV Uploaded and Stored in MongoDB with Resource ID: ${resourceId}`
            );
        });

      // Parse CSV from buffer
      //   fs.createReadStream(buffer)
      //     .pipe(csvParser())
      //     .on("data", (data) => results.push(data))
      //     .on("end", async () => {
      //       await DynamicModel.insertMany(results); // Save to the new collection
      //       res
      //         .status(200)
      //         .send(
      //           `CSV Uploaded and Stored in MongoDB with Resource ID: ${resourceId}`
      //         );
      //     });
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
      resources.push({ collectionName: collection.name, data: docs }); // Adjust the structure as needed
    }

    res.status(200).json(resources);
  } catch (error) {
    console.error("Error fetching resources: ", error);
    res.status(500).send("Error fetching resources");
  }
});

resourceRoutes.get("/resource-list/:ownerId", async (req, res) => {
  try {
    //const { ownerId } = req.params; // Retrieve the ownerId from the route parameters

    const ownerId = "asdfasdf";
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

      // Retrieve documents where ownerId matches the provided ownerId
      const docs = await DynamicModel.find({ ownerId }).lean(); // .lean() for performance, optional

      if (docs.length > 0) {
        resources.push({ collectionName: collection.name, data: docs }); // Adjust the structure as needed
      }
    }

    res.status(200).json(resources);
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
