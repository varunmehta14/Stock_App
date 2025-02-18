//
//  SearchBarViewModel.swift
//  stock-app
//
//  Created by Varun Mehta on 12/04/24.
//
//
//import Foundation
//import Alamofire
//
//class SearchBarViewModel: ObservableObject {
//    @Published var searchData: SearchData?
//       
//    func searchForTicker(_ ticker: String) {
//        let today = Date()
//        let toDate = today.isoDateString
//        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
//        let fromDate = oneWeekAgo.isoDateString
//        
//        AF.request("http://localhost:5002/api/search/\(ticker)?fromNews=\(fromDate)&toNews=\(toDate)")
//            .responseDecodable(of: SearchData.self) { response in
//                switch response.result {
//                case .success(let searchData):
//                    self.searchData = searchData
//                    print("Search Data: \(searchData)")
//                case .failure(let error):
//                    print("Error searching for ticker: \(error)")
//                }
//            }
//    }
//}
//
//extension Date {
//    var isoDateString: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: self)
//    }
//}
//import Foundation
//import Alamofire
//
//class SearchBarViewModel: ObservableObject {
////    @Published var searchData: StockData?
//    @Published var suggestions: [String] = []
//    
//    func searchForTicker(_ ticker: String) {
////        let today = Date()
////        let toDate = today.isoDateString
////        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
////        let fromDate = oneWeekAgo.isoDateString
////        
////        AF.request("http://localhost:5002/api/search/\(ticker)?fromNews=\(fromDate)&toNews=\(toDate)")
////            .responseDecodable(of: SearchData.self) { response in
////                switch response.result {
////                case .success(let searchData):
////                    self.searchData = searchData
////                    print("Search Data: \(searchData)")
////                case .failure(let error):
////                    print("Error searching for ticker: \(error)")
////                }
////            }
//    }
//
//
//
//    func fetchSuggestions(for query: String) {
//        let url = "http://localhost:5002/api/suggestions/\(query)"
//        AF.request(url).responseDecodable(of: [String].self) { response in
//            switch response.result {
//            case .success(let suggestions):
//                DispatchQueue.main.async {
//                    self.suggestions = suggestions
//                }
//            case .failure(let error):
//                print("Error fetching suggestions: \(error)")
//            }
//        }
//    }
//}
//extension Date {
//    var isoDateString: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: self)
//    }
//}

//import Foundation
//import Alamofire
//
//class SearchBarViewModel: ObservableObject {
//    @Published var suggestions: [String] = []
//    @Published var searchText:String=""
////    let stockDetailViewModel: StockDetailViewModel
////    
////    init(stockDetailViewModel: StockDetailViewModel) {
////        self.stockDetailViewModel = stockDetailViewModel
////    }
////    
////    func searchForTicker(_ ticker: String) {
////        stockDetailViewModel.searchForTicker(ticker)
////    }
//
//    func fetchSuggestions(for searchText: String) {
//        let url = "http://localhost:5002/suggestions/\(searchText)"
//        AF.request(url).responseDecodable(of: [String].self) { response in
//            switch response.result {
//            case .success(let suggestions):
//                DispatchQueue.main.async {
//                    self.suggestions = suggestions
//                }
//            case .failure(let error):
//                print("Error fetching suggestions: \(error)")
//            }
//        }
//    }
//}

//import Foundation
//import Alamofire
//
//class SearchBarViewModel: ObservableObject {
//    @Published var suggestions: [String] = []
//
//    func fetchSuggestions(for searchText: String) {
//        let url = "http://localhost:5002/suggestions/\(searchText)"
//        AF.request(url).responseDecodable(of: [String].self) { response in
//            switch response.result {
//            case .success(let suggestions):
//                DispatchQueue.main.async {
//                    self.suggestions = suggestions
//                }
//            case .failure(let error):
//                print("Error fetching suggestions: \(error)")
//            }
//        }
//    }
//}

//import Foundation
//import Alamofire
//
//class SearchBarViewModel: ObservableObject {
//    @Published var suggestions: [String] = []
//
//    func fetchSuggestions(for searchText: String) {
//        let url = "http://localhost:5002/suggestions/\(searchText)"
//        AF.request(url).response { response in
//            switch response.result {
//            case .success(let data):
//                if let responseData = data {
//                    if let stringData = String(data: responseData, encoding: .utf8) {
//                        print("Response data: \(stringData)")
//                    }
//                }
//            case .failure(let error):
//                print("Error fetching suggestions: \(error)")
//            }
//        }
//    }
//}

import Foundation
import Alamofire
import Combine

class SearchBarViewModel: ObservableObject {
    @Published var suggestions: [SearchResults] = []
    @Published var searchText: String = ""
    
    private var cancellable: AnyCancellable?

    init() {
        // Listen for changes in searchText and fetch suggestions
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self, !searchText.isEmpty else { return }
                self.fetchSuggestions(for: searchText)
            }
    }

//    func fetchSuggestions(for searchText: String) {
//        let url = "http://localhost:5002/suggestions/\(searchText)"
//        AF.request(url).response { [weak self] response in
//            guard let self = self else { return }
//            switch response.result {
//            case .success(let data):
//                if let responseData = data {
//                    if let stringData = String(data: responseData, encoding: .utf8) {
//                        print("Response data: \(stringData)")
//                        // Parse the response data here and update suggestions
//                        // For now, updating suggestions with a placeholder array
////                        self.suggestions = ["Apple Inc.", "Microsoft Corporation", "Amazon.com Inc."]
//                    }
//                }
//            case .failure(let error):
//                print("Error fetching suggestions: \(error)")
//            }
//        }
//    }
    
    func filterSearchResults(_ results: [SearchResults]) -> [SearchResults] {
        return results.filter { item in
            return item.type == "Common Stock" && !item.symbol.contains(".")
        }
    }
    
    func fetchSuggestions(for searchText: String) {
        let url = "http://54.189.131.70/api/suggestions/\(searchText)"
        AF.request(url)
            .responseDecodable(of: SearchResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let searchResponse):
//                    self.suggestions = searchResponse.result.map { SearchResults(description: $0.description, displaySymbol: $0.displaySymbol) }
//                    print("Suggestions: \(self.suggestions)")
                    // Filter the search results using the filterSearchResults function
                                    let filteredData = self.filterSearchResults(searchResponse.result)
                                    // Map filteredData to SearchResults and update suggestions
                    self.suggestions = filteredData.map { SearchResults(description: $0.description, displaySymbol: $0.displaySymbol,symbol:$0.symbol,type:$0.type) }
                                    print("Filtered Suggestions: \(self.suggestions)")
                case .failure(let error):
                    print("Error fetching suggestions: \(error)")
                }
            }
    }
    
    func clearSuggestions() {
            searchText=""
            suggestions = []
       }

}
