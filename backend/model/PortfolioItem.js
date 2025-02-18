const mongoose = require('mongoose');

const portfolioSchema = new mongoose.Schema({
  symbol: {
    type: String,
    required: true
  },

    name: {
    type: String,
    required: true
  },


  quantity: {
    type: Number,
    required: true
  },
  totalCost: {
    type: Number,
    required: true
  },
  averageValuePerShare: {
    type: Number,
    required: true
  },
  change: {
    type: Number,
    required: true
  },
  
  currentPrice: {
    type: Number,
    required: true
  },
  marketValue: {
    type: Number,
    required: true
  }
});

const PortfolioItem = mongoose.model('Portfolio', portfolioSchema);

module.exports = PortfolioItem;
