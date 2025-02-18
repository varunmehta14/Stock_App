const PortfolioItem = require('../model/PortfolioItem');

exports.getPortfolioItems = async (req, res) => {
  try {
    const portfolioItems = await PortfolioItem.find();
    res.json(portfolioItems);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.addPortfolioItem = async (req, res) => {
  const { symbol, name, quantity, totalCost, averageValuePerShare, change, currentPrice, marketValue } = req.body;
  try {
    const newPortfolioItem = new PortfolioItem({ symbol, name, quantity, totalCost, averageValuePerShare, change, currentPrice, marketValue });
    await newPortfolioItem.save();
    res.status(201).json(newPortfolioItem);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.updatePortfolioItem = async (req, res) => {
  const ticker = req.params.ticker;
  const { quantity, totalCost, averageValuePerShare, change, currentPrice, marketValue } = req.body;
  try {
    let portfolioItem = await PortfolioItem.findOne({ symbol: ticker });
    if (!portfolioItem) {
      return res.status(404).json({ message: 'Portfolio item not found' });
    }
    portfolioItem.quantity = quantity;
    portfolioItem.totalCost = totalCost;
    portfolioItem.averageValuePerShare = averageValuePerShare;
    portfolioItem.change = change;
    portfolioItem.currentPrice = currentPrice;
    portfolioItem.marketValue = marketValue;
    await portfolioItem.save();
    res.json(portfolioItem);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.deletePortfolioItem = async (req, res) => {
  const ticker = req.params.ticker;
  try {
    const deletedItem = await PortfolioItem.findOneAndDelete({ symbol: ticker });
    if (!deletedItem) {
      return res.status(404).json({ message: 'Portfolio item not found' });
    }
    res.json({ message: 'Portfolio item deleted', deletedItem });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.getPortfolioItemByTicker = async (req, res) => {
  const ticker = req.params.ticker;
  try {
    const portfolioItem = await PortfolioItem.findOne({ symbol: ticker });
    if (!portfolioItem) {
      return res.json({ message: 'Portfolio item not found' });
    }
    res.json(portfolioItem);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};
