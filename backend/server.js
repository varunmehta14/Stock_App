// // server.js
// const express = require('express');
// const mongoose = require('mongoose');
// const bodyParser = require('body-parser');
// const homeRoute = require('./routes/homeRoutes'); // Update path to homeRoute
// const searchRoute = require('./routes/searchRoutes');
// const watchlistRoute = require('./routes/watchlistRoutes');
// const portfolioRoute = require('./routes/portfolioRoutes');
// const suggestionRoute = require('./routes/suggestionRoutes');
// const walletRoute = require('./routes/walletRoutes');
// const stockRoutes = require('./routes/stockRoutes');
// const cors = require('cors');
// const path=require('path');
// const _dirname=path.dirname("");
// const buildPath=path.join(_dirname,"../frontend/stock-app/build");



// const app = express();
// app.use(express.static(buildPath))
// app.get("/*",function(req,res){
//     res.sendFile(__dirname,"/../frontend/stock-app/build/index.html"),
//     function(err){
//         if(err){
//             res.status(500).send(err);
//         }
//     }
// })
// const PORT = process.env.PORT || 5002;

// const corsOptions = {
//     origin: 'http://localhost:3003'
//   };
  
// // Middleware
// app.use(cors(corsOptions));

// // Connect to MongoDB Atlas
// mongoose.connect('mongodb+srv://varunjay:varunjay14@cluster0.ncfjxz4.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
//   useNewUrlParser: true,
//   useUnifiedTopology: true,
// })
// .then(() => console.log('Connected to MongoDB Atlas'))
// .catch(err => console.error(err));


// app.use(bodyParser.json());
// app.use(bodyParser.urlencoded({ extended: true }));



// // Routes
// app.use('/', homeRoute); // Use homeRoute for the default route
// app.use('/suggestions', suggestionRoute);
// app.use('/search', searchRoute);
// app.use('/watchlist', watchlistRoute);
// app.use('/portfolio', portfolioRoute);
// app.use('/wallet', walletRoute);
// app.use('/stocks', stockRoutes);


// // Error handling middleware
// app.use((err, req, res, next) => {
//   console.error(err.stack);
//   res.status(500).send('Something broke!');
// });

// app.listen(PORT, () => {
//   console.log(`Server is running on port ${PORT}`);
// });



// // app.get("/", (req, res) => {
// //     res.send("Hello, this is the root endpoint!");
// // });

// server.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const homeRoute = require('./routes/homeRoutes'); // Update path to homeRoute
const searchRoute = require('./routes/searchRoutes');
const watchlistRoute = require('./routes/watchlistRoutes');
const portfolioRoute = require('./routes/portfolioRoutes');
const suggestionRoute = require('./routes/suggestionRoutes');
const walletRoute = require('./routes/walletRoutes');
const stockRoutes = require('./routes/stockRoutes');
const https = require('https');
const fs = require('fs');
const cors = require('cors');
const path = require('path');
const _dirname=path.dirname("");
const buildPath=path.join(_dirname,"../frontend/stock-app/build");
var key = fs.readFileSync(path.join(__dirname, 'cert', 'key.pem'));
var cert = fs.readFileSync(path.join(__dirname, 'cert', 'cert.pem'));

var options = {
  key: key,
  cert: cert
};

const app = express();

const PORT = process.env.PORT || 5002;

const corsOptions = {
  origin: ['http://localhost:3000','http://35.92.135.73','http://54.189.131.70','https://elegant-vacherin-7b7543.netlify.app/']

};

// Middleware
app.use(cors(corsOptions));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Connect to MongoDB Atlas
mongoose.connect('mongodb+srv://varunjay:varunjay14@cluster0.ncfjxz4.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Connected to MongoDB Atlas'))
.catch(err => console.error(err));

// Routes
app.use('/api', homeRoute); // Use homeRoute for the default route
app.use('/api/suggestions', suggestionRoute);
app.use('/api/search', searchRoute);
app.use('/api/watchlist', watchlistRoute);
app.use('/api/portfolio', portfolioRoute);
app.use('/api/wallet', walletRoute);
app.use('/api/stocks', stockRoutes);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

// Serve static files from the React build directory
app.use(express.static(buildPath));

app.get("/*", function(req, res){

  res.sendFile(
      path.join(__dirname, "../frontend/stock-app/build/index.html"),
      function (err) {
        if (err) {
          res.status(500).send(err);
        }
      }
    );

})

// Handle all other routes by serving the index.html file
// app.get('*', (req, res) => {
//   res.sendFile(path.join(__dirname, '../frontend/stock-app/build/index.html'));
// });
// var server = https.createServer(options, app);

// server.listen(5003, () => {
//   console.log("server starting on port : " + 5003)
// });

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

