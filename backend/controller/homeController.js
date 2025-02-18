// controllers/homeController.js
exports.getHomePage = (req, res) => {
    try {
      res.send('Welcome to the homepage.');
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server Error' });
    }
  };