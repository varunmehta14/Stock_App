const WatchlistItem = require('../model/WatchListItem');

exports.getWatchlistItems = async (req, res) => {
  try {
    const watchlistItems = await WatchlistItem.find();
    res.json(watchlistItems);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.addWatchlistItem = async (req, res) => {
  const { symbol, name, currentPrice, difference, differencePercentage } = req.body;
  try {
    const newWatchlistItem = new WatchlistItem({ symbol, name, currentPrice, difference, differencePercentage });
    await newWatchlistItem.save();
    res.status(201).json(newWatchlistItem);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.deleteWatchlistItem = async (req, res) => {
    const { symbol } = req.body;
    try {
      // Find the watchlist item by symbol and delete it
      const deletedItem = await WatchlistItem.findOneAndDelete({ symbol });
      if (!deletedItem) {
        return res.status(404).json({ message: 'Watchlist item not found' });
      }
      res.status(200).json({ message: 'Watchlist item deleted successfully', deletedItem });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server Error' });
    }
  };
  

// Other controller functions for updating and deleting watchlist items
// ...
