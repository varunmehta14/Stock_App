import React, { useState, useEffect } from 'react';
import axios from '../../utils/api.js';
import {  Spinner, Alert } from 'react-bootstrap';
import PortfolioCard from './PortfolioCard';


const Portfolio = () => {
  const [portfolio, setPortfolio] = useState([]);
  const [alertMessage, setAlertMessage] = useState('');
  const [isLoading, setIsLoading] = useState(true);
 
  useEffect(() => {
    fetchPortfolio();
  }, []);

  useEffect(() => {
   
 
   fetchWalletBalance();
   }, []);
    // Fetch user's wallet balance
    const fetchWalletBalance = async () => {
      try {
        const walletResponse = await axios.get('/wallet');
        setWalletBalance(walletResponse.data.walletBalance);
      } catch (error) {
        console.error('Error fetching wallet balance:', error);
      }
    };

   const [walletBalance, setWalletBalance] = useState(0);

  const fetchPortfolio = async () => {
    try {
      const response = await axios.get('/portfolio');
      setPortfolio(response.data);
      setIsLoading(false);
    } catch (error) {
      console.error('Error fetching portfolio:', error);
    }
  };

  const handleTransactionSuccess = (message) => {
    const variant = message.includes('sold successfully') ? 'danger' : 'success';
    setAlertMessage({ message, variant });
    setTimeout(() => {
      setAlertMessage(null);
    }, 10000); // Close alert after 10 seconds
    fetchPortfolio(); // Fetch portfolio items again
    fetchWalletBalance(); // Fetch updated wallet balance
  };


  return (
    <div className="container mt-4">
       {alertMessage && <Alert variant={alertMessage.variant} onClose={() => setAlertMessage(null)} dismissible>{alertMessage.message}</Alert>}
      <h3>My Portfolio</h3>
      <h4>Money in Wallet: ${walletBalance.toFixed(2)}</h4>
      
      {isLoading ? (
         <div className="text-center">
        <Spinner animation="border" role="status" variant="primary">
         
        </Spinner>
        </div>
      ) : portfolio.length === 0 ? (
        <Alert variant="warning" style={{textAlign:'center'}}>Currently you don't have any stock.</Alert>
      ) : (
        <div className="portfolio-items">
         
          {portfolio.map((stock) => (
            <PortfolioCard
              key={stock.symbol}
              stock={stock}
              // walletBalance={walletBalance}
              onTransactionSuccess={handleTransactionSuccess}
             
            />
          ))}
        </div>
      )}
    
    </div>
  );
};

export default Portfolio;
