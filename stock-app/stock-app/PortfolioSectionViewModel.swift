//
//  PortfolioSectionViewModel.swift
//  stock-app
//
//  Created by Varun Mehta on 07/04/24.
//

// PortfolioSectionViewModel.swift
//import Foundation
//import Alamofire
//
//class PortfolioSectionViewModel: ObservableObject {
//    @Published var cashBalance: Double = 0
//    @Published var netWorth: Double = 0
//    @Published var portfolioItems: [PortfolioItem] = []
//    
//    // Initialize view model and fetch data
//    init() {
//        // Fetch wallet balance using Alamofire
//        // Sample implementation
//        // Alamofire.request("https://localhost:5002/api/wallet").responseJSON { response in
//        //    switch response.result {
//        //    case .success(let value):
//        //        if let json = value as? [String: Any], let balance = json["walletBalance"] as? Double {
//        //            self.cashBalance = balance
//        //        }
//        //    case .failure(let error):
//        //        print("Error fetching wallet balance: \(error)")
//        //    }
//        // }
//        
//        // Assign sample cash balance
//        cashBalance = 25000
//        
//        // Sample JSON data for portfolio items
//        let sampleData = """
//            [
//                {
//                    "symbol": "AAPL",
//                    "name": "Apple Inc.",
//                    "quantity": 10,
//                    "totalCost": 2000,
//                    "averageValuePerShare": 200,
//                    "change": 100,
//                    "currentPrice": 220,
//                    "marketValue": 2200
//                },
//                {
//                    "symbol": "GOOGL",
//                    "name": "Alphabet Inc.",
//                    "quantity": 5,
//                    "totalCost": 4000,
//                    "averageValuePerShare": 800,
//                    "change": -200,
//                    "currentPrice": 750,
//                    "marketValue": 3750
//                }
//            ]
//            """.data(using: .utf8)!
//        
//        // Decode JSON data into PortfolioItems
//        do {
//            let decoder = JSONDecoder()
//            let portfolioRepositories = try decoder.decode([PortfolioItem].self, from: sampleData)
//            portfolioItems = portfolioRepositories
//            print("Portfolios: \(portfolioItems)")
//        } catch {
//            print("Error decoding portfolio data: \(error)")
//        }
//        
//        // Calculate net worth
//        let totalMarketValue = portfolioItems.reduce(0) { $0 + $1.marketValue }
//        netWorth = cashBalance + totalMarketValue
//    }
//    func deletePortfolioItem(at offsets: IndexSet) {
//            portfolioItems.remove(atOffsets: offsets)
//        }
//        
//    func movePortfolioItem(from source: IndexSet, to destination: Int) {
//        portfolioItems.move(fromOffsets: source, toOffset: destination)
//    }
//}

import Foundation
import Alamofire

class PortfolioSectionViewModel: ObservableObject {
    
    @Published var netWorth: Double = 0
    @Published var portfolioItems: [PortfolioItem] = []
    @Published var cashBalance2: Double = 0
    @Published var portfolioItems2: [PortfolioItem] = []
    @Published var cashBalance: Double = 0
    
    var timer: Timer?
    // Initialize view model and fetch data
//    init() {
//        // Fetch wallet balance using Alamofire
//        Task{
//            await fetchData()
//        }
//        
        // Fetch portfolio items using Alamofire
//        fetchPortfolioItems()
//        calculateNetWorth()
        // Start the timer to update portfolio current prices every 15 seconds
//                startTimer()
//    }
    deinit {
            // Stop the timer when the ViewModel is deallocated
//            stopTimer()
        }
    // Function to start the timer
//        private func startTimer() {
//            // Invalidate any existing timer before starting a new one
//            stopTimer()
//
//            // Schedule a timer to fire every 15 seconds
//            timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
//                // Call the function to update portfolio current prices
//                self?.updatePortfolioCurrentPrices()
//            }
//
//            // Make sure the timer is added to the current run loop
//            RunLoop.current.add(timer!, forMode: .common)
//        }
//
//        // Function to stop the timer
//        private func stopTimer() {
//            timer?.invalidate()
//            timer = nil
//        }
    
    
    func fetchWalletBalance() {
        AF.request("http://54.189.131.70/api/wallet")
            .responseDecodable(of: WalletBalanceResponse.self) { response in
                switch response.result {
                case .success(let balanceResponse):
                    DispatchQueue.main.async {
                        self.cashBalance = balanceResponse.walletBalance
//                        self.netWorth = balanceResponse.walletBalance
                    }
                    print("cash balance: \(self.cashBalance2)")
                case .failure(let error):
                    print("Error fetching wallet balance: \(error)")
                }
            }
    }

