
import React, { useEffect } from 'react';
import Highcharts from 'highcharts/highstock';
import Indicators from 'highcharts/indicators/indicators';
import VolumeByPrice from 'highcharts/indicators/volume-by-price';
import DragPanes from 'highcharts/modules/drag-panes';
import Exporting from 'highcharts/modules/exporting';
import Accessibility from 'highcharts/modules/accessibility';
import axios from '../../../utils/api.js';

// Initialize the necessary Highcharts modules
Indicators(Highcharts);
VolumeByPrice(Highcharts);
DragPanes(Highcharts);
Exporting(Highcharts);
Accessibility(Highcharts);

const Charts = ({ticker}) => {
  useEffect(() => {
    const fetchData = async () => {
      try {
        const currentDate = new Date();
        const from = new Date(currentDate);
        from.setFullYear(from.getFullYear() - 2); // 2 years back
        const to = currentDate;
        
        console.log("From", from.toISOString().split('T')[0]); // Log the from date
        console.log("To", to.toISOString().split('T')[0]); 
      
           
            const response = await axios.get(`/stocks/chart-data/${ticker}?from=${from.toISOString().split('T')[0]}&to=${to.toISOString().split('T')[0]}`);
            console.log("response",response)
            const responseData = response.data;
      

        const ohlc = [],
          volume = [],
          dataLength = responseData.length,
          groupingUnits = [
            ['week', [1]],
            ['month', [1, 2, 3, 4, 6]]
          ];

          responseData.forEach(data => {
            ohlc.push([
              data.t, // the date
              data.o, // open
              data.h, // high
              data.l, // low
              data.c // close
            ]);
      
            volume.push([
              data.t, // the date
              data.v // the volume
            ]);
          });

        const options = { 
          chart: {
            backgroundColor: '#f8f8f8',
            height: 600,
          },

          rangeSelector: {
            selected: 2
          },
          title: {
            text: `${ticker} Historical `
          },
          subtitle: {
            text: 'With SMA and Volume by Price technical indicators'
          },
          yAxis: [
            {
              startOnTick: false,
              endOnTick: false,
              labels: {
                align: 'right',
                x: -3
              },
              title: {
                text: 'OHLC'
              },
              height: '60%',
              lineWidth: 2,
              resize: {
                enabled: true
              }
            },
            {
              labels: {
                align: 'right',
                x: -3
              },
              title: {
                text: 'Volume'
              },
              top: '65%',
              height: '30%',
              offset: 0,
              lineWidth: 2
            }
          ],
          tooltip: {
            split: true
          },
          plotOptions: {
            series: {
              dataGrouping: {
                units: groupingUnits
              }
            }
          },
          series: [
            {
              type: 'candlestick',
              name: `${ticker}`,
              id: `${ticker}`,
              zIndex: 2,
              data: ohlc
            },
            {
              type: 'column',
              name: 'Volume',
              id: 'volume',
              data: volume,
              yAxis: 1
            },
            {
              type: 'vbp',
              linkedTo: `${ticker}`,
              params: {
                volumeSeriesID: 'volume'
              },
              dataLabels: {
                enabled: false
              },
              zoneLines: {
                enabled: false
              }
            },
            {
              type: 'sma',
              linkedTo: `${ticker}`,
              zIndex: 1,
              marker: {
                enabled: false
              }
            }
          ]
        };

        Highcharts.stockChart('container', options);
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    };

    fetchData();
  }, []);

  return <div id="container"></div>;
};

export default Charts;
