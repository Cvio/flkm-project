const mongoose = require("mongoose");

const ModelAttributes = new mongoose.Schema({
  modelId: mongoose.Types.ObjectId,
  name: String,
  version: String,
  description: String,
  filePath: String,
  ownerId: String,
  createdAt: {
    type: Date,
    default: Date.now,
  },
  // other attributes like model type, framework used, etc.
});

const Model = mongoose.model("Model", ModelAttributes);

module.exports = Model;
