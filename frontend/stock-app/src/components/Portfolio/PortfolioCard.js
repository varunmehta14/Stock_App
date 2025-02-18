import React,{useState,useEffect} from 'react';
import { Card,Col, Row } from 'react-bootstrap';
// import Modal from '@mui/material/Modal';
import {Modal,Button} from 'react-bootstrap';
import Typography from '@mui/material/Typography';
import axios from '../../utils/api';
import {Link} from 'react-router-dom';

const PortfolioCard = ({ stock,onTransactionSuccess }) => {



    console.log("Card",stock)
    const fetchWalletBalance = async () => {
      try {
        const walletResponse = await axios.get('/wallet');
        setWalletBalance(walletResponse.data.walletBalance);
      } catch (error) {
        console.error('Error fetching wallet balance:', error);
      }
    };

    const fetchCurrentPrice = async () => {
      try {
        const response = await axios.get(`/search/currentPrice/${stock.symbol}`);
        setCurrentUpdatedPrice(response.data.c);
      } catch (error) {
        console.error('Error fetching wallet balance:', error);
      }
    };

    

   const [walletBalance, setWalletBalance] = useState(0);
    
    const [isLoading, setIsLoading] = useState(true);
    const [selectedStock, setSelectedStock] = useState(null);
    const [quantity, setQuantity] = useState('');
    const [totalPrice, setTotalPrice] = useState(0);
    const [error, setError] = useState('');
    const [buyModalOpen, setBuyModalOpen] = useState(false);
    const [sellModalOpen, setSellModalOpen] = useState(false);
    const [currentUpdatedPrice, setCurrentUpdatedPrice] = useState(stock.currentPrice); 
    const [currentChange, setCurrentChange]=useState(stock.change)


    console.log("curret update",currentUpdatedPrice);
    console.log("stock avera",stock.averageValuePerShare);
 
    useEffect(() => {
   
 
      fetchWalletBalance();
      fetchCurrentPrice();
      }, [buyModalOpen,sellModalOpen]);
      
      const handleBuy = async () => {
        // Calculate the total price of the stocks to be bought
        const totalPrice = quantity * currentUpdatedPrice;
        let updatePrice=quantity * currentUpdatedPrice;
      
        // Check if the total price exceeds the amount in the wallet
        if (totalPrice > walletBalance) {
          setError('Not enough money in wallet!');
          return;
        }
      
        // If total price is valid, proceed with the buy transaction
        try {
          // Make a backend request to fetch the portfolio item by ticker
          const portfolioResponse = await axios.get(`/portfolio/${stock.symbol}`);
          console.log('response',portfolioResponse)
          // Check if the ticker exists in the portfolio
          if (portfolioResponse.data.message === 'Portfolio item not found') {
          
          } else {
            // If the ticker exists, update the existing portfolio item
            const previousQuantity = portfolioResponse.data.quantity;
            const previousTotalCost = portfolioResponse.data.totalCost;
      
            const newQuantity = previousQuantity + parseInt(quantity);
            const newTotalCost = previousTotalCost + totalPrice;
      
            await axios.put(`/portfolio/${stock.symbol}`, {
              quantity: newQuantity,
              totalCost: newTotalCost,
              averageValuePerShare: newTotalCost / newQuantity,
              change: (newTotalCost / newQuantity) - currentUpdatedPrice ,
              currentPrice: currentUpdatedPrice,
              marketValue: newQuantity * currentUpdatedPrice
            });
          }
          const walletResponse = await axios.get('/wallet');
          //  setWalletBalance2(walletResponse.data.walletBalance);
      
          // Update the wallet balance
          const updatedBalance = walletResponse.data.walletBalance - updatePrice;
          await axios.put('/wallet', { newBalance: updatedBalance });
      
          // Reset quantity and error state
          setQuantity('');
          setError('');
      
          // Close the buy modal
          handleBuyModalClose();
      
          // Display success message or perform any other actions
          onTransactionSuccess(`${stock.symbol} bought successfully`);
          console.log('Stock bought successfully');
        } catch (error) {
          console.error('Error buying stock:', error);
          setError('Failed to buy stock');
        }
    };
    
    
      
    
    const handleSell = async () => {
        // Calculate the total price of the stocks to be sold
        const totalPrice = quantity * currentUpdatedPrice;
        let updatePrice=quantity * currentUpdatedPrice;
      
        // Check if the user has enough quantity of the stock to sell
        const portfolioResponse = await axios.get(`/portfolio/${stock.symbol}`);
        if (portfolioResponse.data.message === 'Portfolio item not found' || portfolioResponse.data.quantity < quantity) {
          setError('Insufficient quantity to sell');
          return;
        }
      
        // If the user has enough quantity, proceed with the sell transaction
        try {
          // Update the portfolio item with the new quantity and total cost
          const previousQuantity = portfolioResponse.data.quantity;
          const previousTotalCost = portfolioResponse.data.totalCost;
          const newQuantity = previousQuantity - parseInt(quantity);
          const newTotalCost = previousTotalCost - totalPrice;
      
          // If the new quantity is 0, remove the stock from the portfolio
          if (newQuantity === 0) {
            await axios.delete(`/portfolio/${stock.symbol}`);
          } else {
            await axios.put(`/portfolio/${stock.symbol}`, {
              quantity: newQuantity,
              totalCost: newTotalCost,
              averageValuePerShare: newTotalCost / newQuantity,
              change: (newTotalCost / newQuantity) - currentUpdatedPrice  ,
              currentPrice: currentUpdatedPrice,
              marketValue: newQuantity * currentUpdatedPrice,
            });
          }
          const walletResponse = await axios.get('/wallet');
      
          // Update the wallet balance
          const updatedBalance = walletResponse.data.walletBalance + updatePrice;
          await axios.put('/wallet', { newBalance: updatedBalance });
      
          // Reset quantity and error state
          setQuantity('');
          setError('');
      
          // Close the sell modal
          handleSellModalClose();
      
          // Display success message or perform any other actions
          onTransactionSuccess(`${stock.symbol} sold successfully`);
          console.log('Stock sold successfully');
        } catch (error) {
          console.error('Error selling stock:', error);
          setError('Failed to sell stock');
        }
    };
    
    

      const handleBuyModalOpen = async (stock) => {
        try {
            // Fetch the current price of the selected stock from the backend API
            setSelectedStock(stock);
            const response = await axios.get(`/search/currentPrice/${stock.symbol}`);
            console.log("Response",response)
            setCurrentUpdatedPrice(response.data.c);
            setCurrentChange(response.data.d)
            
            setBuyModalOpen(true);
        } catch (error) {
            console.error('Error fetching current price:', error);
        }
    };

    const handleSellModalOpen = async (stock) => {
        try {
            // Fetch the current price of the selected stock from the backend API
            setSelectedStock(stock);
            const response = await axios.get(`/search/currentPrice/${stock.symbol}`);
            setCurrentUpdatedPrice(response.data.c);
            setCurrentChange(response.data.d)
            setSellModalOpen(true);
        } catch (error) {
            console.error('Error fetching current price:', error);
        }
    };
    
      const handleBuyModalClose = () => {
        setBuyModalOpen(false);
      };
    
      const handleSellModalClose = () => {
        setSellModalOpen(false);
      };
    
      const handleQuantityChangeSell = (event) => {
        setError('');

        const value = event.target.value;
        setQuantity(value);

        const totalPrice = value * currentUpdatedPrice;
        setTotalPrice(totalPrice);
        if (stock.quantity < value) {
            setError("You cannot sell the stocks that you don't have!");
            return;
          }
      };

      const handleQuantityChange = (event) => {
        setError('');

        const value = event.target.value;
        setQuantity(value);

        const totalPrice = value * currentUpdatedPrice;
        setTotalPrice(totalPrice);
        if (totalPrice > walletBalance) {
            setError('Not enough money in wallet!');
            return;
        }
      };
  return (
    
    <div className="portfolio-item mb-3">
     
      <Card className="portfolio-item">
      
        <Card.Header><strong>{stock.symbol}</strong>{" "}<span style={{ fontSize: '0.8em' }}>{stock.name}</span></Card.Header>
        <Link to={`/search/${stock.symbol}`} style={{ textDecoration: 'none', color: 'inherit' }}>
        <Card.Body>

          
          <Row style={{fontSize:'large',fontWeight:600,margin:0}}>
          
          <Col xs={12} className="d-md-none">
          <Row>
              <Col xs={6}>
                <p>Quantity:</p>
                <p>Avg. Cost / Share:</p>
                <p>Total Cost:</p>
                <p>Change:</p>
                <p>Current Price:</p>
                <p>Market Value:</p>
               
              </Col>
              <Col xs={6}>
                <p>{stock.quantity}</p>
                <p>{stock.averageValuePerShare.toFixed(2)}</p>
                <p>{stock.totalCost.toFixed(2)}</p>
                <p style={{ color: currentUpdatedPrice < stock.averageValuePerShare ? 'red' : currentUpdatedPrice > stock.averageValuePerShare ? 'green' : 'black' }}>   {currentUpdatedPrice < stock.averageValuePerShare ? (
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-down-fill" viewBox="0 0 16 16">
                          <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z" />
                        </svg>
                      ) :currentUpdatedPrice > stock.averageValuePerShare? (
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-up-fill" viewBox="0 0 16 16">
                          <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z" />
                        </svg>
                      ):<></>}{stock.change.toFixed(2)}</p>
              <p style={{ color: currentUpdatedPrice < stock.averageValuePerShare ? 'red' : currentUpdatedPrice > stock.averageValuePerShare ? 'green' : 'black' }}>{currentUpdatedPrice.toFixed(2)}</p>

<p style={{ color: currentUpdatedPrice < stock.averageValuePerShare ? 'red' : currentUpdatedPrice > stock.averageValuePerShare ? 'green' : 'black' }}>{stock.marketValue.toFixed(2)}</p>
               
              </Col>
           
                         </Row>
           
          </Col>
          
          {/* Render each key and value in separate columns on larger screens */}
          <Col md={12} className="d-none d-md-block">
            <Row>
              <Col md={3}>
                <p>Quantity:</p>
                <p>Avg. Cost / Share:</p>
                <p>Total Cost:</p>
               
              </Col>
              <Col md={3}>
                <p>{stock.quantity}</p>
                <p>{stock.averageValuePerShare.toFixed(2)}</p>
                <p>{stock.totalCost.toFixed(2)}</p>
               
              </Col>
              <Col md={3}>
              <p>Change:</p>
                <p>Current Price:</p>
                <p>Market Value:</p>
              </Col>
              <Col md={3} >
              <p style={{ color: currentUpdatedPrice < stock.averageValuePerShare ? 'red' : currentUpdatedPrice > stock.averageValuePerShare ? 'green' : 'black' }}>   {currentUpdatedPrice < stock.averageValuePerShare ? (
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-down-fill" viewBox="0 0 16 16">
                          <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z" />
                        </svg>
                      ) :currentUpdatedPrice > stock.averageValuePerShare? (
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-up-fill" viewBox="0 0 16 16">
                          <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z" />
                        </svg>
                      ):<></>}{stock.change.toFixed(2)}</p>
              <p style={{ color: currentUpdatedPrice < stock.averageValuePerShare ? 'red' : currentUpdatedPrice > stock.averageValuePerShare ? 'green' : 'black' }}>{currentUpdatedPrice.toFixed(2)}</p>

<p style={{ color: currentUpdatedPrice < stock.averageValuePerShare ? 'red' : currentUpdatedPrice > stock.averageValuePerShare ? 'green' : 'black' }}>{stock.marketValue.toFixed(2)}</p>
              </Col>
                         </Row>
          </Col>
        </Row>
        </Card.Body>
        </Link>
        <Card.Footer >
          <Button variant="primary"   className="mx-2" onClick={() => handleBuyModalOpen(stock)}>Buy</Button>
          <Button variant="danger" className="mx-2" onClick={() => handleSellModalOpen(stock)}>Sell</Button>
        </Card.Footer>
     
      </Card>
     
       
      <Modal show={buyModalOpen} onHide={handleBuyModalClose}>
  <Modal.Header closeButton>
    <Modal.Title>{stock.symbol}</Modal.Title>
  </Modal.Header>
  <Modal.Body>
    <p>Current Price: {currentUpdatedPrice.toFixed(2)}</p>
    <p>Money in Wallet: ${walletBalance.toFixed(2)}</p>
    Quantity: <input type="number" value={quantity} onChange={handleQuantityChange}  />
    {error && <p style={{ color: 'red' }}>{error}</p>}
  </Modal.Body>
  <Modal.Footer style={{ justifyContent: 'space-between' }}>
    <p>Total Price: {totalPrice.toFixed(2)}</p>
    <Button variant="success" onClick={handleBuy} disabled={error || quantity < 1}>
      Buy
    </Button>
  </Modal.Footer>
</Modal>


    
    

      <Modal show={sellModalOpen} onHide={handleSellModalClose}>
        <Modal.Header closeButton>
        <Modal.Title> {stock.symbol}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
         
          <p>Current Price: {currentUpdatedPrice.toFixed(2)}</p>
          <p>Money in Wallet: ${walletBalance.toFixed(2)}</p>
          Quantity: <input type="number" value={quantity} onChange={handleQuantityChangeSell}  />
         
          <p style={{ color: 'red' }}>{error}</p>
        </Modal.Body>
        <Modal.Footer style={{justifyContent: 'space-between'}}>
        <p>Total Price: {totalPrice.toFixed(2)}</p>
          <Button variant="success" onClick={handleSell} disabled={error || quantity < 1}>
            Sell
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
   
  );
};

export default PortfolioCard;
