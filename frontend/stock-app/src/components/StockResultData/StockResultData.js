import React, { useEffect, useState, useContext } from 'react';
import Tabs, { tabsClasses } from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Summary from '../Tabs/Summary/Summary.js';
import TopNews from '../Tabs/TopNews/TopNews.js';
import Charts from '../Tabs/Charts/Charts.js';
import Insights from '../Tabs/Insights/Insights.js';
import { formatTimestamp } from '../../utils/formatTimestamp.js';
import axios from '../../utils/api.js';
import {Modal,Button,Spinner} from 'react-bootstrap';
import {IconButton,Box} from '@mui/material';
import Typography from '@mui/material/Typography';
import { useParams } from 'react-router-dom'; 
import SearchBar from '../SearchBar/SearchBar.js';
import Alert from 'react-bootstrap/Alert';
import { useHistory } from 'react-router-dom';
import DataContext from '../../DataContext';

function StockResultData({}) {
  const { ticker } = useParams(); // Extract the 'ticker' parameter from the route
  console.log("tic",ticker)
  const [stockData, setStockData] = useState(null);
  const [marketStatus, setMarketStatus] = useState('');
  const [selectedTab, setSelectedTab] = useState(0);
  const [loading, setLoading] = useState(true);
  const [starFill, setStarFill] = useState(false); // State variable for star fill
  const [alert, setAlert] = useState(null); 
  const [alertPortfolio, setAlertPortfolio] = useState(null);// State variable for the alert message
  const [buyModalOpen, setBuyModalOpen] = useState(false);
  const [sellModalOpen, setSellModalOpen] = useState(false);
  const [quantity, setQuantity] = useState('');
  const [totalPrice, setTotalPrice] = useState(0);
  const [error, setError] = useState('');
  const [isInPortfolio, setIsInPortfolio] = useState(false);
  const [currentDetails,setCurrentDetails]=useState(null);
  const [portFolioStock,setPortfolioStock]=useState(null);
  const [itemNotFound,setItemNotFound]=useState(false);
  const history = useHistory();
  const [humanReadable,setHumanReadable]=useState('');
  const { stockContextData,updateStockContextData,stockTicker,updateStockFound,updateStockTicker } = useContext(DataContext);
  const [walletBalance,setWalletBalance]=useState()
  

  console.log("ticker",ticker)



  const fetchStockData = async () => {
    updateStockTicker(ticker)
    try {
      // Make HTTP GET request to backend server endpoint
      const today = new Date();
      const toDate = today.toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format
      const oneWeekAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000); // Calculate one week ago
      const fromDate = oneWeekAgo.toISOString().split('T')[0]; // Get one week ago's date in YYYY-MM-DD format
      const response = await axios.get(`/search/${ticker}?fromNews=${fromDate}&toNews=${toDate}`);
      if(!response.data.profileData){
        setItemNotFound(true);
        updateStockFound(false);
        return;
      }
      else{
      console.log('Search result:', response.data);
      setStockData(response.data);
      updateStockFound(true);
      updateStockContextData(response.data);
      //Update stock data in context
      if(stockTicker){
        // updateStockContextData(response.data);
      }
     
      }
    // Redirect to the stock details page
    // history.push(`/search/${ticker}`);
      setCurrentDetails(response.data.quoteData);
      const currentTimestamp = new Date().getTime();
    const quoteTimestamp = new Date(response.data.quoteData.t*1000).getTime();
    console.log("curr",currentTimestamp)
    console.log("quote",quoteTimestamp)
    const timeDifference = Math.abs(currentTimestamp - quoteTimestamp) / (1000 * 60);
    console.log('time',timeDifference)
    if (timeDifference > 5) {
      setMarketStatus('Close');
    } else {
      setMarketStatus('Open');
    }
      // Reset the 'ticker' state after successful search
      // setTicker('');
      // Clear suggestions after search
      // setSuggestions([]);
    } catch (error) {
      console.error('Error searching:', error);
    } finally {
      setLoading(false); // Set loading to false after data is fetched
    }
  };

  const isMarketOpen=(lastpricestamp)=>{
    const currentTimestamp = new Date().getTime();
    const quoteTimestamp = new Date(lastpricestamp*1000).getTime();
    console.log("curr",currentTimestamp)
    console.log("quote",quoteTimestamp)
    const timeDifference = Math.abs(currentTimestamp - quoteTimestamp) / (1000 * 60);
    console.log('time',timeDifference)
    if (timeDifference > 5) {
      setMarketStatus('Close');
    } else {
      setMarketStatus('Open');
    }
  }
  useEffect(() => {
   
    setLoading(true); // Set loading to true while fetching data
    
    if(stockContextData?.profileData?.ticker==ticker){
      setStockData(stockContextData);
      setCurrentDetails(stockContextData.quoteData)
      isMarketOpen(stockContextData.quoteData.t)
      updateStockFound(true)
      updateStockTicker(ticker)
    //   const currentTimestamp = new Date().getTime();
    // const quoteTimestamp = new Date(stockContextData.quoteData.t*1000).getTime();
    // console.log("curr",currentTimestamp)
    // console.log("quote",quoteTimestamp)
    // const timeDifference = Math.abs(currentTimestamp - quoteTimestamp) / (1000 * 60);
    // console.log('time',timeDifference)
    // if (timeDifference > 5) {
    //   setMarketStatus('Close');
    // } else {
    //   setMarketStatus('Open');
    // }
      setLoading(false)
    }
    else{
      fetchStockData();
    }
    

    
    
    
  }, [ticker,stockContextData]); // Add 'ticker' as a dependency to fetch data when the ticker parameter changes

  useEffect(() => {
    
    const fetchCurrentDetails = async () => {
  
      try {
        console.log(" fetching current price every 15 sec");
        // Modify the request URL to include the new date parameters
     //   if(marketStatus=="Open"){
     
          console.log("market open fetching price")
          const response = await axios.get(`/search/currentPrice/${ticker}`);
          if(response.data.t){
            console.log("Stock current data:", response.data);
          setCurrentDetails(response.data);
          convertUnixToHumanReadable();
          isMarketOpen(response.data.t)
          console.log(new Date(response.data.t).toLocaleString())
          }
          else{
            setItemNotFound(true)
            return
          }
          
        // }
        // else{
        //   console.log("market closed updating time")
        //   convertUnixToHumanReadable();
        // }
      } catch (error) {
        console.error('Error fetching stock data:', error);
      }
    };
  
    fetchCurrentDetails();
  
    const intervalId = setInterval(fetchCurrentDetails, 15000); // Fetch data every 15 seconds
  
    return () => {
      clearInterval(intervalId); // Clear interval on component unmount
    };
  }, [ticker]);; // Depend

  
