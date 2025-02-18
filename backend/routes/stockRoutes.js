// routes/stockRoutes.js

const express = require('express');
const router = express.Router();
const stockController = require('../controller/stockController');

// Define routes for fetching historical stock data
router.get('/historical-data/:ticker', stockController.getHistoricalData);
router.get('/chart-data/:ticker', stockController.getChartData);

module.exports = router;