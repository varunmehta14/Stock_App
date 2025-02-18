

import React, { useState, useEffect } from 'react';
import axios from '../utils/api.js';
import CloseIcon from '@mui/icons-material/Close';
import Alert from 'react-bootstrap/Alert';
import { Link } from 'react-router-dom'; // Import Link from react-router-dom
import Spinner from 'react-bootstrap/Spinner'; // Import Spinner

const WatchList = () => {
  const [watchlistItems, setWatchlistItems] = useState([]);
  const [loading, setLoading] = useState(true); // State for loading status

  useEffect(() => {
    fetchWatchlistItems();
  }, []);

  const fetchWatchlistItems = async () => {
    try {
      const response = await axios.get('/watchlist');
      setWatchlistItems(response.data);
      setLoading(false); // Update loading status once data is fetched
    } catch (error) {
      console.error('Error fetching watchlist items:', error);
    }
  };

  const handleRemoveItem = async (itemId) => {
    try {
      // Remove the item from the watchlist
      await axios.post('/watchlist/delete', { symbol: itemId });
      // Fetch all watchlist items again after successful deletion
      fetchWatchlistItems();
    } catch (error) {
      console.error('Error removing item from watchlist:', error);
    }
  };

  return (
    <div className="container">
      <h2 className="my-4">My WatchList</h2>
      {/* Display spinner while loading */}
      {loading && (
        <div className="text-center">
          <Spinner animation="border" role="status" variant="primary">
           
          </Spinner>
        </div>
      )}
      {!loading && watchlistItems.length === 0 ? ( // Show message if no items in the watchlist
        <Alert variant="warning" style={{ textAlign: 'center' }}>
          Currently you don't have any stock in your watchlist.
        </Alert>
      ) : (
        watchlistItems.map(item => (
          <div key={item._id} className="card mb-3">
            <div className="card-header d-flex justify-content-start" style={{border:'none',backgroundColor:'white'}}>
              <CloseIcon onClick={() => handleRemoveItem(item.symbol)} className="close-icon" />
            </div>
            <Link to={`/search/${item.symbol}`} style={{ textDecoration: 'none', color: 'inherit' }}>
              {/* Wrap each card in Link and set the route */}
              <div className="card-body">
                <div className="row">
                  <div className="col-md-6">
                    <h4>{item.symbol}</h4>
                    <p>{item.name}</p>
                  </div>
                  <div className={`col-md-6 ${item.difference < 0 ? 'text-danger' : 'text-success'}`}>
                    <h4>{item.currentPrice.toFixed(2)}</h4>
                    <p>
                      {item.difference < 0 ? (
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-down-fill" viewBox="0 0 16 16">
                          <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z" />
                        </svg>
                      ) : (
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-up-fill" viewBox="0 0 16 16">
                          <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z" />
                        </svg>
                      )}
                      {item.difference.toFixed(2)} ({item.differencePercentage.toFixed(2)})
                    </p>
                  </div>
                </div>
              </div>
            </Link>
          </div>
        ))
      )}
    </div>
  );
};

export default WatchList;