const fetchItemExists=async()=>{
  const response = await axios.get(`/search/exists/${ticker}`);
  if (response.data.ticker) {
    return true;
  }
  else{
    return false;
  }

};
useEffect(() => {
   
 
  fetchWalletBalance();
  }, [buyModalOpen,sellModalOpen]);
   // Fetch user's wallet balance
   const fetchWalletBalance = async () => {
     try {
       const walletResponse = await axios.get('/wallet');
       setWalletBalance(walletResponse.data.walletBalance);
     } catch (error) {
       console.error('Error fetching wallet balance:', error);
     }
   };

  useEffect(() => {
    
    
        if(fetchItemExists){
          fetchWatchlistItems();

            checkPortfolio();
      
            fetchPortfolioStock();
        }
       

   
  }, [stockData,stockContextData]);
  const checkPortfolio = async () => {
    try {
      const portfolioResponse = await axios.get('/portfolio');
      const portfolioSymbols = portfolioResponse.data.map(item => item.symbol);
      setIsInPortfolio(portfolioSymbols.includes(stockData.profileData.ticker));
    } catch (error) {
      console.error('Error fetching portfolio:', error);
    }
  };

  const fetchPortfolioStock=async()=>{
    try{
        const portfolioResponse = await axios.get(`/portfolio/${stockData.profileData.ticker}`);
        console.log('response',portfolioResponse)
        // Check if the ticker exists in the portfolio
        if (portfolioResponse.data.message === 'Portfolio item not found') {
            setPortfolioStock(null)
    }
    else{
        setPortfolioStock(portfolioResponse.data)
    } 
}catch(error) {
        console.error('Error fetching watchlist items:', error);
      }

    }
  

  const fetchWatchlistItems = async () => {
    try {
      // Fetch all watchlist items from MongoDB
      const response = await axios.get('/watchlist');
      const watchlistSymbols = response.data.map(item => item.symbol);

      // Check if the current stock ticker exists in the watchlist
      const isWatchlisted = watchlistSymbols.includes(stockData.profileData.ticker);
      setStarFill(isWatchlisted);
    } catch (error) {
      console.error('Error fetching watchlist items:', error);
    }
  };
  const handleBuy = async () => {
    // Calculate the total price of the stocks to be bought
    const totalPrice = quantity * currentDetails.c;
  
    // Check if the total price exceeds the amount in the wallet
    if (totalPrice > walletBalance) {
      setError('Not enough money in wallet!');
      return;
    }
  
    // If total price is valid, proceed with the buy transaction
    try {
      // Make a backend request to fetch the portfolio item by ticker
      const portfolioResponse = await axios.get(`/portfolio/${stockData.profileData.ticker}`);
      console.log('response',portfolioResponse)
      // Check if the ticker exists in the portfolio
      if (portfolioResponse.data.message === 'Portfolio item not found') {
        // If the ticker does not exist, add a new portfolio item
        await axios.post('/portfolio', {
          symbol: stockData.profileData.ticker,
          name: stockData.profileData.name,
          quantity: parseInt(quantity),
          totalCost: totalPrice,
          averageValuePerShare: currentDetails.c,
          change: 0,
          currentPrice: currentDetails.c,
          marketValue: totalPrice
        });
      } else {
        // If the ticker exists, update the existing portfolio item
        const previousQuantity = portfolioResponse.data.quantity;
        const previousTotalCost = portfolioResponse.data.totalCost;
  
        const newQuantity = previousQuantity + parseInt(quantity);
        const newTotalCost = previousTotalCost + totalPrice;
  
        await axios.put(`/portfolio/${stockData.profileData.ticker}`, {
          quantity: newQuantity,
          totalCost: newTotalCost,
          averageValuePerShare: newTotalCost / newQuantity,
          change:(newTotalCost / newQuantity) - currentDetails.c,
          currentPrice: currentDetails.c,
          marketValue: newQuantity * currentDetails.c
        });
      }
      
  
      // Update the wallet balance
      const walletResponse = await axios.get('/wallet');
          //  setWalletBalance2(walletResponse.data.walletBalance);
      
          // Update the wallet balance
          const updatedBalance = walletResponse.data.walletBalance - totalPrice;
      await axios.put('/wallet', { newBalance: updatedBalance });
  
      // Reset quantity and error state
      setQuantity('');
      setError('');
  
      // Close the buy modal
      handleBuyModalClose();
      checkPortfolio();
      setAlertPortfolio({message:`${stockData.profileData.ticker} bought successfully.`,variant:'success'});
  
      // Display success message or perform any other actions
      console.log('Stock bought successfully');
      setTimeout(() => {
        setAlertPortfolio(null);
      }, 5000);
    } catch (error) {
      console.error('Error buying stock:', error);
      setError('Failed to buy stock');
    }
};


  

