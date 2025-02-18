////
////  StockDetailView.swift
////  stock-app
////
////  Created by Varun Mehta on 13/04/24.
////
//
//import SwiftUI
//import Kingfisher
//import WebKit
//
//struct StockDetailView: View {
//    @ObservedObject var viewModel: StockDetailViewModel
//    
//    // Load HTML files
//            let earningsChartURL = Bundle.main.url(forResource: "earningsChart", withExtension: "html", subdirectory: "WebResources")
//            let recommendationsChartURL = Bundle.main.url(forResource: "recommendationsChart", withExtension: "html", subdirectory: "WebResources")
//    
//    
//    var body: some View {
//        VStack {
//            if viewModel.isLoading {
//                ProgressView()
//            } else {
//                ScrollView {
//                    Text(viewModel.stockData?.profileData.name ?? "")
//                    
//                    // Display company logo using Kingfisher
//                    if let logoURLString = viewModel.stockData?.profileData.logo,
//                       let logoURL = URL(string: logoURLString) {
//                        KFImage(logoURL)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100, height: 100)
//                            .cornerRadius(10)
//                    }
//                    
//                    Text("Current Price: \(viewModel.stockData?.quoteData.c.description ?? "")")
//                    Text("Change Price: \(viewModel.stockData?.quoteData.d.description ?? "")")
//                    Text("Change Percentage: \(viewModel.stockData?.quoteData.dp.description ?? "")")
//                    
//// Stats section
//                    StatsView(stockData: viewModel.stockData)
//                        .padding()
//                    
//                    // About section
//                    AboutView(stockData: viewModel.stockData)
//                        .padding()
//
//                    PortfolioDetailView(stockData: viewModel.stockData)
//                    
//                    if let sentimentData = viewModel.stockData?.sentimentData {
//                                            InsiderSentimentTableView(sentimentData: sentimentData)
//                                                .padding()
//                    }
//                    
//                    if let earningsChartURL = Bundle.main.url(forResource: "earningsChart", withExtension: "html", subdirectory: "WebResources") {
//                                            HTMLView(url: earningsChartURL)
//                                                .frame(height: 300) // Adjust the height as needed
//                                                .padding()
//                                        }
//
//                                        // Recommendations Chart
//                                        if let recommendationsChartURL = Bundle.main.url(forResource: "recommendationsChart", withExtension: "html", subdirectory: "WebResources") {
//                                            HTMLView(url: recommendationsChartURL)
//                                                .frame(height: 300) // Adjust the height as needed
//                                                .padding()
//                                        }
//                    
//                    NewsDetailSectionView(newsData: viewModel.stockData?.newsData ?? NewsItem.dummyData)
//                }
//            }
//        }
//        .onAppear {
//            if let ticker = viewModel.ticker {
//                viewModel.searchForTicker(ticker)
//            }
//        }
//        .navigationBarTitle(viewModel.ticker ?? "Stock Detail") // Use ticker as title if available
//        .navigationBarItems(trailing: favoriteButton)
//    }
//    
//    var favoriteButton: some View {
//        Button(action: {
//            viewModel.toggleFavorite()
//        }) {
//            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
//        }
//    }
//}
//
//// Custom HTMLView to load and display HTML content

//struct HTMLView: UIViewRepresentable {
//    let url: URL
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.load(URLRequest(url: url))
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        // Update the view if needed
//    }
//}
//
//struct StockDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        StockDetailView(viewModel: StockDetailViewModel())
//    }
//}

import SwiftUI
import Kingfisher
import WebKit

struct StockDetailView: View {
    let symbol: String
    @ObservedObject var viewModel: StockDetailViewModel // Add observed object
    @ObservedObject var portfolioviewModel = PortfolioSectionViewModel()
    @ObservedObject var searchViewModel = SearchBarViewModel()
    // Load HTML files
    @State private var selectedChartType = 0
    @State private var isShowingToast = false
    @State private var toastMessage = ""

    
    
