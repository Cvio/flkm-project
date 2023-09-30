const mongoose = require("mongoose");

const ResourceMetadataSchema = new mongoose.Schema({
  collectionName: {
    type: String,
    required: true,
  },
  ownerId: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },

  // more fields?
});

const ResourceMetadata = mongoose.model(
  "ResourceMetadata",
  ResourceMetadataSchema,
  "resource_metadata"
);

module.exports = ResourceMetadata;
