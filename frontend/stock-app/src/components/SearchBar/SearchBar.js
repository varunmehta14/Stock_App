

// // import React, { useState,useEffect,useContext } from 'react';
// // import { useHistory } from 'react-router-dom';
// // import Autocomplete from '@mui/material/Autocomplete';
// // import TextField from '@mui/material/TextField';
// // import { FormControl } from '@mui/material';
// // import SearchIcon from '@mui/icons-material/Search';
// // import CloseIcon from '@mui/icons-material/Close';
// // import axios from '../../utils/api.js';
// // import StockResultData from '../StockResultData/StockResultData.js';
// // import Alert from 'react-bootstrap/Alert';
// // import Spinner from 'react-bootstrap/Spinner'; 
// // import './SearchBar.css';
// // import DataContext from '../../DataContext';

// // function SearchBar() {
// //   const { stockTicker,updateStockTicker } = useContext(DataContext);
  
// //   const [ticker, setTicker] = useState({symbol:stockTicker?.symbol,description:stockTicker?.description}||{symbol:"",description:""});
// //   const [suggestions, setSuggestions] = useState([]);
// //   // const [stockData, setStockData] = useState(null);
// //   const [loading, setLoading] = useState(false);
// //   const [errorMessage, setErrorMessage] = useState('');
// //   // const navigate = useNavigate();
// //   const history = useHistory();

// //   const handleSearch = async (e) => {
// //     e.preventDefault();
// //     if (!ticker.symbol) {
// //       setErrorMessage('Please enter a valid ticker');
// //       return;
// //     }
// //     try {
// //       setLoading(true);
// //       // Fetch data here
// //       // navigate(`/search/${ticker.symbol}`);
// //       // console.log("ticksym",ticker)
// //       history.push(`/search/${ticker.symbol}`);
// //        history.go(`/search/${ticker.symbol}`);
// //     } catch (error) {
// //       console.error('Error fetching stock data:', error);
// //       setErrorMessage('Failed to fetch stock data. Please try again.');
// //     } finally {
// //       setLoading(false);
// //     }
// //   };

// //   const handleInputChange = async (event, value) => {
// //     event.preventDefault();
// //     const uppercaseValue = value.toUpperCase();
// //     try {   
// //         setLoading(true);
// //       const response = await axios.get(`/suggestions/${uppercaseValue}`);
// //       if (response.data.count !== 0) {
// //         const filteredData = response.data.result.filter(item => (
// //           item.type === 'Common Stock' && !item.symbol.includes('.')
// //         ));
// //         const data = filteredData.map(item => ({ symbol: item.symbol, description: item.description }));
// //         setSuggestions(data);
// //       } else {
// //         setSuggestions(['']);
// //         setErrorMessage('No data found. Please enter a valid ticker.');
// //       }
// //     } catch (error) {
// //       console.error('Error fetching suggestions:', error);
// //     }
// //     finally {
// //               setLoading(false);
// //             }
// //   };
// //   useEffect(()=>{
// //     setTicker({symbol:stockTicker?.symbol,description:stockTicker?.description}||{symbol:"",description:""})
// //   },[])
// //   const handleSuggestionClick = (selectedSuggestion) => (event) => {
// //     event.preventDefault();
    
// //     setTicker(selectedSuggestion);
// //     updateStockTicker(selectedSuggestion);
// //     setSuggestions([]);
// //     handleSearch(event);
// //   };

// //   const handleClear = () => {
// //     setTicker({symbol:"",description:""});
// //     updateStockTicker({symbol:"",description:""})
// //     setSuggestions([]);
// //     history.push(`/search/home`);
// //     history.go(`/search/home`);
// //   };

// //   const getOptionLabel = (option) => {
// //     if (!option) {
// //       return '';
// //     }
// //     return option.symbol ? `${option.symbol} | ${option.description}` : '';
// //   };
// //   console.log("Search bar tick",ticker)

// //   return (
// //     <div style={{marginTop:"10px"}}>
// //          <h2 style={{textAlign:"center"}}> STOCK SEARCH</h2>
// //       <div style={{width:'100%'}} >
// //       <div style={{  display: 'flex', alignItems: 'center', padding: '5px', justifyContent: 'center' }}>
// //         <Autocomplete
// //           noOptionsText={<></>}
// //           value={ticker||null}
// //           onChange={(event, value) => {
// //             event.preventDefault();
// //             console.log(ticker,value);
// //             setTicker(value);
            