    init(symbol: String) {
        self.symbol = symbol
        self.viewModel = StockDetailViewModel() // Initialize view model with the symbol
        searchViewModel.clearSuggestions()
    }
    
    var body: some View {
            VStack {
//                if isShowingToast {
//                        ToastView(message: toastMessage)
//                            .transition(.move(edge: .bottom)) // Slide down animation
//                    }
                if let stockData = viewModel.stockData {
                    if viewModel.isLoading {
                        ProgressView("Fetching Data")
                    } else {
                        ScrollView {
                            HStack {
                                Text(stockData.profileData.name)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                KFImage(URL(string: stockData.profileData.logo))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                            }.padding(.bottom, 5)
                            // Display company logo using Kingfisher
                            
                               

                            
                            HStack {
                                //                                Text("$\(String(format: "%.2f", viewModel.currentPrice))")
                                //                                    .font(.title)
                                //                                    .fontWeight(.bold)
                                if let currentPrice = viewModel.currentPrice {
                                    Text("$\(String(format: "%.2f", currentPrice))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                } else {
                                    Text("$\(String(format: "%.2f", stockData.quoteData.c))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                
                                if let currentDifference = viewModel.currentDifference,
                                   let currentDifferencePercentage = viewModel.currentDifferencePercentage {
                                    HStack {
                                        Image(systemName: currentDifference < 0 ? "arrow.down.right" : (currentDifference > 0 ? "arrow.up.right" : "minus"))
                                            .foregroundColor(currentDifference < 0 ? .red : (currentDifference > 0 ? .green : .gray))
                                        Text("$\(String(format: "%.2f", currentDifference)) (\(String(format: "%.2f", currentDifferencePercentage))%)")
                                            .font(.title3)
                                            .foregroundColor(currentDifference < 0 ? .red : (currentDifference > 0 ? .green : .gray))
                                        
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: stockData.quoteData.d < 0 ? "arrow.down.right" : (stockData.quoteData.d > 0 ? "arrow.up.right" : "minus"))
                                            .foregroundColor(stockData.quoteData.d < 0 ? .red : (stockData.quoteData.d > 0 ? .green : .gray))
                                        Text("$\(String(format: "%.2f", stockData.quoteData.d)) (\(String(format: "%.2f", stockData.quoteData.dp))%)")
                                            .font(.title3)
                                            .foregroundColor(stockData.quoteData.d < 0 ? .red : (stockData.quoteData.d > 0 ? .green : .gray))
                                        
                                    }
                                }
                                Spacer()
                            }
                            Section{
                                TabView{
                                    generateWebView2(difference:stockData.quoteData.d).tabItem {
                                        VStack{
                                            Image(systemName: "chart.xyaxis.line")
                                            Text("Hourly")
                                        }
                                        }
                                    generateWebView() .tabItem {
                                        VStack{
                                            Image(systemName: "clock.fill")
                                            Text("Historical")
                                        }
                                    }
                                                                                        
                                                                                    
                                }.padding([.leading, .bottom, .trailing], 1).frame(height:475)
                            }.padding(.top,-10)
                           
                            

//                                Spacer()
//                                if stockData.quoteData.d>0 {
//                                    Image(systemName: "arrow.up.right")
//                                        .foregroundColor(.green)
//                                } else if stockData.quoteData.d < 0 {
//                                    Image(systemName: "arrow.down.right")
//                                        .foregroundColor(.red)
//                                }
//                                else{
//                                    Image(systemName: "minus")
//                                        .foregroundColor(.gray)
//                                }
////                                Spacer()
//                                Text("$\(String(format: "%.2f", stockData.quoteData.d)) (\(String(format: "%.2f", stockData.quoteData.dp))%)")
//                                    .font(.title3)
//                                    .foregroundColor(stockData.quoteData.d < 0 ? .red : (stockData.quoteData.d > 0 ? .green : .gray))
//                                Spacer()
//                            }.padding(.bottom, 5)
                            
//                            TabView {
//                                if let historicalDataResponse = viewModel.chartDataResponse {
//                                    if let highChartsHTML = generateHistoricalHTML(historicalDataResponse: historicalDataResponse) {
//                                        WebView(htmlContent: highChartsHTML)
//                                            .frame(width:365,height: 375).tabItem {
//                                                Label("Menu", systemImage: "list.dash")
//                                            }
//                                        
//                                        //                                                                    .padding()
//                                    }
//                                    
//                                    
//                                    if let chartDataResponse = viewModel.historicalDataResponse {
//                                        if let highChartsHTML = generateHighchartsHTML(chartDataResponse: chartDataResponse,stockSymbol:symbol,difference:stockData.quoteData.d) {
//                                            WebView(htmlContent: highChartsHTML)
//                                                .frame(width:365,height: 375)
//                                                .tabItem {
//                                                    Label("Order", systemImage: "square.and.pencil")
//                                                }
//                                            //                                                                    .padding()
//                                        }
//                                        
//                                    }
//                                }
//                            }
                           
//                            // Display selected chart
//                            switch selectedChartType {
//                            case 1:
//                                if let historicalDataResponse = viewModel.chartDataResponse {
//                                    if let highChartsHTML = generateHistoricalHTML(historicalDataResponse: historicalDataResponse) {
//                                        WebView(htmlContent: highChartsHTML)
//                                            .frame(width:365,height: 375)
//                                           
////                                                                    .padding()
//                                    } else {
//                                        Text("Failed to generate HTML for chart data")
//                                    }
//                                } else {
//                                    Text("No chart data available")
//                                }
//                                
//                            case 0:
//                                if let chartDataResponse = viewModel.historicalDataResponse {
//                                    if let highChartsHTML = generateHighchartsHTML(chartDataResponse: chartDataResponse,stockSymbol:symbol,difference:stockData.quoteData.d) {
//                                        WebView(htmlContent: highChartsHTML)
//                                            .frame(width:365,height: 375)
////                                                                    .padding()
//                                    } else {
//                                        Text("Failed to generate HTML for chart data")
//                                    }
//                                } else {
//                                    Text("No chart data available")
//                                }
//                                
//                            default:
//                                Text("Unknown chart type")
//                            }
//    Picker(selection: $selectedChartType, label: Text("Select Chart")) {
//       
//        VStack {
//                Image(systemName: "chart.xyaxis.line")
//                
//            }
//            .tag(0)
//            
//            VStack {
//                Image(systemName: "clock")
//                
//            }
//            .tag(1)
//                   
//               }
//               .pickerStyle(SegmentedPickerStyle())
//               .background(Color.white)
//               .padding()
                            
                            
                            
                
                             

  

                            


                            
                            PortfolioDetailView( ticker: stockData.profileData.ticker,companyName: stockData.profileData.name).padding(.bottom, 5)
                            
                            // Stats section
                            StatsView(stockData: stockData).padding(.bottom, 5)
                               
                            
                            // About section
                            AboutView(stockData: stockData).padding(.bottom, 5)
                                

                            
                            
                            
                            InsiderSentimentTableView(sentimentData: stockData.sentimentData,companyName:stockData.profileData.name).padding(.bottom, 5)
                                    
//                            if let earningsChartHTML = generateEarningsChartHTML(stockData: stockData) {
//                                                        WebView(htmlContent: earningsChartHTML)
//                                                            .frame(height: 300)
//                                                            .padding()
//                                                    }
                            if let recommendationsChartHTML = generateRecommendationsChartHTML(stockData: stockData) {
                                            WebView(htmlContent: recommendationsChartHTML)
                                                .frame(height: 380) // Adjust the height as needed
                                                .padding(.bottom, 5)
                                               
                            } else {
                                Text("Failed to load recommendations chart")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
//                           // Display earnings chart using WebKit
                            if let earningsChartHTML = generateEarningsChartHTML(stockData: stockData) {
                                WebView(htmlContent: earningsChartHTML)
                                    .frame(height: 380) // Adjust the height as needed
                                    .padding(.bottom, 5)
                                   
                            } else {
                                Text("Failed to load earnings chart")
                                    .foregroundColor(.red)
                            }
                            
                           
                            
                            
                            // Segmented control for selecting chart type
                            
                                                    
                                                    
//                            TabView {
//                                if let chartDataResponse = viewModel.chartDataResponse {
//                                    if let highChartsHTML = generateHighchartsHTML(chartDataResponse: chartDataResponse) {
//                                        WebView(htmlContent: highChartsHTML)
//                                            .frame(height: 600)
//                                           
//                                            .tabItem {
//                                                Label("Chart", systemImage: "chart.bar")
//                                            }
//                                    } else {
//                                        Text("Failed to generate HTML for chart data")
//                                            .tabItem {
//                                                Label("Chart", systemImage: "chart.bar")
//                                            }
//                                    }
//                                } else {
//                                    Text("No chart data available")
//                                        .tabItem {
//                                            Label("Chart", systemImage: "chart.bar")
//                                        }
//                                }
//                                
//                                if let historicalDataResponse = viewModel.historicalDataResponse {
//                                    if let highChartsHTML = generateHistoricalHTML(historicalDataResponse: historicalDataResponse) {
//                                        WebView(htmlContent: highChartsHTML)
//                                            .frame(height: 600)
//                                            
//                                            .tabItem {
//                                                Label("Historical", systemImage: "clock")
//                                            }
//                                    } else {
//                                        Text("Failed to generate HTML for historical data")
//                                            .tabItem {
//                                                Label("Historical", systemImage: "clock")
//                                            }
//                                    }
//                                } else {
//                                    Text("No historical data available")
//                                        .tabItem {
//                                            Label("Historical", systemImage: "clock")
//                                        }
//                                }
//                            }

                            // Recommendations Chart
//                            if let recommendationsChartURL = Bundle.main.url(forResource: "recommendationsChart", withExtension: "html", subdirectory: "WebResources") {
//                                HTMLView(url: recommendationsChartURL)
//                                    .frame(height: 300) // Adjust the height as needed
//                                    .padding()
//                            }
                            
                            NewsDetailSectionView(newsData: stockData.newsData)
                        }
                    }
                } else {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            ProgressView("Fetching Data")
//                                .onAppear {
//                                    viewModel.searchForTicker(symbol)
//                                }
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }

                }
            }.padding()
            .navigationBarTitle(viewModel.isLoading ? "" : symbol) // Display symbol as title
            .navigationBarItems(trailing: viewModel.isLoading ? nil : favoriteButton)
            .toast2(isShowing: $isShowingToast ,text: Text(toastMessage ))
        .onAppear {
            viewModel.searchForTicker(symbol) // Call searchForTicker function when view appears
            viewModel.checkInFavorite(symbol)
            searchViewModel.clearSuggestions()
            // Check if stockData is available
//                if let stockData = viewModel.stockData {
//                    // Check market status before calling startFetchingCurrentPrice
//                    let marketStatus = viewModel.isMarketOpen(lastPriceStamp: TimeInterval(stockData.quoteData.t))
//                    if marketStatus == "Open" {
                        viewModel.startFetchingCurrentPrice(symbol)
//                    }
//               }
            
            
        }
        .onDisappear{
        // Call this function to stop the timer
            viewModel.stopFetchingCurrentPrice()
        }
    }
    var favoriteButton: some View {
           Button(action: {
               let message = viewModel.isFavorite ? "Removed from watchlist" : "Adding \(self.symbol) to Favorites"
                       showToast(message: message)
               viewModel.toggleFavorite()
           }) {
               Image(systemName: viewModel.isFavorite ? "plus.circle.fill" : "plus.circle")
           }
    }
    func showToast(message: String) {
        // Set the message and show the toast
        toastMessage = message
        isShowingToast = true
        
        // Hide the toast after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowingToast = false
        }
    }
    
    func generateRecommendationsChartHTML(stockData: StockData) -> String? {
        guard let recommendationData = stockData.recommendationData else {
            return nil
        }
        // Extract and format data for Highcharts
        let categories = recommendationData.map { $0.period.prefix(7) }
        let seriesData: [[String: Any]] = [
            ["name": "Strong Buy", "data": recommendationData.map { $0.strongBuy }, "color": "#195f31"], // Green
            ["name": "Buy", "data": recommendationData.map { $0.buy }, "color": "#25af50"], // Dark green
            ["name": "Hold", "data": recommendationData.map { $0.hold }, "color": "#b07d27"], // Blue
            ["name": "Sell", "data": recommendationData.map { $0.sell }, "color": "#f05050"], // Red
            ["name": "Strong Sell", "data": recommendationData.map { $0.strongSell }, "color": "#732828"] // Orange
        ]

        // Constructing Highcharts configuration options
        let options: [String: Any] = [
            "chart": ["type": "column", "backgroundColor": "white"],
            "title": ["text": "Recommendation Trends"],
            "xAxis": ["categories": categories],
            "yAxis": ["min": 0, "title": ["text": "# Analysts"]],
            "legend": ["align": "center", "verticalAlign": "bottom", "layout": "horizontal"],
            "tooltip": ["headerFormat": "<b>{point.x}</b><br/>", "pointFormat": "{series.name}: {point.y}<br/>Total: {point.stackTotal}"],
            "plotOptions": ["column": ["stacking": "normal", "dataLabels": ["enabled": true]]],
            "series": seriesData
        ]

        // Convert the options dictionary to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: options) else {
            return nil
        }

        // Convert JSON data to a string
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }

