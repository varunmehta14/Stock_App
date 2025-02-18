import React, { useState,useContext,useEffect } from 'react';
import { Link, useHistory } from 'react-router-dom';
// import { usestockContextData } from '../../DataContext';
import './Navbar.css'; // Ensure this file exists and is correctly styled
import DataContext from '../../DataContext';

function Navbar() {
  const { stockContextData } = useContext(DataContext);
  // console.log("Context",stockContextData)
  const [isOpen, setIsOpen] = useState(false);
  const [activeLink, setActiveLink] = useState('');
  const [searchTo,setSearchTo]=useState("/search/home");
  // const { stockContextData } = usestockContextData();
  const history = useHistory();

  const handleBackClick = () => {
    console.log("con",stockContextData)
    // console.log("pat",history.location.pathname)
    if (history.location.pathname === '/portfolio' || (history.location.pathname === '/watchlist')) {
      
      if (stockContextData) {
        console.log("cont",stockContextData.profileData.ticker)
        setSearchTo(`/search/${stockContextData.profileData.ticker}`)
        // history.push(`/search/${stockContextData.profileData.ticker}`);
      } else {
        // history.push('/search/home');
      }
    } else {
      history.goBack();
    }
  };

  const toggleNavbar = () => {
    setIsOpen(!isOpen);
  };

  const handleLinkClick = (e) => {
    e.preventDefault(); // Prevent default link behavior
    handleBackClick(); // Execute handleBackClick function
    history.push(searchTo); // Manually navigate to the new link
  };
  useEffect(() => {
    if (searchTo !== '/search/home') {
      history.push(searchTo); // Manually navigate to the new link
    }
  }, [searchTo, history]);

  return (
    <nav className="navbar navbar-expand-lg navbar-dark" style={{ backgroundColor: '#1d259a', top: "0", width: "100%",padding: '5px'}}>
      <div className="container-fluid" style={{padding:'4px'}}>
        <Link className="navbar-brand" 
        to="/search/home"
        >Stock Search</Link>
        <button
          className="navbar-toggler"
          type="button"
          onClick={toggleNavbar}
        >
          <span className="navbar-toggler-icon"></span>
        </button>
        <div className={`collapse navbar-collapse ${isOpen ? 'show' : ''}`} id="navbarNav">
          <ul className="navbar-nav ms-auto">
            <li className="nav-item">
              <Link
                className="nav-link"
                to={searchTo}

                onClick={handleLinkClick}
              >
                Search
              </Link>
            </li>
            <li className="nav-item">
              <Link
                className="nav-link"
                to="/watchlist"

                
              >
                Watchlist
              </Link>
            </li>
            <li className="nav-item">
              <Link
                className="nav-link"
                to="/portfolio"
               
              >
                Portfolio
              </Link>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;