// //             handleSuggestionClick(value);
// //           }}
// //           autoSelect={true}
// //           disableClearable // Remove clear (cross) icon
// //           disableListWrap // Remove dropdown icon
// //           options={suggestions}
// //           loading={loading} // Pass loading state to Autocomplete component
// //           loadingText={<Spinner animation="border" variant="primary" />} // Show spinner while loading
// //           getOptionLabel={getOptionLabel}
// //           // sx={{
// //           //   display: 'inline-block',
// //           //   flex:1,
// //           //   '& input': {
// //           //     // bgcolor: 'background.paper',
// //           //     color: (theme) =>
// //           //       theme.palette.getContrastText(theme.palette.background.paper),
// //           //   },
// //           // }}
// //           renderInput={(params) => (
            
// //             <TextField
// //             {...params}
// //             color='primary'
// //             placeholder="Enter stock ticker symbol"
// //             // variant="outlined"
// //             fullWidth
// //             // value={ticker || ""} // Set the value of the text field
// //             onChange={(event) => handleInputChange(event, event.target.value)}
// //             // style={{borderRadius:'25px',borderColor:'blue'}}
// //             InputProps={{
// //               ...params.InputProps,
              
// //               disableUnderline: true,
// //               sx:{borderRadius:'50px',borderColor:'#1d259a',
// //               '& .MuiSvgIcon-root': {
// //                 fontSize: '30px', // Increase icon size
// //                 color: '#1d259a', // Set icon color to blue
// //                 cursor: 'pointer',
// //                 marginRight: '5px',
// //               },
// //               '& input': {
// //                 fontSize: '16px', // Decrease input font size
// //               },},
// //               endAdornment: (
// //                 <div style={{ display: 'flex', alignItems: 'center' }}>
// //                   <SearchIcon style={{ cursor: 'pointer', marginRight: '5px' }} onClick={handleSearch} />
// //                   <CloseIcon style={{ cursor: 'pointer' }} onClick={handleClear} />
// //                 </div>
// //               ),
// //             }}
// //           />
      
// //           )}
// //         />
// //       </div>
// //       {errorMessage && <Alert variant="danger">{errorMessage}</Alert>}
// //     </div>
// //     </div>
// //   );
// // }

// // export default SearchBar;

// import React, { useState, useEffect, useContext } from 'react';
// import { useHistory } from 'react-router-dom';
// import Autocomplete from '@mui/material/Autocomplete';
// import TextField from '@mui/material/TextField';
// import SearchIcon from '@mui/icons-material/Search';
// import CloseIcon from '@mui/icons-material/Close';
// import axios from '../../utils/api.js';
// import Alert from 'react-bootstrap/Alert';
// import Spinner from 'react-bootstrap/Spinner';
// import './SearchBar.css';
// import DataContext from '../../DataContext';

// function SearchBar() {
//   const { stockTicker, updateStockTicker,updateStockContextData } = useContext(DataContext);
  
//   const [ticker, setTicker] = useState({ symbol: stockTicker?.symbol, description: stockTicker?.description } || { symbol: '', description: '' });
//   const [suggestions, setSuggestions] = useState([]);
//   const [loading, setLoading] = useState(false);
//   const [errorMessage, setErrorMessage] = useState('');
//   const history = useHistory();

//   const handleSearch = async (event,searchTicker) => {
//     event.preventDefault();
//     console.log("search ticker", searchTicker)
//     const uppercaseValue = searchTicker.toUpperCase();
//     // if (searchTicker=="") {
//     //   setErrorMessage('Please enter a valid ticker');
//     //   return;
//     // }
//     try {
//       setLoading(true);
//       const response = await axios.get(`/api/search/exists/${uppercaseValue}`);
//       console.log("res",response.data)
//       setTicker({ symbol: uppercaseValue, description: '' });
//       updateStockTicker({ symbol: uppercaseValue, description: '' });
//       if (response.data) {
//         history.push(`/search/${uppercaseValue}`);
//         history.go(`/search/${uppercaseValue}`);
//       } else {
//         setErrorMessage('Please enter a valid ticker');
//       }
//     } catch (error) {
//       console.error('Error fetching stock data:', error);
//       setErrorMessage('Failed to fetch stock data. Please try again.');
//     } finally {
//       setLoading(false);
//     }
//   };

