const mongoose = require("mongoose");

const ResourceAttributes = new mongoose.Schema({
  // Define your schema properties here, e.g., name, owner, etc.
  name: String,
  owner: String,
  sector: String,
  cleanliness: Number,
  cost: Number,
  size: Number,
  demand: Number,
  uniqueness: Number,
});

const Resource = mongoose.model("MarketPlace", ResourceAttributes);

module.exports = Resource;
