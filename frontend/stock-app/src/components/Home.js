// components/Search.js
import React,{useContext} from 'react';
import SearchBar from './SearchBar/SearchBar.js';
import DataContext from '../DataContext.js';
import Alert from 'react-bootstrap/Alert';
const Home=()=> {
  const { stockFound} = useContext(DataContext);
  return (
    <div id="container">
       
     <SearchBar/>
     {/* <div>
     {!stockFound && <Alert variant="danger">No data found. Please enter a valid ticker.</Alert>}
     </div> */}
    </div>
  );
}

export default Home;