//   const handleInputChange = async (event, value) => {
//     event.preventDefault();
//     const uppercaseValue = value.toUpperCase();
//     try {
//       setLoading(true);
//       const response = await axios.get(`/suggestions/${uppercaseValue}`);
//       if (response.data.count !== 0) {
//         const filteredData = response.data.result.filter(item => item.type === 'Common Stock' && !item.symbol.includes('.'));
//         const data = filteredData.map(item => ({ symbol: item.symbol, description: item.description }));
//         setSuggestions(data);
//       } else {
//         setSuggestions([]);
//         setErrorMessage('No data found. Please enter a valid ticker.');
//       }
//     } catch (error) {
//       console.error('Error fetching suggestions:', error);
//     } finally {
//       setLoading(false);
//     }
//   };

//   useEffect(() => {
//     console.log("Stock ticker from context", stockTicker)
//     setTicker({ symbol: stockTicker?.symbol, description: stockTicker?.description } || { symbol: '', description: '' });
//   }, [stockTicker]);

//   const handleSuggestionClick = async(selectedSuggestion) => {
//     setTicker(selectedSuggestion);
//     updateStockTicker(selectedSuggestion);
//     // updateStockContextData(null);
//     try {
//       setLoading(true);
//       const response = await axios.get(`/api/search/exists/${selectedSuggestion.symbol}`);
//       console.log("res",response.data)
//       if (response.data) {
//         history.push(`/search/${selectedSuggestion.symbol.toUpperCase()}`);
//         history.go(`/search/${selectedSuggestion.symbol.toUpperCase()}`);
//       } else {
//         setErrorMessage('Please enter a valid ticker');
//       }
//     } catch (error) {
//       console.error('Error fetching stock data:', error);
//       setErrorMessage('Failed to fetch stock data. Please try again.');
//     } finally {
//       setLoading(false);
//     }
//     // handleSearch(selectedSuggestion.symbol);
//   };

//   const handleClear = () => {
//     setTicker({ symbol: '', description: '' });
//     updateStockTicker({ symbol: '', description: '' });
//     updateStockContextData(null);
//     setSuggestions([]);
//     history.push('/search/home');
//     history.go('/search/home');
//   };

//   const getOptionLabel = (option) => {
//     if (!option) {
//       return '';
//     }
//     return option.symbol ? `${option.symbol} | ${option.description}` : '';
//   };

//   return (
//     <div style={{ marginTop: '10px' }}>
//       <h2 style={{ textAlign: 'center' }}>STOCK SEARCH</h2>
//       <div style={{ width: '100%' }}>
       
//           <div style={{ display: 'flex', alignItems: 'center', padding: '5px', justifyContent: 'center' }}>
//             <Autocomplete
//               noOptionsText={<></>}
//               value={ticker || "No ticker"}
//               onChange={(event, value) => {
//                 event.preventDefault();
//                 // setTicker(value);
//                 handleSuggestionClick(value);
//               }}
//               autoSelect={true}
//               disableClearable
//               disableListWrap
//               options={suggestions}
//               loading={loading}
//               loadingText={<Spinner animation="border" variant="primary" />}
//               isOptionEqualToValue={(option, value) => option.symbol === value.symbol}
//               getOptionLabel={getOptionLabel}
//               renderInput={(params) => (
//                 <form onSubmit={(event) => handleSearch(event,params.inputProps.value)}>
//                 <TextField
//                   {...params}
//                   color="primary"
//                   placeholder="Enter stock ticker symbol"
//                   fullWidth
//                   onChange={(event) => handleInputChange(event, event.target.value)}
//                   InputProps={{
//                     ...params.InputProps,
//                     disableUnderline: true,
//                     sx: {
//                       borderRadius: '50px',
//                       borderColor: '#1d259a',
//                       '& .MuiSvgIcon-root': {
//                         fontSize: '30px',
//                         color: '#1d259a',
//                         cursor: 'pointer',
//                         marginRight: '5px',
//                       },
//                       '& input': {
//                         fontSize: '16px',
//                       },
//                     },
//                     endAdornment: (
//                       <div style={{ display: 'flex', alignItems: 'center' }}>
//                         <SearchIcon style={{ cursor: 'pointer', marginRight: '5px' }} onClick={() => handleSearch(ticker.symbol)} />
//                         <CloseIcon style={{ cursor: 'pointer' }} onClick={handleClear} />
//                       </div>
//                     ),
//                   }}
//                 />
//                  </form>
//               )}
//             />
//           </div>
       
