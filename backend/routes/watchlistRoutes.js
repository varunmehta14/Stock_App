// routes/watchlistRoutes.js
const express = require('express');
const router = express.Router();
const watchlistController = require('../controller/watchListController');

router.get('/', watchlistController.getWatchlistItems);
router.post('/add', watchlistController.addWatchlistItem);
router.post('/delete', watchlistController.deleteWatchlistItem);
// Other routes for updating and deleting watchlist items
// ...

module.exports = router;
