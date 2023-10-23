const mongoose = require("mongoose");

const ModelMetadataSchema = new mongoose.Schema({
  modelId: {
    type: mongoose.Types.ObjectId,
    required: true,
  },
  downloadCount: {
    type: Number,
    default: 0,
  },
  lastAccessed: {
    type: Date,
    default: Date.now,
  },
  rating: {
    type: Number,
    default: 0,
  },
  // Additional fields like tags, categories, etc.
});

const ModelMetadata = mongoose.model(
  "ModelMetadata",
  ModelMetadataSchema,
  "model_metadata"
);

module.exports = ModelMetadata;
