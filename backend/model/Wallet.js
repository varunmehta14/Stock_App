// models/Wallet.js

const mongoose = require('mongoose');

const walletSchema = new mongoose.Schema({
  balance: {
    type: Number,
    required: true,
    default: 25000 // Initial balance
  }
});

const Wallet = mongoose.model('Wallet', walletSchema);



module.exports = Wallet;

// Function to initialize the wallet document
const initializeWallet = async () => {
  try {
    // Check if the wallet already exists
    const existingWallet = await Wallet.findOne();
    if (!existingWallet) {
      // Create and insert the wallet document with the initial balance
      const newWallet = new Wallet();
      await newWallet.save();
      console.log('Wallet initialized with $25,000 balance.');
    } else {
      console.log('Wallet already exists.');
    }
  } catch (error) {
    console.error('Error initializing wallet:', error);
  }
};

// Run the initialization function when the application starts
initializeWallet();