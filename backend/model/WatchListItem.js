const mongoose = require('mongoose');

const watchlistItemSchema = new mongoose.Schema({
  symbol: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  currentPrice: {
    type: Number,
    required: true,
  },
  difference: {
    type: Number,
    required: true,
  },
  differencePercentage: {
    type: Number,
    required: true,
  },
});

const WatchlistItem = mongoose.model('WatchlistItem', watchlistItemSchema);

module.exports = WatchlistItem;
