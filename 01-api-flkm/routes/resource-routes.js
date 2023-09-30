const express = require("express");
const multer = require("multer");
const csvParser = require("csv-parser");
const fs = require("fs");
const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const ResourceMetadata = require("../models/resource-metadata");

resourceRoutes = express.Router();

// Connect to MongoDB
// mongoose.connect("mongodb://localhost:27017/csvdb", {
//   useNewUrlParser: true,
//   useUnifiedTopology: true,
// });

// Define a Schema
// const ResourceSchema = new mongoose.Schema({}, { strict: false });
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
          res
            .status(200)
            .send(
              `CSV Uploaded and Stored in MongoDB with Resource ID: ${resourceId}`
            );
        });
    } catch (error) {
      res.status(500).send(error.message);
    }
  }
);

// resourceRoutes.post(
//   "/upload-resource",
//   upload.single("file"),
//   async (req, res) => {
//     try {
//       console.log(req.body);
//       const ownerId = req.body.ownerId; // Get the owner ID from the request body
//       const resourceId = uuidv4(); // Generate a unique Resource ID
//       const resourceAttributes = JSON.parse(req.body.resourceAttributes); // Get the resource attributes from the request body
//       const name = resourceAttributes.name; // Get the name of the resource
//       const filePath = req.file.path; // Get the path of the uploaded file
//       // const buffer = req.file.buffer; // Get the buffer of the uploaded file

//       const results = [];

//       // Parse CSV from file path
//       fs.createReadStream(filePath)
//         .pipe(csvParser())
//         .on("data", (data) => {
//           data.ownerId = ownerId;
//           data.resourceId = resourceId; // Add resourceId to each row
//           data.name = name; // Add name to each row
//           results.push(data);
//         })
//         .on("end", async () => {
//           // Store in MongoDB under the "name" collection
//           // const collection = db.collection(name);
//           // await collection.insertMany(results);
//           // Store in MongoDB under the "resources" collection
//           await Resource.insertMany(results);
//           res
//             .status(200)
//             .send(
//               `CSV Uploaded and Stored in MongoDB with Resource ID: ${resourceId}`
//             );
//         });
//     } catch (error) {
//       res.status(500).send(error.message);
//     }
//   }
// );

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
    const { ownerId } = req.params;

    // Query the metadata collection to find documents where ownerId matches the provided ownerId
    const resourcesMetadata = await ResourceMetadata.find({ ownerId }).lean();

    if (resourcesMetadata.length > 0) {
      res.status(200).json(resourcesMetadata);
    } else {
      res
        .status(200)
        .json({ message: "No resources found for provided ownerId" });
    }
  } catch (error) {
    console.error("Error fetching resource metadata: ", error);
    res.status(500).send("Error fetching resource metadata");
  }
});

// resourceRoutes.get("/resource-list/:ownerId", async (req, res) => {
//   try {
//     console.log("Resource route reached!"); // Log to confirm the route is being reached
//     const { ownerId } = req.params;
//     console.log("Owner ID: ", ownerId);

//     // Query the "resources" collection to find documents where ownerId matches the provided ownerId
//     const resources = await Resource.find({ ownerId }).lean();

//     if (resources.length > 0) {
//       res.status(200).json(resources);
//     } else {
//       res
//         .status(200)
//         .json({ message: "No resources found for provided ownerId" });
//     }
//   } catch (error) {
//     console.error("Error fetching resources: ", error);
//     res.status(500).send("Error fetching resources");
//   }
// });

// resourceRoutes.get("/resource-list/:ownerId", async (req, res) => {
//   try {
//     console.log("Resource route reached!"); // Log to confirm the route is being reached
//     const { ownerId } = req.params;
//     console.log("Owner ID: ", ownerId);

//     //const ownerId = "asdfasdf";
//     // Get the list of all collections (dynamic tables) in the database
//     const collectionNames = await mongoose.connection.db
//       .listCollections()
//       .toArray();

//     let resources = [];

//     // For each collection
//     for (const collection of collectionNames) {
//       let DynamicModel;
//       // Check if the model has already been compiled
//       if (mongoose.models[collection.name]) {
//         // If yes, use the existing model
//         DynamicModel = mongoose.models[collection.name];
//       } else {
//         // If not, create a new model
//         DynamicModel = mongoose.model(
//           collection.name,
//           new mongoose.Schema({}, { strict: false })
//         );
//       }
//       // Continue with the rest of the logic
//       const docs = await DynamicModel.find({ ownerId }).lean();
//       if (docs.length > 0) {
//         resources.push({ collectionName: collection.name, data: docs });
//       }
//     }

//     res.status(200).json(resources);
//   } catch (error) {
//     console.error("Error fetching resources: ", error);
//     res.status(500).send("Error fetching resources");
//   }
// });

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
