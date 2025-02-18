//
//  StockRowView.swift
//  stock-app
//
//  Created by Varun Mehta on 07/04/24.
//

// StockRowView.swift
//import SwiftUI
//
//struct StockRowView: View {
//    @ObservedObject var viewModel: StockViewModel
//    
//    var body: some View {
//        HStack {
//            Text("Symbol: \(viewModel.symbol)")
//            Text("Market Value: \(viewModel.marketValue)")
//            Text("Change in Price: \(viewModel.changeInPrice)")
//            Text("Total Shares Owned: \(viewModel.totalSharesOwned)")
//        }
//    }
//}
//
//struct StockRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create a Stock object first
//        let stock = Stock(symbol: "AAPL", marketValue: 2000, changeInPrice: 100, totalSharesOwned: 10)
//        // Then, create a StockViewModel instance with the Stock object
//        let stockViewModel = StockViewModel(stock: stock)
//        
//        return StockRowView(viewModel: stockViewModel)
//    }
//}


//import SwiftUI
//import WebKit
//
//struct HighchartsWebView: UIViewRepresentable {
//    let historicalDataResponse: StockDetailViewModel.ChartDataResponse?
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        if let htmlString = generateHistoricalHTML(historicalDataResponse: historicalDataResponse) {
//            webView.loadHTMLString(htmlString, baseURL: nil)
//        }
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {}
//
//    private func generateHistoricalHTML(historicalDataResponse: ChartDataResponse?) -> String? {
//        guard let historicalDataResponse = historicalDataResponse else {
//            // Return nil if chartDataResponse is nil
//            return nil
//        }
//
//        var ohlcData = ""
//        var volumeData = ""
//
//        for data in historicalDataResponse.chartData {
//            ohlcData += "[\(data.t), \(data.o), \(data.h), \(data.l), \(data.c)],"
//            volumeData += "[\(data.t), \(data.v)],"
//        }
//
//        ohlcData = String(ohlcData.dropLast()) // Remove trailing comma
//        volumeData = String(volumeData.dropLast()) // Remove trailing comma
//        let groupingUnits = """
//        [
//            ['week', [1]],
//            ['month', [1, 2, 3, 4, 6]]
//        ]
//        """
//
//        let html = """
//        <html>
//        <head>
//            <meta charset="UTF-8">
//            <meta name="viewport" content="width=device-width, initial-scale=1.0">
//            <title>Data Volume Chart</title>
//            <script src="https://code.highcharts.com/stock/highstock.js"></script>
//            <script src="https://code.highcharts.com/modules/indicators.js"></script>
//            <script src="https://code.highcharts.com/modules/volume-by-price.js"></script>
//            <script src="https://code.highcharts.com/modules/drag-panes.js"></script>
//            <script src="https://code.highcharts.com/modules/data.js"></script>
//            <script src="https://code.highcharts.com/modules/exporting.js"></script>
//            <script src="https://code.highcharts.com/modules/accessibility.js"></script>
//        </head>
//        <body>
//            <div id="container" style="max-height: 375px; height:100%; width: 365px;margin: 0 auto"></div>
//
//            <script type="text/javascript">
//                var ohlcData = [\(ohlcData)];
//                var volumeData = [\(volumeData)];
//                var groupingUnits = \(groupingUnits);
//
//                Highcharts.stockChart('container', {
//                    chart: {
//                        backgroundColor: 'white',
//                        height: '100%'
//                    },
//                    title: {
//                        text: 'Historical Data'
//                    },
//                    yAxis: [{
//                        labels: {
//                            align: 'right',
//                            x: -3
//                        },
//                        title: {
//                            text: 'OHLC'
//                        },
//                        height: '60%',
//                        lineWidth: 2,
//                        resize: {
//                            enabled: true
//                        }
//                    }, {
//                        labels: {
//                            align: 'right',
//                            x: -3
//                        },
//                        title: {
//                            text: 'Volume'
//                        },
//                        top: '65%',
//                        height: '30%',
//                        offset: 0,
//                        lineWidth: 2
//                    }],
//                    tooltip: {
//                        split: true
//                    },
//                    plotOptions: {
//                        series: {
//                            dataGrouping: {
//                                units: groupingUnits
//                            }
//                        }
//                    },
//                    series: [{
//                        type: 'candlestick',
//                        name: 'Stock',
//                        id: 'stock',
//                        zIndex: 2,
//                        data: ohlcData,
//                    }, {
//                        type: 'column',
//                        name: 'Volume',
//                        id: 'volume',
//                        data: volumeData,
//                        yAxis: 1
//                    }, {
//                        type: 'vbp',
//                        linkedTo: 'stock',
//                        params: {
//                            volumeSeriesID: 'volume'
//                        },
//                        dataLabels: {
//                            enabled: false
//                        },
//                        zoneLines: {
//                            enabled: false
//                        }
//                    }, {
//                        type: 'sma',
//                        linkedTo: 'stock',
//                        zIndex: 1,
//                        marker: {
//                            enabled: false
//                        }
//                    }]
//                });
//            </script>
//        </body>
//        </html>
//        """
//
//        return html
//    }
//}
//
//struct ChartDataResponse {
//    let chartData: [ChartData]
//}
//
//struct ChartData {
//    let t: String
//    let o: Double
//    let h: Double
//    let l: Double
//    let c: Double
//    let v: Double
//}
//
//struct HistoricalView: View {
//    let historicalDataResponse = ChartDataResponse(chartData: [
//        ChartData(t: "2022-01-01", o: 100.0, h: 110.0, l: 90.0, c: 105.0, v: 10000.0),
//        ChartData(t: "2022-01-02", o: 105.0, h: 115.0, l: 95.0, c: 110.0, v: 12000.0),
//        ChartData(t: "2022-01-03", o: 110.0, h: 120.0, l: 100.0, c: 115.0, v: 15000.0)
//    ])
//
//    var body: some View {
//        HighchartsWebView(historicalDataResponse: historicalDataResponse)
//    }
//}
//
//struct HistoricalView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoricalView()
//    }
//}
//
//