//       </div>
//       {errorMessage && <Alert variant="danger">{errorMessage}</Alert>}
//     </div>
//   );
// }

// export default SearchBar;

// import React, { useState, useEffect, useContext } from 'react';
// import { useHistory } from 'react-router-dom';
// import Autocomplete from '@mui/material/Autocomplete';
// import TextField from '@mui/material/TextField';
// import SearchIcon from '@mui/icons-material/Search';
// import CloseIcon from '@mui/icons-material/Close';
// import axios from '../../utils/api.js';
// import Alert from 'react-bootstrap/Alert';
// import Spinner from 'react-bootstrap/Spinner';
// import './SearchBar.css';
// import DataContext from '../../DataContext';

// function SearchBar({tickerResult}) {
//   const { stockTicker, updateStockTicker,updateStockContextData,updateStockFound} = useContext(DataContext);
  
//   const [ticker, setTicker] = useState({ symbol: stockTicker?.symbol, description: stockTicker?.description } || { symbol: '', description: '' });
//   const [suggestions, setSuggestions] = useState([]);
//   const [loading, setLoading] = useState(false);
//   const [errorMessage, setErrorMessage] = useState('');
//   const [inputValue,setInputValue]=useState('');
//   const history = useHistory();

//   const handleSearch = async (event, searchTicker) => {
//     // event.preventDefault();
//     if(searchTicker==""){
//       setErrorMessage('Please enter a ticker');
//       updateStockTicker({ symbol: '', description: '' });
//       updateStockContextData(null);
//       // history.push(`/search/home`);
//       // history.go(`/search/home`);

//       return 
//     }
//     console.log("e target",event.target.value);
//     console.log("search ticker", searchTicker)
//     // if(searchTicker==undefined){
//     //   searchTicker=ticker.symbol
//     // }
//     const uppercaseValue = searchTicker.toUpperCase();
//     console.log("search ticker2", searchTicker)
//     try {
//       setLoading(true);
//       if(uppercaseValue){
//       const response = await axios.get(`/search/exists/${uppercaseValue}`);
//       console.log("res",response.data)
//       if (response.data.ticker) {
//         updateStockTicker({ symbol: uppercaseValue, description: '' });
//         setErrorMessage('');
//         updateStockFound(true);
//         // history.push(`/search/${uppercaseValue}`);
//         // history.go(`/search/${uppercaseValue}`);
//       }
//       else {
//         setErrorMessage('No data found! Please enter a valid ticker');
//         updateStockFound(false)
//         updateStockTicker({ symbol: '', description: '' });
//       updateStockContextData(null);
//     // history.push(`/search/home`);
//     // history.go(`/search/home`);
//         // updateStockTicker({ symbol: '', description: '' });
//         // history.push(`/search/${uppercaseValue}`);
//         // history.go(`/search/${uppercaseValue}`);
//       } 
//     }
//       else {
//         setErrorMessage('Please enter a valid ticker');
//         updateStockTicker({ symbol: '', description: '' });
//         // history.push(`/search/${uppercaseValue}`);
//         // history.go(`/search/${uppercaseValue}`);
//       }
      
//     } catch (error) {
//       console.error('Error fetching stock data:', error);
//       setErrorMessage('Failed to fetch stock data. Please try again.');
//     } finally {
//       setLoading(false);
//     }
//   };

//   const handleInputChange = async (value) => {
//     setLoading(true);
//     // event.preventDefault();
//     const uppercaseValue = value.toUpperCase();
//     console.log("handle input",uppercaseValue)
//     try {
      
