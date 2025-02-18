// routes/suggestionRoutes.js
const express = require('express');
const router = express.Router();
const suggestionController = require('../controller/suggestionController');


router.get('/:ticker', suggestionController.getSuggestionDetails);

module.exports = router;
