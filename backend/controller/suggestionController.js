const axios = require('axios');

exports.getSuggestionDetails = async (req, res) => {
    const ticker = req.params.ticker;
    try {
        console.log("here suggestion")
        
        const response = await axios.get(`https://finnhub.io/api/v1/search?q=${ticker}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);
        const suggestionData = response.data;
        res.json(suggestionData);
        
      } catch (error) {
        console.error('Error fetching suggestion suggestions:', error);
        res.status(500).json({ message: 'Server Error' });
      }
}