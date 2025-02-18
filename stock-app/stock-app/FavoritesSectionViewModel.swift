//
//  FavoritesSectionViewModel.swift
//  stock-app
//
//  Created by Varun Mehta on 07/04/24.
//

//import Foundation
//
//class FavoritesSectionViewModel: ObservableObject {
//    
//    @Published var favorites: [FavoriteItem] = []
//    
//    // Function to fetch user's watchlist data (using Alamofire or any other networking library)
//    func fetchFavoritesData() {
//        // Fetch watchlist data from API and update watchlistItems
//        // Sample implementation
//        let sampleData = """
//            {
//                "favorites": [
//                    {
//                        "symbol": "AAPL",
//                        "name": "Apple Inc.",
//                        "currentPrice": 150,
//                        "difference": 10,
//                        "differencePercentage": 5
//                    },
//                    {
//                        "symbol": "GOOGL",
//                        "name": "Alphabet Inc.",
//                        "currentPrice": 2500,
//                        "difference": -50,
//                        "differencePercentage": -2
//                    }
//                ]
//            }
//            """.data(using: .utf8)!
//        
//        do {
//            let decoder = JSONDecoder()
//            let favoriteRepositories = try decoder.decode(FavoriteRepositories.self, from: sampleData)
//            
//            // Map the decoded data to create FavoriteItem instances
//            favorites = favoriteRepositories.favorites.map { item in
//                return FavoriteItem(symbol: item.symbol, name: item.name, currentPrice: item.currentPrice, difference: item.difference, differencePercentage: item.differencePercentage)
//            }
//            
//            // Print fetched data
//            print("Fetched favorites data: \(favorites)")
//        } catch {
//            print("Error decoding watchlist data: \(error)")
//        }
//    }
//}


//import Foundation
//
//class FavoritesSectionViewModel: ObservableObject {
//    
//    @Published var favorites: [FavoriteItem] = []
//    
//    // Initialize view model and fetch data
//    init() {
        // Fetch wallet balance using Alamofire
        // Sample implementation
        // Alamofire.request("http://35.92.135.73/api/wallet").responseJSON { response in
        //    switch response.result {
        //    case .success(let value):
        //        if let json = value as? [String: Any], let balance = json["walletBalance"] as? Double {
        //            self.cashBalance = balance
        //        }
        //    case .failure(let error):
        //        print("Error fetching wallet balance: \(error)")
        //    }
        // }
        
        // Assign sample cash balance
        
        
        // Sample JSON data for portfolio items
//        let sampleData = """
//            [
//                                   {
//                                       "symbol": "AAPL",
//                                       "name": "Apple Inc.",
//                                       "currentPrice": 150,
//                                       "difference": 10,
//                                       "differencePercentage": 5
//                                   },
//                                   {
//                                       "symbol": "GOOGL",
//                                       "name": "Alphabet Inc.",
//                                       "currentPrice": 2500,
//                                       "difference": -50,
//                                       "differencePercentage": -2
//                                   }
//            ]
//            """.data(using: .utf8)!
//        
//        // Decode JSON data into PortfolioItems
//        do {
//            let decoder = JSONDecoder()
//            let favoriteRepositories = try decoder.decode([FavoriteItem].self, from: sampleData)
//            favorites = favoriteRepositories
//            print("Favorites: \(favorites)")
//        } catch {
//            print("Error decoding portfolio data: \(error)")
//        }
//        
//
//    }
//    
//    func deleteFavorite(at index: Int) {
//           favorites.remove(at: index)
//       }
//       
//   func moveFavorite(from source: IndexSet, to destination: Int) {
//       favorites.move(fromOffsets: source, toOffset: destination)
//   }
//}

//import Foundation
//
//class FavoritesSectionViewModel: ObservableObject {
//    
//    @Published var favorites: [FavoriteItem] = []
//    
//    // Initialize view model and fetch data
////    init() {
////        fetchFavoriteItems() // Call fetchFavoriteItems() during initialization
////    }
//    
//    // Fetch favorite items
//    func fetchFavoriteItems() {
//        // Sample JSON data for favorite items
//        let sampleData = """
//            [
//                {
//                    "symbol": "AAPL",
//                    "name": "Apple Inc.",
//                    "currentPrice": 150,
//                    "difference": 10,
//                    "differencePercentage": 5
//                },
//                {
//                    "symbol": "GOOGL",
//                    "name": "Alphabet Inc.",
//                    "currentPrice": 2500,
//                    "difference": -50,
//                    "differencePercentage": -2
//                }
//            ]
//            """.data(using: .utf8)!
//        
//        // Decode JSON data into FavoriteItems
//        do {
//            let decoder = JSONDecoder()
//            let favoriteRepositories = try decoder.decode([FavoriteItem].self, from: sampleData)
//            favorites = favoriteRepositories
//            print("Favorites: \(favorites)")
//        } catch {
//            print("Error decoding favorite data: \(error)")
//        }
//    }
//    
//    func deleteFavorite(at index: Int) {
//        favorites.remove(at: index)
//    }
//    
//    func moveFavorite(from source: IndexSet, to destination: Int) {
//        favorites.move(fromOffsets: source, toOffset: destination)
//    }
//}

import Foundation
import Alamofire

class FavoritesSectionViewModel: ObservableObject {
    
    @Published var favorites: [FavoriteItem] = []
    
    // Fetch favorite items
    func fetchFavoriteItems() {
        AF.request("http://54.189.131.70/api/watchlist")
            .responseDecodable(of: [FavoriteItem].self) { response in
                switch response.result {
                case .success(let favoriteRepositories):
                    self.favorites = favoriteRepositories
                    print("Favorites: \(self.favorites)")
                case .failure(let error):
                    print("Error fetching favorite items: \(error)")
                }
            }
    }
    
    func fetchCurrentPrice(for symbol: String, completion: @escaping (CurrentPriceResponse?) -> Void) {
           AF.request("http://54.189.131.70/api/search/currentPrice/\(symbol)")
               .validate()
               .responseDecodable(of: CurrentPriceResponse.self) { response in
                   switch response.result {
                   case .success(let data):
                       completion(data)
                   case .failure(let error):
                       print("Error fetching current price:", error)
                       completion(nil)
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

    
    
//    func deleteFavorite(at offsets: IndexSet) {
//        favorites.remove(atOffsets: offsets)
//    }
    func deleteFavorite(symbol: String) {
        let parameters: [String: Any] = ["symbol": symbol]
        
        AF.request("http://54.189.131.70/api/watchlist/delete",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
            .response { response in
                switch response.result {
                case .success:
                    // If the request is successful, remove the item from the local array
                    if let index = self.favorites.firstIndex(where: { $0.symbol == symbol }) {
                        self.favorites.remove(at: index)
                    }
                case .failure(let error):
                    print("Error deleting favorite item: \(error)")
                }
            }
    }
    
    func moveFavorite(from source: IndexSet, to destination: Int) {
        favorites.move(fromOffsets: source, toOffset: destination)
    }
}