//       const response = await axios.get(`/suggestions/${uppercaseValue}`);
//       console.log("Hand",response)
//       if (response.data.count !== 0) {
//         const filteredData = response.data.result.filter(item => item.type === 'Common Stock' && !item.symbol.includes('.'));
//         const data = filteredData.map(item => ({ symbol: item.symbol, description: item.description }));
//         setSuggestions(data);
//       } else {
//         setSuggestions([]);
//         // setErrorMessage('No data found. Please enter a valid ticker.');
//       }
//     } catch (error) {
//       console.error('Error fetching suggestions:', error);
//       // updateStockTicker({ symbol: '', description: '' });
//     } finally {
//       setLoading(false);
//     }
//   };

//   useEffect(()=>{
//     handleInputChange(inputValue)

//   },[inputValue])

//   useEffect(() => {
    
//     if(tickerResult!=""){
//       setTicker({ symbol: tickerResult, description:'' });
//       updateStockTicker({ symbol: tickerResult, description:'' })
//     }
//     else{
//     setTicker({ symbol: stockTicker?.symbol, description: stockTicker?.description } || { symbol: '', description: '' });
//     }
    
//   }, [tickerResult,errorMessage]);

//   const handleSuggestionClick = async(selectedSuggestion) => {
//     console.log("Selected suggestion",selectedSuggestion)
//     setTicker(selectedSuggestion);
//     updateStockTicker(selectedSuggestion);

//     try {
//       setLoading(true);
//       const response = await axios.get(`/search/exists/${selectedSuggestion.symbol}`);
//       console.log("res",response.data)
//       if (response.data.ticker) {
//         history.push(`/search/${selectedSuggestion.symbol.toUpperCase()}`);
//         history.go(`/search/${selectedSuggestion.symbol.toUpperCase()}`);
//       } else {
//         setErrorMessage('Please enter a valid ticker');
//       }
//     } catch (error) {
//       console.error('Error fetching stock data:', error);
//       // setErrorMessage('Failed to fetch stock data. Please try again.');
//     } finally {
//       setLoading(false);
//     }
//   };

//   const handleClear = () => {
//     setTicker({ symbol: '', description: '' });
//     updateStockTicker({ symbol: '', description: '' });
//     updateStockContextData(null);
//     setSuggestions([]);
//     history.push('/search/home');
//     history.go('/search/home');
//   };

//   const getOptionLabel = (option) => {
//     if (!option) {
//       return '';
//     }
//     return option.symbol ? `${option.symbol} | ${option.description}` : '';
//   };

//   return (
//     <div style={{ marginTop: '30px' }}>
//       <h2 style={{ textAlign: 'center' }}>STOCK SEARCH</h2>
//       <div >
//         <div style={{ display: 'flex', alignItems: 'center', padding: '5px', justifyContent: 'center' }}>
//           <Autocomplete
//             freeSolo
//             noOptionsText={<></>}
//             value={ticker}
//             onChange={(event, value) => {
//               // event.preventDefault();
//               if (value && value.symbol) {
//                 handleSuggestionClick(value);
//               }
//             }}
//             onInputChange={(event,value)=>{setInputValue(value)}}
//             autoSelect={true}
//             disableClearable
//             disableListWrap
//             options={suggestions}
//             loading={loading}
//             loadingText={<Spinner animation="border" variant="primary" />}
//             istionEqualToValue={(option, value) => option.symbol === value.symbol}
//             getOptionLabel={getOptionLabel}
//             renderInput={(params) => (
//               <form 
//               onSubmit={(event) => {
//                 console.log("Submit",event.target.value)
//                 handleSearch(event, params.inputProps.value);
//               }}>
//                 <TextField
//                   {...params}
//                   color="primary"
//                   placeholder="Enter stock ticker symbol"
//                   fullWidth
//                   // onChange={(event) => handleInputChange(event, event.target.value)}
//                   InputProps={{
//                     ...params.InputProps,
//                     disableUnderline: true,
                  //   sx: {
                  //     borderRadius: '50px',
                  //     borderColor: '#1d259a',
                  //     '& .MuiSvgIcon-root': {
                  //       fontSize: '30px',
                  //       color: '#1d259a',
                  //       cursor: 'pointer',
                  //       marginRight: '0px',
                  //     },
                  //     '& .MuiAutocomplete-inputRoot': {
                  //       borderRadius: '50px',
                  //       borderColor: '#1d259a',
                  //       borderWidth: '1px',
                  //       borderStyle: 'solid',
                  //     },
                  //     '& .MuiOutlinedInput-notchedOutline':{
                  //       borderColor: '#1d259a',
                  //       borderWidth: '2px',
                  //       borderStyle: 'solid',
                  //       borderRadius:'30px'
                  //     },
                  //     '& input': {
                  //       fontSize: '16px',
                  //       borderColor: '#1d259a'
                  //     },
                  //   },
                  //   endAdornment: (
                  //     <div style={{ display: 'flex', alignItems: 'center' }}>
                  //       <SearchIcon style={{ cursor: 'pointer', marginRight: '5px' }} onClick={(event) => handleSearch(event, params.inputProps.value)} />
                  //       <CloseIcon style={{ cursor: 'pointer' }} onClick={handleClear} />
                  //     </div>
                  //   ),
                  // }}
