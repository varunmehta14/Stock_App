import React,{useState,useEffect} from 'react';
import { BrowserRouter as Router, Route, Switch ,Redirect} from "react-router-dom"; // Import Route and Routes
// import {Router} from 'react-router';
import Home from './components/Home';
import WatchList from './components/WatchList';
import Portfolio from './components/Portfolio/Portfolio.js';
import Navbar from "./components/Navbar/Navbar.js";
import Footer from "./components/Footer";
import './App.css';
import StockResultData from "./components/StockResultData/StockResultData.js";
import axios from './utils/api.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import { createBrowserHistory } from "history";
import { DataProvider } from './DataContext';



function App() {
  const appHistory = createBrowserHistory();

  useEffect(() => {
    // Fetch user's wallet balance
    const fetchWalletBalance = async () => {
     try {
       const walletResponse = await axios.get('/wallet');
       setWalletBalance(walletResponse.data.walletBalance);
     } catch (error) {
       console.error('Error fetching wallet balance:', error);
     }
   };
 
   fetchWalletBalance();
   }, []);

   const [walletBalance, setWalletBalance] = useState(0);
  return (
    <Router history={appHistory}>
     <DataProvider>
       <Navbar/>
     
      <div  style={{paddingBottom: '60px', bsGutterX:'0rem',paddingTop:'10px'}}>
       
        <Switch>
        <Route exact path="/">
              <Redirect to="/search/home" />
            </Route>
          
          <Route exact path="/search/home"><Home/></Route>
          <Route exact path="/search/:ticker"  ><StockResultData walletBalance={walletBalance}/></Route>
          
          <Route exact path="/watchlist"  ><WatchList walletBalance={walletBalance}/></Route>
          <Route exact path="/portfolio"><Portfolio /></Route>
        </Switch>
      </div>
     <Footer />
     </DataProvider>
    </Router>
    
  );
}

export default App;
