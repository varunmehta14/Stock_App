import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';

const RecommendationsChart = ({ recommendationData }) => {
  // Extract and format data for Highcharts
  console.log("recommendation",recommendationData)
  const categories = recommendationData.map(data => data.period.slice(0, 7));
  const seriesData = [
    { name: 'Strong Buy', data: recommendationData.map(data => data.strongBuy), color: '#195f31' }, // Green
    { name: 'Buy', data: recommendationData.map(data => data.buy), color: '#25af50' }, // Dark green
    { name: 'Hold', data: recommendationData.map(data => data.hold), color: '#b07d27' }, // Blue
    { name: 'Sell', data: recommendationData.map(data => data.sell), color: '#f05050' }, // Red
    { name: 'Strong Sell', data: recommendationData.map(data => data.strongSell), color: '#732828' } // Orange
  ];

  // Highcharts configuration options
  const options = {
    chart: {
      type: 'column',
      backgroundColor: '#f8f8f8',
    },
    title: {
      text: 'Recommendation Trends'
    },
    xAxis: {
      categories: categories,
      
    },
    yAxis: {
      min: 0,
      title: {
        text: '# Analysts'
      },
   
    },

    legend: {
        align: 'center',
        verticalAlign: 'bottom',
        layout: 'horizontal'
      },
    
    tooltip: {
      headerFormat: '<b>{point.x}</b><br/>',
      pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
    },
    plotOptions: {
      column: {
        stacking: 'normal',
        dataLabels: {
          enabled: true,
          
        }
      }
    },
    series: seriesData
  };

  return (
    <div>
      <HighchartsReact highcharts={Highcharts} options={options} />
    </div>
  );
};

export default RecommendationsChart;

