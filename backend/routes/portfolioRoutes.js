// routes/portfolioRoutes.js
const express = require('express');
const router = express.Router();
const portfolioController = require('../controller/portfolioController');

// Route to get all portfolio items
router.get('/', portfolioController.getPortfolioItems);

// Route to add a new portfolio item
router.post('/', portfolioController.addPortfolioItem);

// Route to update a portfolio item by ticker symbol
router.put('/:ticker', portfolioController.updatePortfolioItem);

// Route to delete a portfolio item by ticker symbol
router.delete('/:ticker', portfolioController.deletePortfolioItem);

// Route to get a portfolio item by ticker symbol
router.get('/:ticker', portfolioController.getPortfolioItemByTicker);

module.exports = router;
