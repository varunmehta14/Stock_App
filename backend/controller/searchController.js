// controllers/searchController.js
const axios = require('axios');

exports.getHomePage = async (req, res) => {
  try {
    res.send('This is the home page.');
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.getSearchDetails = async (req, res) => {
    const ticker = req.params.ticker;
    console.log('searchDetails')
    const { fromNews, toNews } = req.query; // Get from and to dates from query parameters
    console.log(fromNews,toNews)
    try {
      const quoteResponse = await axios.get(`https://finnhub.io/api/v1/quote?symbol=${ticker}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);
      const profileResponse = await axios.get(`https://finnhub.io/api/v1/stock/profile2?symbol=${ticker}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);
      const peersResponse = await axios.get(`https://finnhub.io/api/v1/stock/peers?symbol=${ticker}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);
      const earningsResponse = await axios.get(`https://finnhub.io/api/v1/stock/earnings?symbol=${ticker}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);
      const sentimentResponse = await axios.get(`https://finnhub.io/api/v1/stock/insider-sentiment?symbol=${ticker}&from=2022-01-01&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);
      const recommendationResponse = await axios.get(`https://finnhub.io/api/v1/stock/recommendation?symbol=${ticker}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);
      const newsResponse = await axios.get(`https://finnhub.io/api/v1/company-news?symbol=${ticker}&from=${fromNews}&to=${toNews}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);

  
      const quoteData = quoteResponse.data;
      const profileData = profileResponse.data;
      const peersData = peersResponse.data;
      const earningsData = earningsResponse.data;
      const sentimentData = sentimentResponse.data;
      const recommendationData = recommendationResponse.data;
      const newsData = newsResponse.data;
  
      // Consolidate all data into a single object
      const searchData = {
        quoteData,
        profileData,
        peersData,
        earningsData,
        sentimentData,
        recommendationData,
        newsData
      };
  
      res.json(searchData);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server Error' });
    }
  };

  exports.getCurrentPriceTicker = async (req, res) => {
    const ticker = req.params.ticker;
    try {
      const quoteResponse = await axios.get(
        `https://finnhub.io/api/v1/quote?symbol=${ticker}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`
      );
      const quoteData = quoteResponse.data;
      res.json(quoteData);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server Error' });
    }
  };

  exports.checkTickerExists = async (req, res) => {
    const ticker = req.params.ticker;
  
    try {
      const quoteResponse = await axios.get(`https://finnhub.io/api/v1/stock/profile2?symbol=${ticker}&token=cms1gqhr01qlk9b0v40gcms1gqhr01qlk9b0v410`);
      const quoteData = quoteResponse.data;
  
      
      res.json(quoteData);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Server Error' });
    }
  };
  
