// marketplace.controller.js
const MarketplaceService = require("../services/marketplace.service");

exports.getResourceList = async (req, res) => {
  try {
    const resources = await MarketplaceService.getResourceList();
    res.status(200).json(resources);
  } catch (error) {
    res.status(500).send("Internal Server Error");
  }
};
