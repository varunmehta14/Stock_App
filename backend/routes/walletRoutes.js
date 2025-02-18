// routes/wallet.js

const express = require('express');
const router = express.Router();
const walletController = require('../controller/walletController');

// Route to get wallet balance
router.get('/', walletController.getWalletBalance);

// Route to update wallet balance
router.put('/', walletController.updateWalletBalance);

module.exports = router;
