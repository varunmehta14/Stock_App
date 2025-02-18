// frontend/src/utils/api.js

import axios from 'axios';

const instance = axios.create({
  // baseURL: 'http://35.92.135.73/api', // Assuming your backend is running on port 5000
  // baseURL:'http://localhost:5002/api',
  baseURL: 'http://54.189.131.70/api',
  
  headers: {
    'Content-Type': 'application/json',
    // 'Access-Control-Allow-Origin': 'http://localhost:3001', 
    
  },

});

export default instance;