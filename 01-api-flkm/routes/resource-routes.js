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
      const resourceId = uuidv4(); // Generate a unique Resource ID
      const filePath = req.file.path; // Get the path of the uploaded file
      const buffer = req.file.buffer; // Get the buffer of the uploaded file

      const results = [];
      const Schema = mongoose.Schema;
      const DynamicSchema = new Schema(
        {},
        { strict: false, collection: resourceId }
      );
      const DynamicModel = mongoose.model(resourceId, DynamicSchema);

      // Parse CSV from file path
      fs.createReadStream(filePath)
        .pipe(csvParser())
        .on("data", (data) => results.push(data))
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

module.exports = resourceRoutes;
