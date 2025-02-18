import React from 'react';
import Highcharts from 'highcharts/highstock';
import HighchartsReact from 'highcharts-react-official';

const EarningsChart = ({ earningsData }) => {
  // Extracting data for actual and estimate series
  const actualData = earningsData.map(data => [`${data.period} ${data.surprise}`, data.actual]);
  const estimateData = earningsData.map(data => [`${data.period} ${data.surprise}`, data.estimate]);

  // Chart options for earnings chart
  const earningsChartOptions = {
    
    chart: {
      type: 'spline',
      backgroundColor: '#f8f8f8',
    },
    title: {
      text: 'Historical EPS Surprises'
    },
    xAxis: {
      type: 'category',
      labels: {
        useHTML: true, // Enable HTML in labels to use line break
        formatter: function() {
          const labelParts = this.value.split(' ');
          // Return the formatted label with the surprise on a new line
          return `<div style="text-align: center;">${labelParts[0]}<br/><span >Surprise:</span> ${labelParts[1]}</div>`;
        }
      }
    },
    yAxis: {
      title: {
        text: 'Quarterly EPS'
      }
    },
    tooltip: {
      pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y}</b><br/>',
      valueSuffix: ' ',
      shared: true
    },
    plotOptions: {
      series: {
        label: {
          connectorAllowed: false
        },
        marker: {
          enabled: true,
          symbol: 'circle',
          radius: 3
        }
      }
    },
    series: [
      {
        name: 'Actual',
        data: actualData // Ensure actualData is defined properly
      },
      {
        name: 'Estimate',
        data: estimateData // Ensure estimateData is defined properly
      }
    ],
    credits: {
      enabled: false
    },
    legend: {
      layout: 'horizontal',
      align: 'center',
      verticalAlign: 'bottom'
    }
  };

  return <HighchartsReact highcharts={Highcharts} options={earningsChartOptions} />;
};

export default EarningsChart;