    func fetchPortfolioItems() {
        AF.request("http://54.189.131.70/api/portfolio")
            .responseDecodable(of: [PortfolioItem].self) { response in
                switch response.result {
                case .success(let portfolioItems):
                    DispatchQueue.main.async {
                        self.portfolioItems = portfolioItems
                    }
                    print("Portfolios: \(self.portfolioItems)")
                case .failure(let error):
                    print("Error fetching portfolio items: \(error)")
                }
            }
    }
    
//    func fetchWalletBalance() {
//        AF.request("http://54.189.131.70/api/wallet")
//            .responseDecodable(of: WalletBalanceResponse.self) { response in
//                switch response.result {
//                case .success(let balanceResponse):
//                    self.cashBalance = balanceResponse.walletBalance
//                    
//                    print("cash balance: \(self.cashBalance)")
//                case .failure(let error):
//                    print("Error fetching wallet balance: \(error)")
//                }
//            }
//    }
    func fetchWalletBalance2() async throws -> Double {
            return try await withCheckedThrowingContinuation { continuation in
                AF.request("http://54.189.131.70/api/wallet")
                    .responseDecodable(of: WalletBalanceResponse.self) { response in
                        switch response.result {
                        case .success(let balanceResponse):
                            DispatchQueue.main.async {
                                continuation.resume(returning: balanceResponse.walletBalance)
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                continuation.resume(throwing: error)
                            }
                        }
                    }
            }
        }
        
//    func fetchData() async {
//        do {
//            self.cashBalance2 = try await fetchWalletBalance2()
//            self.portfolioItems2 = try await fetchPortfolioItems2()
//            await updatePortfolioCurrentPrices2()
//            self.calculateNetWorth()
//        } catch {
//            print("Error fetching data: \(error)")
//        }
//    }
    func fetchWalletData() async {
        do {
            let cashBalance = try await fetchWalletBalance2()
            
            
            DispatchQueue.main.async {
                self.cashBalance2 = cashBalance
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    func fetchData() async {
        do {
            let cashBalance = try await fetchWalletBalance2()
            let portfolioItems = try await fetchPortfolioItems2()
            self.updatePortfolioCurrentPrices(currentBalance:cashBalance)
            DispatchQueue.main.async {
                self.cashBalance = cashBalance
                self.portfolioItems2 = portfolioItems
//                self.updatePortfolioCurrentPrices2()
                self.calculateNetWorth()
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    func fetchPortfolioItems2() async throws -> [PortfolioItem] {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("http://54.189.131.70/api/portfolio")
                .responseDecodable(of: [PortfolioItem].self) { response in
                    switch response.result {
                    case .success(let portfolioItems):
                        DispatchQueue.main.async {
                            continuation.resume(returning: portfolioItems)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
//    func fetchPortfolioItems() {
//        AF.request("http://54.189.131.70/api/portfolio")
//            .responseDecodable(of: [PortfolioItem].self) { response in
//                switch response.result {
//                case .success(let portfolioItems):
//                    
//                    self.portfolioItems = portfolioItems
//                    print("Portfolios: \(self.portfolioItems)")
//                    
//                    
//                case .failure(let error):
//                    print("Error fetching portfolio items: \(error)")
//                }
//            }
////        self.calculateNetWorth()
//    }
    
    func calculateNetWorth() {
        let totalMarketValue = self.portfolioItems2.reduce(0) { $0 + $1.marketValue }
        netWorth = self.cashBalance + totalMarketValue
    }
//    func calculateNetWorth() {
//        fetchPortfolioItems {
//            fetchWalletBalance {
//                let totalMarketValue = self.portfolioItems.reduce(0) { $0 + $1.marketValue }
//                self.netWorth = self.cashBalance + totalMarketValue
//                print("Net Worth: \(self.netWorth)")
//            }
//        }
//    }
//    func fetchData() async {
//            await fetchWalletBalance()
//            await fetchPortfolioItems()
//            await calculateNetWorth()
//        }
    
    func deletePortfolioItem(at offsets: IndexSet) {
        portfolioItems.remove(atOffsets: offsets)
//        calculateNetWorth()
    }
    
    func movePortfolioItem(from source: IndexSet, to destination: Int) {
        portfolioItems.move(fromOffsets: source, toOffset: destination)
    }
    
    func fetchPortfolioItem(by symbol: String, completion: @escaping (PortfolioItem?) -> Void) {
            let url = "http://54.189.131.70/api/portfolio/\(symbol)"
            AF.request(url)
                .responseDecodable(of: PortfolioItem.self) { response in
                    switch response.result {
                    case .success(let portfolioItem):
                        completion(portfolioItem)
                    case .failure(let error):
                        print("Error fetching portfolio item for symbol \(symbol): \(error)")
                        completion(nil)
                    }
                }
        }
    func fetchCurrentPrice(for symbol: String, completion: @escaping (Double?) -> Void) {
           AF.request("http://54.189.131.70/api/search/currentPrice/\(symbol)")
               .validate()
               .responseDecodable(of: CurrentPriceResponse.self) { response in
                   switch response.result {
                   case .success(let data):
                       completion(data.c)
                   case .failure(let error):
                       print("Error fetching current price:", error)
                       completion(nil)
                   }
               }
       }
    func fetchCurrentPriceAndTimestamp(for symbol: String, completion: @escaping ((Double, TimeInterval)?) -> Void) {
        AF.request("http://54.189.131.70/api/search/currentPrice/\(symbol)")
            .validate()
            .responseDecodable(of: CurrentPriceResponse.self) { response in
                switch response.result {
                case .success(let data):
                    let timestamp = TimeInterval(data.t)
                    completion((data.c, timestamp))
                case .failure(let error):
                    print("Error fetching current price:", error)
                    completion(nil)
                }
            }
    }
    func fetchCurrentPriceAndTimestamp2(for symbol: String) async throws -> (Double, TimeInterval)? {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "http://54.189.131.70/api/search/currentPrice/\(symbol)")!)
        let response = try JSONDecoder().decode(CurrentPriceResponse.self, from: data)
        return (response.c, TimeInterval(response.t))
    }

    func updatePortfolioCurrentPrices2() async {
        var totalCostOfAllPortfolio: Double = 0
      
//        self.netWorth = self.cashBalance
        print("Updating portfolio current prices...")
        
        for item in portfolioItems {
            do {
                guard let (currentPrice, timestamp) = try await fetchCurrentPriceAndTimestamp2(for: item.symbol) else {
                    print("Failed to fetch current price for \(item.symbol)")
                    continue
                }
                

                    let newTotalCost = Double(item.quantity) * currentPrice
                    let averageValuePerShare = newTotalCost / Double(item.quantity)
                    let change = currentPrice - item.averageValuePerShare
                    let marketValue = Double(item.quantity) * currentPrice
                    
                    let updatedItem = PortfolioItem(
                        symbol: item.symbol,
                        name: item.name,
                        quantity: item.quantity,
                        totalCost: newTotalCost,
                        averageValuePerShare: averageValuePerShare,
                        change: change,
                        currentPrice: currentPrice,
                        marketValue: marketValue
                    )
                    
                    totalCostOfAllPortfolio += newTotalCost
                  
                    
                let response = try await AF.request("http://54.189.131.70/api/portfolio/\(item.symbol)", method: .put, parameters: updatedItem, encoder: JSONParameterEncoder.default)
                    .validate()
                    .responseDecodable(of: PortfolioItem.self) { response in
                        switch response.result {
                        case .success:
                            print("Portfolio item \(item.symbol) updated successfully")
                            self.netWorth +=  totalCostOfAllPortfolio
                            // Do nothing upon successful update
                        case .failure(let error):
                            print("Error updating portfolio item \(item.symbol):", error)
                            
                        }
                }
                    

            } catch {
                print("Error updating portfolio:", error)
                
            }
            

        }
    }

    
    func updatePortfolioCurrentPrices(currentBalance:Double) {
        var totalCostOfAllPortfolio: Double = 0
        var isMarketOpenForAnyItem = false // Initialize market open flag
//        self.netWorth = currentBalance
        print("Updating portfolio current prices...")
        
        for item in portfolioItems {
            fetchCurrentPriceAndTimestamp(for: item.symbol) { [weak self] priceAndTimestamp in
                guard let (currentPrice, timestamp) = priceAndTimestamp else {
                    print("Failed to fetch current price for \(item.symbol)")
                    return
                }
                guard let strongSelf = self else {
                    // Handle the case where self is nil
                    return
                }
                
                // Check market status based on timestamp
                let marketStatus = strongSelf.isMarketOpen(lastPriceStamp: timestamp)
                
                // Only update portfolio if market is open
                if marketStatus == "Open" {
                    let newTotalCost = Double(item.quantity) * currentPrice
                    let averageValuePerShare = newTotalCost / Double(item.quantity)
                    let change = currentPrice - item.averageValuePerShare
                    let marketValue = Double(item.quantity) * currentPrice
                    
                    let updatedItem = PortfolioItem(
                        symbol: item.symbol,
                        name: item.name,
                        quantity: item.quantity,
                        totalCost: newTotalCost,
                        averageValuePerShare: averageValuePerShare,
                        change: change,
                        currentPrice: currentPrice,
                        marketValue: marketValue
                    )
                    
                    totalCostOfAllPortfolio += newTotalCost
                    isMarketOpenForAnyItem = true // Set market open flag
                    
                    AF.request("http://54.189.131.70/api/portfolio/\(item.symbol)", method: .put, parameters: updatedItem, encoder: JSONParameterEncoder.default)
                        .validate()
                        .response { response in
                            switch response.result {
                            case .success:
                                print("Portfolio item \(item.symbol) updated successfully")
                                // Do nothing upon successful update
                            case .failure(let error):
                                print("Error updating portfolio item \(item.symbol):", error)
                            }
                            
                            
                        }
                } else {
                    print("Market is closed. Skipping update for \(item.symbol)")
                    // Exit the function if market is closed for the first item
                    isMarketOpenForAnyItem = false
                    return
                }
            }
            
            if !isMarketOpenForAnyItem {
                return
            }
        }// After updating all portfolio items, calculate net worth
        netWorth  = currentBalance + totalCostOfAllPortfolio
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


    
    func sellStock(stock: String, stockCompanyName: String, quantity: Int, currentUpdatedPrice: Double,currentBalance:Double, onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
        // Calculate the total price of the stocks to be sold
        let totalPrice = Double(quantity) * currentUpdatedPrice
        
//        // Check if the quantity to sell exceeds the quantity in the portfolio
//        if let portfolioItem = portfolioItem {
//            guard quantity <= portfolioItem.quantity else {
//                onError("Not enough shares to sell!")
//                return
//            }
//        } else {
//            onError("Portfolio item does not exist!")
//            return
//        }
        
        // Proceed with the sell transaction
        AF.request("http://54.189.131.70/api/portfolio/\(stock)")
            .validate()
            .responseDecodable(of: PortfolioItem.self) { response in
                switch response.result {
                case .success(let portfolioItem):
                    // If the portfolio item exists, update the existing portfolio item or delete it if necessary
                    let previousQuantity = portfolioItem.quantity
                    let newQuantity = previousQuantity - quantity
                    
                    if newQuantity == 0 {
                        // If the remaining quantity is zero, delete the portfolio item
                        AF.request("http://54.189.131.70/api/portfolio/\(stock)", method: .delete)
                            .validate()
                            .response { response in
                                switch response.result {
                                case .success:
                                    // Update the wallet balance
                                    let updatedBalance = currentBalance + totalPrice
                                    AF.request("http://54.189.131.70/api/wallet", method: .put, parameters: ["newBalance": updatedBalance])
                                        .validate()
                                        .response { response in
                                            switch response.result {
                                            case .success:
                                                // Display success message
                                                onSuccess("\(stock) sold successfully")
//                                                self.cashBalance=updatedBalance
                                                self.fetchWalletBalance()
                                                self.fetchPortfolioItems()
//                                                self.calculateNetWorth()
                                            case .failure(let error):
                                                print("Error updating wallet balance:", error)
                                                onError("Failed to sell stock")
                                            }
                                        }
                                case .failure(let error):
                                    print("Error deleting portfolio item:", error)
                                    onError("Failed to sell stock")
                                }
                            }
                    } else {
                        // If the remaining quantity is greater than zero, update the portfolio item
                        let newTotalCost = portfolioItem.totalCost - totalPrice
                        let averageValuePerShare = newTotalCost / Double(newQuantity)
                        let change = currentUpdatedPrice - averageValuePerShare
                        let marketValue = Double(newQuantity) * currentUpdatedPrice
                        
                        let updatedPortfolioItem = PortfolioItem(
                            symbol: stock,
                            name: stockCompanyName,
                            quantity: newQuantity,
                            totalCost: newTotalCost,
                            averageValuePerShare: averageValuePerShare,
                            change: change,
                            currentPrice: currentUpdatedPrice,
                            marketValue: marketValue
                        )
                        
                        AF.request("http://54.189.131.70/api/portfolio/\(stock)", method: .put, parameters: updatedPortfolioItem, encoder: JSONParameterEncoder.default)
                            .validate()
                            .response { response in
                                switch response.result {
                                case .success:
                                    // Update the wallet balance
                                    let updatedBalance = currentBalance + totalPrice
                                    
                                    AF.request("http://54.189.131.70/api/wallet", method: .put, parameters: ["newBalance": updatedBalance])
                                        .validate()
                                        .response { response in
                                            switch response.result {
                                            case .success:
                                                // Display success message
                                                onSuccess("\(stock) sold successfully")
//                                                self.cashBalance=updatedBalance
                                                self.fetchWalletBalance()
                                                self.fetchPortfolioItems()
//                                                self.calculateNetWorth()
                                            case .failure(let error):
                                                print("Error updating wallet balance:", error)
                                                onError("Failed to sell stock")
                                            }
                                        }
                                case .failure(let error):
                                    print("Error updating portfolio item:", error)
                                    onError("Failed to sell stock")
                                }
                            }
                    }
                case .failure:
                    onError("Failed to fetch portfolio item")
                }
            }
    }

    
    func buyStock(stock: String, stockCompanyName:String, quantity: Int, currentUpdatedPrice: Double,currentBalance:Double, onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
        // Calculate the total price of the stocks to be bought
        let totalPrice = Double(quantity) * currentUpdatedPrice
        
        // Check if the total price exceeds the amount in the wallet
        if totalPrice > currentBalance {
            onError("Not enough money in wallet!")
            return
        }
        
        // If total price is valid, proceed with the buy transaction
        AF.request("http://54.189.131.70/api/portfolio/\(stock)")
            .validate()
            .responseDecodable(of: PortfolioItem.self) { response in
                switch response.result {
                case .success(let portfolioItem):
                    // If the portfolio item exists, update the existing portfolio item
                    let previousQuantity = portfolioItem.quantity
                    let previousTotalCost = portfolioItem.totalCost
                    
                    let newQuantity = previousQuantity + quantity
                    let newTotalCost = previousTotalCost + totalPrice
                    
                    let averageValuePerShare = newTotalCost / Double(newQuantity)
                    let change = currentUpdatedPrice - averageValuePerShare
                    let marketValue = Double(newQuantity) * currentUpdatedPrice
                    
                    let parameters = PortfolioItem(
                                       symbol: stock,
                                       name: stockCompanyName,
                                       quantity: newQuantity,
                                       totalCost: newTotalCost,
                                       averageValuePerShare: averageValuePerShare,
                                       change: change,
                                       currentPrice: currentUpdatedPrice,
                                       marketValue: marketValue
                                   )
                    
                    AF.request("http://54.189.131.70/api/portfolio/\(stock)", method: .put, parameters:
//                                [
//                        "quantity": Double(newQuantity),
//                        "totalCost": newTotalCost,
//                        "averageValuePerShare": averageValuePerShare,
//                        "change": change,
//                        "currentPrice": currentUpdatedPrice,
//                        "marketValue": marketValue
//                    ]
                       parameters        , encoder: JSONParameterEncoder.default)
                    .validate()
                    .response { response in
                        switch response.result {
                        case .success:
                            // Update the wallet balance
                            let updatedBalance = currentBalance - totalPrice
                            AF.request("http://54.189.131.70/api/wallet", method: .put, parameters: ["newBalance": updatedBalance])
                                .validate()
                                .response { response in
                                    switch response.result {
                                    case .success:
                                        // Display success message
                                        onSuccess("\(stock) bought successfully")
//                                        self.cashBalance=updatedBalance
                                        self.fetchWalletBalance()
                                        self.fetchPortfolioItems()
//                                        self.calculateNetWorth()
                                        
                                    case .failure(let error):
                                        print("Error updating wallet balance:", error)
                                        onError("Failed to buy stock")
                                    }
                                }
                        case .failure(let error):
                            print("Error updating portfolio item:", error)
                            onError("Failed to buy stock")
                        }
                    }
                case .failure:
                    // If the portfolio item does not exist, create a new portfolio item with a POST request
//                    let parameters: [String: Any] = [
//                        "symbol": stock,
//                        "quantity": quantity,
//                        "totalCost": totalPrice,
//                        "averageValuePerShare": currentUpdatedPrice,
//                        "change": 0, // Initial change value
//                        "currentPrice": currentUpdatedPrice,
//                        "marketValue": totalPrice // Initial market value
//                    ]

//                    // Encode the parameters dictionary to JSON
//                    guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
//                        // Handle error if JSON encoding fails
//                        onError("Failed to encode parameters")
//                        return
//                    }
//
//                    // Convert JSON data to a dictionary
//                    guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
//                        // Handle error if conversion fails
//                        onError("Failed to convert JSON data to dictionary")
//                        return
//                    }
                    // If the portfolio item does not exist, create a new portfolio item with a POST request
                    let parameters = PortfolioItem(
                                       symbol: stock,
                                       name: stockCompanyName,
                                       quantity: quantity,
                                       totalCost: totalPrice,
                                       averageValuePerShare: currentUpdatedPrice,
                                       change: 0, // Initial change value
                                       currentPrice: currentUpdatedPrice,
                                       marketValue: totalPrice // Initial market value
                                   )


                    // Send the POST request with JSON data
                    AF.request("http://54.189.131.70/api/portfolio", method: .post, parameters:parameters
                    , encoder: JSONParameterEncoder.default)
                        .validate()
                           .response { response in
                               switch response.result {
                               case .success:
                                   // Update the wallet balance
                                   let updatedBalance = currentBalance - totalPrice
                                   AF.request("http://54.189.131.70/api/wallet", method: .put, parameters: ["newBalance": updatedBalance])
                                       .validate()
                                       .response { response in
                                           switch response.result {
                                           case .success:
                                               // Display success message
                                               onSuccess("\(stock) bought successfully")
//                                               self.cashBalance=updatedBalance
                                               self.fetchWalletBalance()
                                               self.fetchPortfolioItems()
//                                               self.calculateNetWorth()
                                           case .failure(let error):
                                               print("Error updating wallet balance:", error)
                                               onError("Failed to buy stock")
                                           }
                                       }
                               case .failure(let error):
                                   print("Error creating portfolio item:", error)
                                   onError("Failed to buy stock")
                               }
                           }

                }
            }
    }
    

}



