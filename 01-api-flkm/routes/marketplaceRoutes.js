// Assuming you have an Express Router
const marketPlaceRoutes = require("express").Router();
const MarketplaceController = require("../controllers/marketplace.controller");

marketPlaceRoutes.get("/resource-list", MarketplaceController.getResourceList);

module.exports = marketPlaceRoutes;