//                 />
//               </form>
//             )}
//           />
//           <div>
           
//            </div>
           
//         </div>
//         <div style={{display:"flex",justifyContent:"center",textAlign:"center",width:"100%"}}>
//         {errorMessage && <Alert variant="danger" dismissible>{errorMessage}</Alert>}
//         </div>
        
//       </div>
      
     
//     </div>
//   );
// }

// export default SearchBar;

import React, { useState, useEffect, useRef,useContext } from 'react';
import { useHistory } from 'react-router-dom';
import Alert from 'react-bootstrap/Alert';
import Spinner from 'react-bootstrap/Spinner';
import axios from '../../utils/api.js';
import DataContext from '../../DataContext';
import SearchIcon from '@mui/icons-material/Search';
import CloseIcon from '@mui/icons-material/Close';

let timeout;

function SearchBar({ tickerResult }) {
  const { stockTicker, updateStockTicker,updateStockContextData,updateStockFound,stockFound} = useContext(DataContext);
  const [ticker, setTicker] = useState(stockTicker||'');
  
  const [suggestions, setSuggestions] = useState([]);
  const [loadingSuggestions, setLoadingSuggestions] = useState(false);
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const [notFound,setNotFound]=useState('');
  const history = useHistory();
  const dropdownRef = useRef(null);

  const handleSearch = async () => {
    console.log("search executed",ticker)
    if (!ticker || ticker=="" ) {
      setErrorMessage('Please enter a ticker');
      // setNotFound('Please enter a ticker')
      updateStockFound(false)
      
      return;
    }
  
    try {
      setLoading(true);
      
      const response = await axios.get(`/search/exists/${ticker.toUpperCase()}`);
      if (response.data.ticker) {
        if(stockTicker!=ticker){
          updateStockContextData(null)
        }
        updateStockTicker(ticker)
        updateStockFound(true);
        
        history.push(`/search/${ticker.toUpperCase()}`);
        
      } else {
        setErrorMessage('No data found! Please enter a valid ticker');
        setTicker('')
        updateStockContextData(null)
        updateStockTicker(null)
        updateStockFound(false);
        history.push(`/search/home`);
      }
    } catch (error) {
      console.error('Error fetching stock data:', error);
      setErrorMessage('Failed to fetch stock data. Please try again.');
    } finally {
      setLoading(false);
      setSuggestions([]); // Clear suggestions after form submission
    
    }
  };

useEffect(()=>{
  handleSearch();
},[tickerResult])
  

  const handleInputChange = async (value) => {
    setLoadingSuggestions(true);
    setTicker(value);
    setErrorMessage('');
    if (!value) {
      setSuggestions([]);
      return;
    }

    // Clear previous timeout to avoid multiple requests
  clearTimeout(timeout);

  // Set a new timeout to fetch suggestions after a slight delay
  timeout = setTimeout(async () => {
    try {
      const response = await axios.get(`/suggestions/${value}`);
      if (response.data.count !== 0) {
        const filteredData = response.data.result.filter(
          (item) => item.type === 'Common Stock' && !item.symbol.includes('.')
        );
        setSuggestions(filteredData);
      } else {
        setSuggestions([]);
      }
    } catch (error) {
      console.error('Error fetching suggestions:', error);
    } finally {
      setLoadingSuggestions(false);
    }
  }, 1000); // Ad
  };

  useEffect(()=>{
    setErrorMessage('');
    setSuggestions([])
  },[])

  // useEffect(()=>{
  //   if(!stockFound){
  //     setErrorMessage('No data found! Please enter a valid ticker.')
  //   }
  // },[stockFound])

  const handleClear = () => {
    setTicker('');
    setErrorMessage('');
    setSuggestions([]);
    updateStockContextData(null);
    updateStockTicker(null);
    updateStockFound(false);
    history.push(`/search/home`);
  };

  const handleSubmit = (event) => {
    console.log("Submit clicked")
    event.preventDefault();
    setSuggestions([]);
    handleSearch();
  };

  const handleSuggestionClick = (selectedSymbol) => {

    setTicker(selectedSymbol);
 setSuggestions([]);
    handleSearch();
  };

  const handleDropdownBlur = (event) => {
    // Close dropdown if focus is lost
    if (!event.currentTarget.contains(event.relatedTarget)) {
      setSuggestions([]);
    }
  };



  return (
    <div style={{ marginTop: '30px' }}>
    <h2 style={{ textAlign: 'center' }}>STOCK SEARCH</h2>
    <div className="container">
      <div className="row justify-content-center" style={{padding:'10px'}}>
        <div className='col-12 col-md-9' style={{border:'solid',borderColor:'#1d259a',borderRadius:'30px', display:'flex' }}>
          <form onSubmit={handleSubmit} style={{width:'100%',outline:'none !important',boxShadow:'none !important'}}>
            <div style={{ position: 'relative', padding: '8px',display:'flex' }} onBlur={handleDropdownBlur}>
              <input
                type="text"
                className="rounded autocomplete-input"
                placeholder={tickerResult||"Enter stock ticker symbol"}
                value={ticker}
                style={{ border: 'solid #1d259a', borderRadius: '30px', padding: '8px', width: '100%', border: 'none',outline: 'none !important',boxShadow: 'none !important' }}
                onChange={(e) => handleInputChange(e.target.value)}
                onFocus={(e) => e.target.style.outline = 'none'}
              />
            <div className="dropdown" ref={dropdownRef} style={{ position: 'absolute', top: '100%', width: '100%', }}>
  {loadingSuggestions && (
    <div className="dropdown-menu show" style={{ width: '80%', padding: '15px', maxHeight: '300px', overflowY: 'auto' }}>
      <Spinner animation="border" variant="primary" />
    </div>
  )}
  {!loadingSuggestions && suggestions.length > 0 && (
    <div className="dropdown-menu show" style={{ width: '80%', padding: '15px' ,maxHeight: '300px', overflowY: 'auto'}}>
      {suggestions.map((item) => (
        <button
          key={item.symbol}
          className="dropdown-item"
          type="button"
          onClick={() => handleSuggestionClick(item.symbol)}
        >
          {item.symbol} | {item.description}
        </button>
      ))}
    </div>
  )}
</div>
              <div className='d-flex'>
              <button className="custom-button" type="submit" style={{border:'none',backgroundColor:'white',color:'#1d259a'}}>
                <SearchIcon style={{ cursor: 'pointer', marginRight: '5px' }} />
              </button>
              <button type="button"  onClick={handleClear} className="custom-button" style={{border:'none',backgroundColor:'white',color:'#1d259a'}}>
                <CloseIcon style={{ cursor: 'pointer' }} />
              </button>
              </div>
            </div>
           
          </form>
        </div>
       
      </div>
      <div className='container mt-6' >
        {/* {!stockFound && <Alert variant="danger" dismissible>No data found! Please enter a valid ticker.</Alert>} */}
        {!stockFound && errorMessage && <Alert variant="danger" dismissible>{errorMessage}</Alert>}
        </div>
    </div>
  </div>

  );
}

export default SearchBar;





