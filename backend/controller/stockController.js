// controllers/stockController.js

const axios = require('axios');

exports.getHistoricalData = async (req, res) => {
  try {
    const { ticker } = req.params;
    const { from, to } = req.query;
    const apiKey = '1rtBUSlIbSLiLFvm791m9WRNKfpVu5cY'; 
    
    const url = `https://api.polygon.io/v2/aggs/ticker/${ticker}/range/1/hour/${from}/${to}?adjusted=true&sort=asc&apiKey=${apiKey}`;
 

    const response = await axios.get(url);
    const responseData = response.data.results;

    res.json(responseData);
  } catch (error) {
    console.error('Error fetching historical data:', error);
    res.status(500).json({ error: 'Failed to fetch historical data' });
  }
};

exports.getChartData = async (req, res) => {
    try {
      const { ticker } = req.params;
      const { from, to } = req.query;
      const apiKey = '1rtBUSlIbSLiLFvm791m9WRNKfpVu5cY';
      
      const url = `https://api.polygon.io/v2/aggs/ticker/${ticker}/range/1/day/${from}/${to}?adjusted=true&sort=asc&apiKey=${apiKey}`;
      
  
      const response = await axios.get(url);
      const responseData = response.data.results;
  
      res.json(responseData);
    } catch (error) {
      console.error('Error fetching historical data:', error);
      res.status(500).json({ error: 'Failed to fetch historical data' });
    }
  };
