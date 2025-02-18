// routes/searchRoutes.js
const express = require('express');
const router = express.Router();
const searchController = require('../controller/searchController');

router.get('/home', searchController.getHomePage);
router.get('/:ticker', searchController.getSearchDetails);
router.get('/currentPrice/:ticker', searchController.getCurrentPriceTicker);
router.get('/exists/:ticker', searchController.checkTickerExists);

module.exports = router;
