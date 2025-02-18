//
//  StockDetailViewModel.swift
//  stock-app
//
//  Created by Varun Mehta on 13/04/24.
//

//import Foundation
//import Alamofire
//
//class StockDetailViewModel: ObservableObject {
//    @Published var stockData: StockData?
//    @Published var isLoading = false
//    @Published var isFavorite = true
//    @Published var ticker: String? // Optional ticker property
//
//    func searchForTicker(_ ticker: String) {
//        self.ticker = ticker // Update ticker property
//        isLoading = true // Set isLoading to true when fetching data
//        
//        let today = Date()
//        let toDate = today.isoDateString
//        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
//        let fromDate = oneWeekAgo.isoDateString
//        
//        AF.request("http://localhost:5002/search/\(ticker)?fromNews=\(fromDate)&toNews=\(toDate)")
//            .responseDecodable(of: StockData.self) { [weak self] response in
//                guard let self = self else { return }
//                
//                switch response.result {
//                case .success(let stockData):
//                    // Assign the searchData directly to stockData
//                    self.stockData = stockData
//                    print("Stock Data: \(stockData.profileData)")
//                case .failure(let error):
//                    if let responseData = response.data,
//                                       let responseString = String(data: responseData, encoding: .utf8) {
//                                        print("Response Error: \(responseString)")
//                                    } else {
//                                        print("Error searching for ticker: \(error)")
//                                    }
//                }
//                
//                self.isLoading = false // Set isLoading to false after data is fetched
//            }
//    }
//    
//    func toggleFavorite() {
//        // Implement toggleFavorites function to toggle the favorite status of the stock
//        // Add your implementation here
//    }
//}
//
//
//
//extension Date {
//    var isoDateString: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: self)
//    }
//}

import Foundation
import Alamofire

class StockDetailViewModel: ObservableObject {
    
    @Published var stockData: StockData?
    @Published var isLoading = false
    @Published var isFavorite = true
    @Published var ticker: String? // Optional ticker property
    @Published var symbol: String?
    @Published var historicalDataResponse: HistoricalDataResponse? // Add chartData property
    @Published var chartDataResponse: ChartDataResponse?
    @Published var marketStatus: String = ""
    @Published var currentPrice: Double?
    @Published var currentDifference : Double?
    @Published var currentDifferencePercentage : Double?
    private var timer: Timer?
    
    
    func searchForTicker(_ ticker: String) {
        self.ticker = ticker // Update ticker property
        isLoading = true // Set isLoading to true when fetching data
        
        let today = Date()
        let toDate = today.isoDateString
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let fromDate = oneWeekAgo.isoDateString
        
        AF.request("http://54.189.131.70/api/search/\(ticker)?fromNews=\(fromDate)&toNews=\(toDate)")
            .responseDecodable(of: StockData.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let stockData):
                    // Assign the searchData directly to stockData
                    self.stockData = stockData
                    print("Stock Data: \(stockData.profileData)")
                    self.marketStatus = self.isMarketOpen(lastPriceStamp: TimeInterval(stockData.quoteData.t))
                    self.fetchChartData(for: ticker)
                    self.fetchHistoricalData(for: ticker,closing: TimeInterval(stockData.quoteData.t))
                case .failure(let error):
                    if let responseData = response.data,
                       let responseString = String(data: responseData, encoding: .utf8) {
                        print("Response Error: \(responseString)")
                    } else {
                        print("Error searching for ticker: \(error)")
                    }
                }
                
