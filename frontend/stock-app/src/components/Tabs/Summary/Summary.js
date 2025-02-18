import React, { useEffect, useState, useContext } from 'react';
import axios from '../../../utils/api.js';
import Highcharts, { chart } from 'highcharts';
import HighchartsReact from 'highcharts-react-official';
import Grid from '@mui/material/Grid';
import DataContext from '../../../DataContext';


const Summary = ({  marketStatus, peersData, quoteData, profileData  }) => {
  const { chartContextData, updateChartContextData } = useContext(DataContext);

    const [chartData, setChartData] = useState(null);


    useEffect(()=>{
      if(chartContextData){
        setChartData(chartContextData);
      }
    },[chartContextData])
    useEffect(() => {
        const fetchHistoricalData = async () => {
          try {
            const currentDate = new Date();
            let from, to;
            if (marketStatus === 'Open') {
                
                const yesterday = new Date(currentDate);
                yesterday.setDate(yesterday.getDate() - 1);
                from = formatDate(yesterday);
                to = formatDate(currentDate);
              } else {
               
                const closingDate = new Date(quoteData.t * 1000); 
                const dayBeforeClosing = new Date(closingDate);
                dayBeforeClosing.setDate(dayBeforeClosing.getDate() - 1);
                from = formatDate(dayBeforeClosing);
                to = formatDate(closingDate);
              }
              console.log("From",from)
              console.log("To",to)
      
            console.log(profileData);
            const response = await axios.get(`/stocks/historical-data/${profileData.ticker}?from=${from}&to=${to}`);
            console.log("response",response)
            const responseData = response.data;
      
            
            const filteredData = responseData.filter(data => {
              const dataDate = new Date(data.t);
              console.log("datadate",dataDate)
              const timeDifference = Math.abs(currentDate - dataDate) / (1000 * 60 * 60); 
            console.log("time differ",timeDifference)
              
              return marketStatus === 'Open' ? timeDifference <= 6 : true;
            });
            console.log("hour data",responseData);
            console.log("6 hour data",filteredData)
            let hourData;
            if(marketStatus=='Open'){
                hourData=responseData
            }
            else{
            hourData=filteredData
            }
      
            
            const chartData = hourData.map(data => ({
              x: new Date(data.t),
              y: data.c 
            }));
            console.log("chartData",chartData)
            setChartData(chartData);
            updateChartContextData(chartData)
          } catch (error) {
            console.error('Error fetching historical data:', error);
          }
        };
      
        fetchHistoricalData();
      }, [profileData.ticker, profileData.pc, profileData.t, marketStatus]);
      
      const formatDate = (date) => {
        if (!(date instanceof Date && !isNaN(date))) {
          throw new Error('Invalid date');
        }
      
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
      };
      
      
  
      const options = {
        chart: {
          type: 'line',
          // height: 250, // Set this to the desired height
          backgroundColor: '#f8f8f8'
        },
        title: {
          text: `${profileData.ticker} Hourly Price Variation`,
          align: 'center',
          style: {
            color: '#333333', 
            fontSize: '16px' 
          }
        },
        xAxis: {
          type: 'datetime',
          labels: {
            format: '{value:%H:%M}', 
          }
        },
        yAxis: {
          title: {
            text: ''
          },
          opposite: true 
        },
        legend: {
          enabled: false
        },
        series: [
          {
            data: chartData,
            name: 'Price',
            showInLegend: false, 
            marker: {
              enabled: false
            },
            color: quoteData.d > 0 ? 'green' : 'red'
          }
        ],
        tooltip: {
          valueDecimals: 2 
        },
        credits: {
          enabled: false 
        }
      };
  console.log("summary",{ marketStatus, peersData, quoteData, profileData })

console.log("Peers Data:");
peersData.map(peer => console.log(peer));
  return (
<Grid container spacing={2} justifyContent="center">
      <Grid item xs={12} md={6} sx={{ textAlign: { xs: 'center', md: 'left' } }}>
        <div>
          <p style={{ margin: 5 }}><strong>High Price:</strong> {quoteData?.h}</p>
          <p style={{ margin: 5 }}><strong>Low Price:</strong> {quoteData?.l}</p>
          <p style={{ margin: 5 }}><strong>Open Price:</strong> {quoteData?.o}</p>
          <p style={{ margin: 5 }}><strong>Prev. Close:</strong> {quoteData?.pc}</p>
        </div>
        <div className='text-center' style={{ marginTop:"20px"}}>
          <h5 style={{ textDecoration: 'underline'}}>About the Company</h5>
          <p><strong>IPO Start Date:</strong> {profileData?.ipo}</p>
          <p><strong>Industry:</strong> {profileData?.finnhubIndustry}</p>
          <p><strong>Webpage:</strong> <a href={profileData?.weburl} target="_blank">{profileData?.weburl}</a></p>
          <p><strong>Company Peers:</strong></p>
          {peersData && peersData.length > 0 ? (
            <p>
              {peersData.filter(peer => !peer.includes('.')).map((peer, index, array) => (
                <span key={index}>
                  <a href={`/search/${peer}`} >{peer}</a>
                  {index !== array.length - 1 && ', '}
                </span>
              ))}
            </p>
          ) : (
            <p>No company peers available</p>
          )}
        </div>
      </Grid>
      <Grid item xs={12} md={6} style={{ paddingLeft: 0 }}>
        <HighchartsReact highcharts={Highcharts} options={options} />
      </Grid>
    </Grid>
     
  );
}

export default Summary;