        // HTML content for rendering Highcharts using HighchartsReact component
        let htmlContent = """
                     <!DOCTYPE html>
                     <html lang="en">
                     <head>
                         <meta charset="UTF-8">
                         <meta name="viewport" content="width=device-width, initial-scale=1.0">
                         <title>Recommendations Chart</title>
                         <script src="https://code.highcharts.com/highcharts.js"></script>
                         <script src="https://code.highcharts.com/modules/exporting.js"></script>
                         <script src="https://code.highcharts.com/modules/export-data.js"></script>
                     </head>
                     <body>
            <div id="recommendationsChartContainer" style=" max-height: 380px; height:100%; width: 365px;margin: 0 auto"></div>
            <script src="https://code.highcharts.com/highcharts.js"></script>
            <script src="https://code.highcharts.com/modules/exporting.js"></script>
            <script src="https://code.highcharts.com/modules/export-data.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const options = \(jsonString);
                    Highcharts.chart('recommendationsChartContainer', options);
                });
            </script>
                     </body>
                     </html>
        """

        return htmlContent
    }
  
    func generateHistoricalHTML(historicalDataResponse: ChartDataResponse?) -> String? {
        guard let historicalDataResponse = historicalDataResponse else {
            // Return nil if chartDataResponse is nil
            return nil
        }

        var ohlcData = ""
        var volumeData = ""

        for data in historicalDataResponse.chartData {
            ohlcData += "[\(data.t), \(data.o), \(data.h), \(data.l), \(data.c)],"
            volumeData += "[\(data.t), \(data.v)],"
        }

        ohlcData = String(ohlcData.dropLast()) // Remove trailing comma
        volumeData = String(volumeData.dropLast()) // Remove trailing comma
        let groupingUnits = """
        [
            ['week', [1]],
            ['month', [1, 2, 3, 4, 6]]
        ]
       """

        let html = """
      <!DOCTYPE html>
      <html>
      <head>
                         <meta charset="UTF-8">
                         <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Chart</title>
          <script src="https://code.highcharts.com/stock/highstock.js"></script>
          <script src="https://code.highcharts.com/stock/modules/drag-panes.js"></script>
          <script src="https://code.highcharts.com/stock/modules/exporting.js"></script>
          <script src="https://code.highcharts.com/stock/indicators/indicators.js"></script>
          <script src="https://code.highcharts.com/stock/indicators/volume-by-price.js"></script>
          <script src="https://code.highcharts.com/modules/accessibility.js"></script>
      </head>
      <body>
          <div id="container" style="height: 375px; width: 365px;margin: 0 auto"></div>
          <script>
              var ohlcData = [\(ohlcData)];
              var volumeData = [\(volumeData)];
              var groupingUnits = \(groupingUnits);

              Highcharts.stockChart('container', {
                  rangeSelector: {
                      selected: 2
                  },
                  title: {
                      text: '\(self.symbol) Historical'
                  },
                  subtitle: {
                      text: 'With SMA and Volume by Price technical indicators'
                  },
                  yAxis: [{
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
                  }, {
                      labels: {
                          align: 'right',
                          x: -3
                      },
                      title: {
                          text: 'Volume'
                      },
                      top: '65%',
                      height: '35%',
                      offset: 0,
                      lineWidth: 2
                  }],
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
                  series: [{
                      type: 'candlestick',
                      name: 'AAPL',
                      id: 'aapl',
                      zIndex: 2,
                      data: ohlcData
                  }, {
                      type: 'column',
                      name: 'Volume',
                      id: 'volume',
                      data: volumeData,
                      yAxis: 1
                  }, {
                      type: 'vbp',
                      linkedTo: 'aapl',
                      params: {
                          volumeSeriesID: 'volume'
                      },
                      dataLabels: {
                          enabled: false
                      },
                      zoneLines: {
                          enabled: false
                      }
                  }, {
                      type: 'sma',
                      linkedTo: 'aapl',
                      zIndex: 1,
                      marker: {
                          enabled: false
                      }
                  }]
              });
          </script>
      </body>
      </html>

"""
        ;

                return html
            }
           


    private func generateWebView2(difference:Double) -> some View {
            if let chartDataResponse = viewModel.historicalDataResponse {
                if let highChartsHTML = generateHighchartsHTML(chartDataResponse: chartDataResponse, stockSymbol: symbol, difference: difference) {
                    return AnyView(
                        WebView(htmlContent: highChartsHTML)
                            .frame(width: 365, height: 375)
                            .padding() // Optionally add padding here if needed
                    )
                } else {
                    return AnyView(
                        Text("Failed to generate HTML for chart data")
                    )
                }
            } else {
                return AnyView(
                    Text("No chart data available")
                )
            }
        }


    private func generateWebView() -> some View {
            if let historicalDataResponse = viewModel.chartDataResponse {
                if let highChartsHTML = generateHistoricalHTML(historicalDataResponse: historicalDataResponse) {
                    return AnyView(
                        WebView(htmlContent: highChartsHTML)
                            .frame(width: 365, height: 375)
                            .padding() // Optionally add padding here if needed
                    )
                } else {
                    return AnyView(
                        Text("Failed to generate HTML for chart data")
                    )
                }
            } else {
                return AnyView(
                    Text("No chart data available")
                )
            }
        }
    func generateEarningsChartHTML(stockData: StockData) -> String? {
        guard let earningsData = stockData.earningsData else {
               // Handle the case where earningsData is nil
               return nil
           }
         var actualData = ""
         var estimateData = ""
         
         for item in earningsData {
             actualData += "[\"\(item.period) \(item.surprise)\", \(item.actual)],"
             estimateData += "[\"\(item.period) \(item.surprise)\", \(item.estimate)],"
         }
         
         actualData = String(actualData.dropLast()) // Remove trailing comma
         estimateData = String(estimateData.dropLast()) // Remove trailing comma
         
         return """
             <!DOCTYPE html>
             <html lang="en">
             <head>
                 <meta charset="UTF-8">
                 <meta name="viewport" content="width=device-width, initial-scale=1.0">
                 <title>Earnings Chart</title>
                 <script src="https://code.highcharts.com/highcharts.js"></script>
                 <script src="https://code.highcharts.com/modules/exporting.js"></script>
                 <script src="https://code.highcharts.com/modules/export-data.js"></script>
             </head>
             <body>
                 <div id="earningsChartContainer" style=" max-height: 380px; height:100%; width: 365px;margin: 0 auto"></div>
                 <script>
                     document.addEventListener('DOMContentLoaded', function() {
                         var actualData = [\(actualData)];
                         var estimateData = [\(estimateData)];
                         
                         Highcharts.chart('earningsChartContainer', {
                             chart: {
                                 type: 'spline',
                                backgroundColor: 'white'
                             },
                             title: {
                                 text: 'Historical EPS Surprises'
                             },
                             xAxis: {
                                 type: 'category',
                                 labels: {
                                     useHTML: true,
                                     formatter: function() {
                                         const labelParts = this.value.split(' ');
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
                                 pointFormat: '<span style="color:{point.color}">&#x25CF;</span> {series.name}: <b>{point.y}</b><br/>',
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
                                     data: actualData
                                 },
                                 {
                                     name: 'Estimate',
                                     data: estimateData
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
                         });
                     });
                 </script>
             </body>
             </html>
             """
     }
 }