                self.isLoading = false // Set isLoading to false after data is fetched
            }
    }
    func fetchChartData(for ticker: String) {
        self.ticker = ticker
        let currentDate = Date()
        let twoYearsAgo = Calendar.current.date(byAdding: .year, value: -2, to: currentDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let from = dateFormatter.string(from: twoYearsAgo)
        let to = dateFormatter.string(from: currentDate)
        
        //        let url = "http://localhost:5002/api/stocks/chart-data/AAPL?from=2022-04-27&to=2024-04-27"
        let url =  "http://54.189.131.70/api/stocks/chart-data/\(ticker)?from=\(from)&to=\(to)"
        print("url:\(url)")
        AF.request(url)
            .validate()
            .responseDecodable(of: [ChartData].self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let chartDataArray):
                    let chartDataResponse = ChartDataResponse(chartData: chartDataArray)
                    self.chartDataResponse = chartDataResponse
                    //                        self.chartDataResponse = chartDataArray
                    print("chart Data: \(chartDataResponse)")
                case .failure(let error):
                    print("Error fetching chart data: \(error)")
                }
            }
    }
    
    func fetchHistoricalData(for ticker: String,closing:TimeInterval) {
        self.ticker = ticker
        
        let currentDate = Date()
        var from: String
        var to: String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if marketStatus == "Open" {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            from = dateFormatter.string(from:yesterday)
            to = dateFormatter.string(from:currentDate)
        } else {
            // Use the TimeInterval directly, without trying to create a Date object
            let closingDate = Date(timeIntervalSince1970: closing)
            //                    guard let closingDate = closingDate else {
            //                        print("Error: Unable to get closing date")
            //                        return
            //                    }
            let dayBeforeClosing = Calendar.current.date(byAdding: .day, value: -1, to: closingDate)!
            from = dateFormatter.string(from: dayBeforeClosing)
            to = dateFormatter.string(from: closingDate)
        }
        
        let url = "http://54.189.131.70/api/stocks/historical-data/\(ticker)?from=\(from)&to=\(to)"
        //        let url = "http://localhost:5002/api/stocks/historical-data/AAPL?from=2024-04-25&to=2024-04-26"
        print("Historical url:\(url)")
        AF.request(url)
            .validate()
            .responseDecodable(of: [HistoricalData].self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let historicalDataArray):
                    let historicalDataResponse = HistoricalDataResponse(historicalData: historicalDataArray)
                    self.historicalDataResponse = historicalDataResponse
                    //                        self.chartDataResponse = chartDataArray
                    print("historical Data: \(historicalDataResponse)")
                case .failure(let error):
                    print("Error fetching historical data: \(error)")
                }
            }
        
    }
    
    
    func checkInFavorite(_ symbol: String) {
        self.symbol = symbol
        AF.request("http://54.189.131.70/api/watchlist")
            .responseDecodable(of: [FavoriteItem].self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let watchlistItems):
                    let watchlistSymbols = watchlistItems.map { $0.symbol }
                    self.isFavorite = watchlistSymbols.contains(symbol)
                case .failure(let error):
                    print("Error checking favorite status: \(error)")
                }
            }
    }
    func toggleFavorite() {
        guard let symbol = stockData?.profileData.ticker else {
            print("Ticker symbol is not available")
            return
        }
        
        if isFavorite {
            // If already in favorites, remove it
            let parameters: [String: Any] = ["symbol": symbol]
            AF.request("http://54.189.131.70/api/watchlist/delete",
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default)
            .responseData { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success:
                    print("Successfully removed from favorites")
                    self.isFavorite = false // Update isFavorite
                case .failure(let error):
                    print("Error removing from favorites: \(error)")
                }
            }
        } else {
            // If not in favorites, add it
            guard let stockData = stockData else {
                print("Stock data is not available")
                return
            }
            
            let watchlistItemData: [String: Any] = [
                "symbol": stockData.profileData.ticker,
                "name": stockData.profileData.name,
                "currentPrice": stockData.quoteData.c,
                "difference": stockData.quoteData.d,
                "differencePercentage": stockData.quoteData.dp
            ]
            
            AF.request("http://54.189.131.70/api/watchlist/add",
                       method: .post,
                       parameters: watchlistItemData,
                       encoding: JSONEncoding.default)
            .responseData { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success:
                    print("Successfully added to favorites")
                    self.isFavorite = true // Update isFavorite
                case .failure(let error):
                    print("Error adding to favorites: \(error)")
                }
            }
        }
    }
    func isMarketOpen(lastPriceStamp: TimeInterval) -> String {
        let currentTimestamp = Date().timeIntervalSince1970 * 1000
        let quoteTimestamp = lastPriceStamp * 1000
        let timeDifference = abs(currentTimestamp - quoteTimestamp) / (1000 * 60)
        
        if timeDifference > 5 {
            return "Close"
        } else {
            return "Open"
        }
    }
    func fetchCurrentPrice(for symbol: String, completion: @escaping (Double?, Double?, Double?) -> Void) {
        AF.request("http://54.189.131.70/api/search/currentPrice/\(symbol)")
            .validate()
            .responseDecodable(of: CurrentPriceResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.c, data.d, data.dp)
                case .failure(let error):
                    print("Error fetching current price:", error)
                    completion(nil, nil, nil)
                }
            }
    }
    
    func startFetchingCurrentPrice(_ symbol: String) {
        // Start a timer to fetch current price every 15 seconds
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    self.fetchCurrentPrice(for: symbol) { price, difference, differencePercentage in
                        DispatchQueue.main.async {
                            self.currentPrice = price
                            self.currentDifference = difference
                            self.currentDifferencePercentage = differencePercentage
                        }
                    }
                }
    }
    func stopFetchingCurrentPrice() {
        timer?.invalidate()
    }
}


extension Date {
    var isoDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

