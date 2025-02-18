// DataContext.js
import React, { createContext, useState } from 'react';

const DataContext = createContext();

export const DataProvider = ({ children }) => {
  const [stockContextData, setStockContextData] = useState(null);
  const [chartContextData, setChartContextData] = useState(null);
  const [stockFound,setStockFound]=useState(null);
  const [stockTicker, setStockTicker] = useState(null);

  const updateStockContextData = (data) => {
    setStockContextData(data);
  };

  const updateChartContextData = (data) => {
    setChartContextData(data);
  };
  const updateStockTicker = (data) => {
    console.log("context ticker",data)
    setStockTicker(data);
  };
  const updateStockFound = (data) => {
    console.log("context found",data)
    setStockFound(data);
  };

  return (
    <DataContext.Provider value={{ stockContextData, chartContextData, stockTicker, stockFound, updateStockContextData, updateChartContextData,updateStockTicker,updateStockFound }}>
      {children}
    </DataContext.Provider>
  );
};

export default DataContext;
