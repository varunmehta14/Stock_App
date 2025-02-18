// controllers/walletController.js

const Wallet = require('../model/Wallet');

// Controller function to get wallet balance
exports.getWalletBalance = async (req, res) => {
  try {
    // Fetch the wallet balance directly
    const wallet = await Wallet.findOne();

    if (!wallet) {
      return res.status(404).json({ message: 'Wallet not found' });
    }

    res.json({ walletBalance: wallet.balance });
  } catch (error) {
    console.error('Error fetching wallet balance:', error);
    res.status(500).json({ message: 'Server Error' });
  }
};

// Controller function to update wallet balance
exports.updateWalletBalance = async (req, res) => {
  try {
    const { newBalance } = req.body;

    // Find the wallet document
    const wallet = await Wallet.findOne();

    if (!wallet) {
      return res.status(404).json({ message: 'Wallet not found' });
    }

    // Update the wallet balance
    wallet.balance = newBalance;
    await wallet.save();

    res.json({ message: 'Wallet balance updated successfully' });
  } catch (error) {
    console.error('Error updating wallet balance:', error);
    res.status(500).json({ message: 'Server Error' });
  }
};
