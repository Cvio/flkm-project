// marketplace.service.js
const Resource = require("../models/resource-dataset.model");

exports.getResourceList = async () => {
  try {
    return await Resource.find({});
  } catch (error) {
    throw error;
  }
};