func generateHighchartsHTML(chartDataResponse: HistoricalDataResponse?,stockSymbol:String?,difference:Double?) -> String? {
    var chartData = ""
    guard let chartDataResponse = chartDataResponse else {
        // Return nil if chartDataResponse is nil
        return nil
    }
    
    guard let stockSymbol = stockSymbol else {
        // Return nil if chartDataResponse is nil
        return nil
    }
    
    for data in chartDataResponse.historicalData {
        chartData += "{ x: \(data.t), y: \(data.c) },"
    }
    
    chartData = String(chartData.dropLast()) // Remove trailing comma
    let html: String
    if let difference = difference{
        html = """
    <html>
    <head>
                                     <meta charset="UTF-8">
                                     <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                     <title>Data Volume Chart</title>
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script type="text/javascript">
            document.addEventListener('DOMContentLoaded', function () {
                Highcharts.chart('container', {
                    chart: {
                        type: 'line',
                       backgroundColor: 'white'
                    },
                    title: {
                        text: '\(stockSymbol) Hourly Price Variation'
                    },
                    xAxis: {
                        type: 'datetime',
                        labels: {
                            format: '{value:%H:%M}'
                        }
                    },
                    yAxis: {
                        title: {
                            text: ''
                        },
                        opposite: true
                    },
                    series: [{
                        data: [\(chartData)],
                        name: 'Price',
                        showInLegend: false,
                        marker: {
                            enabled: false
                        },
                        color: \(difference >= 0 ? "'#4CAF50'" : "'#FF0000'")
                    }],
                    tooltip: {
                        valueDecimals: 2
                    },
                    credits: {
                        enabled: false
                    }
                });
            });
        </script>
    </head>
    <body>
        <div id="container" style="height: 375px; width: 365px" ></div>
    </body>
    </html>
    """
    }
    else{
        html=""
    }
    
    return html
}




 // Custom WebView to display HTML content
struct WebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.loadHTMLString(htmlContent, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to update the view
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(symbol: "AAPL")
    }
}


struct Toast2<Presenting>: View where Presenting: View {

    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text

    var body: some View {

        GeometryReader { geometry in

            ZStack(alignment: .bottom) {

                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)

                VStack {
                    
                    self.text
                }
                .frame(width: geometry.size.width / 1.2,
                       height: geometry.size.height/18
                )
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .transition(.move(edge: .bottom))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                      withAnimation {
                        self.isShowing = false
                       
                      }
                    }
                }
                .opacity(self.isShowing ? 1 : 0)
                .padding(.bottom, 50)
//                .alignmentGuide(.bottom) { _ in UIScreen.main.bounds.height * 0.9 }

            }

        }

    }

}

extension View {

    func toast2(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast2(isShowing: isShowing,
             
              presenting: { self },
              text: text)
    }

}