const handleSell = async () => {
    // Calculate the total price of the stocks to be sold
    const totalPrice = quantity * currentDetails.c;
  
    // Check if the user has enough quantity of the stock to sell
    const portfolioResponse = await axios.get(`/portfolio/${stockData.profileData.ticker}`);
    if (portfolioResponse.data.message === 'Portfolio item not found' || portfolioResponse.data.quantity < quantity) {
      setError("You cannot sell the stocks that you don't have!");
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
        await axios.delete(`/portfolio/${stockData.profileData.ticker}`);
      } else {
        await axios.put(`/portfolio/${stockData.profileData.ticker}`, {
          quantity: newQuantity,
          totalCost: newTotalCost,
          averageValuePerShare: newTotalCost / newQuantity,
          change:(newTotalCost / newQuantity) - currentDetails.c  ,
          currentPrice: currentDetails.c,
          marketValue: newQuantity * currentDetails.c
        });
      }
  
      const walletResponse = await axios.get('/wallet');
      //  setWalletBalance2(walletResponse.data.walletBalance);
  
      // Update the wallet balance
      const updatedBalance = walletResponse.data.walletBalance + totalPrice;
      await axios.put('/wallet', { newBalance: updatedBalance });
  
      // Reset quantity and error state
      setQuantity('');
      setError('');
  
      // Close the sell modal
      handleSellModalClose();
      checkPortfolio();
      setAlertPortfolio({message:`${stockData.profileData.ticker} sold successfully.`,variant:'danger'});
      // Display success message or perform any other actions
      console.log('Stock sold successfully');
      setTimeout(() => {
        setAlertPortfolio(null);
      }, 5000);
    } catch (error) {
      console.error('Error selling stock:', error);
      setError('Failed to sell stock');
    }
};



  const handleChangeTab = (event, newValue) => {
    setSelectedTab(newValue);
  };



  const handleStarClick = async () => {
    try {
      console.log("starclicked");
  
      // Fetch all watchlist items from MongoDB
      const watchlistItems = await axios.get('/watchlist');
      console.log('watch',watchlistItems)
      const watchlistSymbols = watchlistItems.data.map(item => item.symbol);
  
      // Check if the current stock ticker exists in the watchlist
      const isWatchlisted = watchlistSymbols.includes(stockData.profileData.ticker);
  
      if (isWatchlisted) {
        // If the stock is already in the watchlist, delete the watchlist item
        await axios.post('/watchlist/delete', { symbol: stockData.profileData.ticker });
        setAlert({message:`${stockData.profileData.ticker} removed from Watchlist.`,variant:'danger'}); // Set alert message
        setStarFill(false); // Update starFill state
        fetchWatchlistItems();
      } else {
        // If the stock is not in the watchlist, add the watchlist item
        const watchlistItemData = {
          symbol: stockData.profileData.ticker,
          name: stockData.profileData.name,
          currentPrice: stockData.quoteData.c,
          difference: stockData.quoteData.d,
          differencePercentage: stockData.quoteData.dp,
        };
        await axios.post('/watchlist/add', watchlistItemData);
        setAlert({message:`${stockData.profileData.ticker} added to Watchlist.`,variant:'success'}); // Set alert message
        setStarFill(true); // Update starFill state
        fetchWatchlistItems();
      }
  
      // Close the alert after 3 seconds
      setTimeout(() => {
        setAlert(null);
      }, 3000);
    } catch (error) {
      console.error('Error:', error);
    }
  };
  function convertUnixToHumanReadable(unixTimestamp) {
    // const date = new Date(unixTimestamp * 1000); // Convert to milliseconds by multiplying by 1000
    const date = new Date(); 
    const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // Month is zero-indexed, so add 1
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  
  const humanReadable = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  setHumanReadable(humanReadable);
  
  
  }
  
  const handleBuyModalOpen = () => {
    setBuyModalOpen(true);
  };

  const handleBuyModalClose = () => {
    setBuyModalOpen(false);
  };

  const handleSellModalOpen = () => {
    setSellModalOpen(true);
  };

  const handleSellModalClose = () => {
    setSellModalOpen(false);
  };



  const handleQuantityChangeSell = (event) => {
    setError('');
    
    const value = event.target.value;
    setQuantity(value);

    const totalPrice = value * currentDetails.c;
    setTotalPrice(totalPrice);
    if (portFolioStock.quantity < value) {
        setError("You cannot sell the stocks that you don't have");
        return;
      }
  };

  const handleQuantityChange = (event) => {
    setError('');

    const value = event.target.value;
    setQuantity(value);

    const totalPrice = value * currentDetails.c;
    setTotalPrice(totalPrice);
    if (totalPrice > walletBalance) {
        setError('Not enough money in wallet!');
        return;
    }
  };

  

 

  return (
    <div className='container'>
        <SearchBar tickerResult={ticker}/>
     {loading?( <div className="text-center">
        <Spinner animation="border" role="status" variant="primary">
        </Spinner>
        </div>):(<>
      {/* Header Section */}
      {itemNotFound ? ( <Alert variant="danger" onClose={() => setItemNotFound(null)} dismissible></Alert>):(
        <>
              {alert && <Alert variant={alert.variant} onClose={() => setAlert(null)} dismissible>{alert.message}</Alert>}
      {alertPortfolio && <Alert variant={alertPortfolio.variant} onClose={() => setAlertPortfolio(null)} dismissible>{alertPortfolio.message}</Alert>}
      
      <div className=" mt-4">
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        {/* First Column */}
        <div className="col-md-4 text-center align-items-center">
        <div className="d-flex align-items-center justify-content-center">
        <h2  >{stockData && stockData.profileData && stockData.profileData.ticker}</h2>
          <IconButton onClick={handleStarClick} className={starFill ? 'text-warning' : null}>
            {starFill ? (
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-star-fill" viewBox="0 0 16 16">
                <path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z" />
              </svg>
            ) : (
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-star" viewBox="0 0 16 16">
                <path d="M2.866 14.85c-.078.444.36.791.746.593l4.39-2.256 4.389 2.256c.386.198.824-.149.746-.592l-.83-4.73 3.522-3.356c.33-.314.16-.888-.282-.95l-4.898-.696L8.465.792a.513.513 0 0 0-.927 0L5.354 5.12l-4.898.696c-.441.062-.612.636-.283.95l3.523 3.356-.83 4.73zm4.905-2.767-3.686 1.894.694-3.957a.56.56 0 0 0-.163-.505L1.71 6.745l4.052-.576a.53.53 0 0 0 .393-.288L8 2.223l1.847 3.658a.53.53 0 0 0 .393.288l4.052.575-2.906 2.77a.56.56 0 0 0-.163.506l.694 3.957-3.686-1.894a.5.5 0 0 0-.461 0z" />
              </svg>
            )}
          </IconButton>
          </div>
          <div>
    <h5>{stockData && stockData.profileData && stockData.profileData.name}</h5>
    <p style={{fontSize:'14px'}}>{stockData && stockData.profileData && stockData.profileData.exchange}</p>
  </div>
          <div style={{display:"flex", justifyContent:"center"}}>
          <button className="btn btn-success mr-2" onClick={handleBuyModalOpen}>Buy</button>
          {isInPortfolio && (
          <button className="btn btn-danger" onClick={handleSellModalOpen}>Sell</button>
          )}
</div>

       
      
      <Modal show={buyModalOpen} onHide={handleBuyModalClose}>
        <Modal.Header closeButton>
          <Modal.Title> {stockData.profileData.ticker}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
         
          <p>Current Price: {currentDetails.c.toFixed(2)}</p>
          <p>Money in Wallet: ${walletBalance?.toFixed(2)}</p>
          Quantity: <input type="number" value={quantity} onChange={handleQuantityChange}  />
        
          <p style={{ color: 'red' }}>{error}</p>
        </Modal.Body>
        <Modal.Footer style={{justifyContent: 'space-between'}}> 
        <p>Total Price: {totalPrice.toFixed(2)}</p>
          <Button variant="success" onClick={handleBuy} disabled={error || quantity < 1}>
            Buy
          </Button>
        </Modal.Footer>
      </Modal>


    
        <Modal show={sellModalOpen} onHide={handleSellModalClose}>
        <Modal.Header closeButton>
        <Modal.Title> {stockData.profileData.ticker}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
         
          <p>Current Price: {currentDetails.c.toFixed(2)}</p>
          <p>Money in Wallet: ${walletBalance?.toFixed(2)}</p>
          Quantity: <input type="number" value={quantity} onChange={handleQuantityChangeSell }  />
         
           <p style={{ color: 'red' }}>{error}</p>
        </Modal.Body>
        <Modal.Footer style={{justifyContent: 'space-between'}}>
        <p>Total Price: {totalPrice.toFixed(2)}</p>
          <Button variant="success" onClick={handleSell} disabled={error || quantity < 1 }>
            Sell
          </Button>
        </Modal.Footer>
      </Modal>
        
        
        
      </div>
        {/* Second Column */}
        <div className="col-md-4 text-center">
        {stockData && stockData.profileData && <img src={stockData.profileData.logo} alt="Company Logo" className="img-fluid" style={{ maxWidth: '75%' , maxHeight: '75%' }}/>}
       
          
         
          
        </div>
        {/* Third Column */}
       
        <div className="col-md-4 text-center">
              <h3 className={currentDetails.d > 0 ? 'text-success' : 'text-danger'}> {currentDetails?.c.toFixed(2)}</h3>
              <p className={currentDetails.d > 0 ? 'text-success' : 'text-danger'}>
                {currentDetails.d > 0 ?  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-up-fill" viewBox="0 0 16 16">
  <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"/>
</svg>:  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-caret-down-fill" viewBox="0 0 16 16">
  <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
</svg>} {currentDetails?.d.toFixed(2)} ({currentDetails?.dp.toFixed(2)}%)
              </p>
              {/* <p>{convertUnixToHumanReadable(currentDetails.t)}</p> */}
              <p>{humanReadable}</p>
            </div>
      
        
      </div>
      <div style={{textAlign:"center"}}>{marketStatus=='Close'?( <p className={'text-danger'}>Market closed on {formatTimestamp(stockData.quoteData.t)}</p>):(<p className={'text-success'}>Market is open</p>)}</div>
      </div>
     
       
          

      {/* Render tab content based on selected tab */}
      <Box  sx={{
        flexGrow: 1,
        width:"100%",
        // maxWidth: { md: 900, sm: 600, lg:1200 },
        bgcolor: 'background.paper',
      }}>
      <Tabs value={selectedTab} onChange={handleChangeTab} 
     
       TabIndicatorProps={{ style: { background: 'blue' } }}
       variant="scrollable"
      //  variant="fullWidth"
       scrollButtons="auto"
       allowScrollButtonsMobile
       style={{ justifyContent: 'space-between' }}
      //  sx={{
      //   [`& .${tabsClasses.scrollButtons}`]: {
      //     '&.Mui-disabled': { opacity: 0.3 },
      //   },
      // }}
       >
        <Tab label="Summary"  sx={{ minWidth: "fit-content", flex: 1 }}/>
        <Tab label="Top News" sx={{ minWidth: "fit-content", flex: 1 }}/>
        <Tab label="Charts" sx={{ minWidth: "fit-content", flex: 1 }}/>
        <Tab label="Insights" sx={{ minWidth: "fit-content", flex: 1 }}/>
      </Tabs>
<div className='container mt-3'>
      {selectedTab === 0 && stockData && stockData.quoteData && stockData.profileData && (
        <Summary marketStatus={marketStatus} peersData={stockData.peersData} quoteData={currentDetails} profileData={stockData.profileData} />
      )}
      {selectedTab === 1 && stockData && stockData.newsData && (
        <TopNews newsData={stockData.newsData} />
      )}
      {selectedTab === 2 && stockData && stockData.profileData && (
        <Charts ticker={stockData.profileData.ticker} />
      )}
      {selectedTab === 3 && stockData && stockData.sentimentData && stockData.earningsData && (
        <Insights sentimentData={stockData.sentimentData} earningsData={stockData.earningsData} recommendationsData={stockData.recommendationData}/>
      )}
      </div>
</Box>
        </>
      )}
</>)}
    </div>
  );
}

export default StockResultData;
