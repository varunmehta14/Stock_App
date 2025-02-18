//
//  SearchBar.swift
//  stock-app
//
//  Created by Varun Mehta on 07/04/24.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText: String = ""
    @ObservedObject var viewModel = StockDetailViewModel()
    
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1)) // Gray background with opacity
                .frame(height: 36) // Set height to match TextField
                .overlay(
                    HStack {
                        Button(action: {
                            // Perform search action
                            print("Perform search for: \(searchText)")
                            
                            viewModel.searchForTicker(searchText)
                            
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray) // Magnifying glass icon
                                .padding(.leading, 8) // Adjust icon padding
                        }
                        
                        TextField("Search", text: $searchText)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity) // Take full width
                    }
                )
//                .padding(.horizontal) // Add horizontal padding to match TextField
                
        }
    }
}

//import SwiftUI
//import Alamofire
//
//struct SearchBar: View {
//    @State private var searchText: String = ""
//    @ObservedObject var viewModel = SearchBarViewModel()
//    @State private var suggestions: [String] = []
//    private var searchTask: (() -> Void)?
//
//    var body: some View {
//        HStack {
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Color.gray.opacity(0.1)) // Gray background with opacity
//                .frame(height: 36) // Set height to match TextField
//                .overlay(
//                    HStack {
//                        Button(action: {
//                            // Perform search action
//                            print("Perform search for: \(searchText)")
//                            viewModel.searchForTicker(searchText)
//                        }) {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundColor(.gray) // Magnifying glass icon
//                                .padding(.leading, 8) // Adjust icon padding
//                        }
//                        
//                        TextField("Search", text: $searchText, onEditingChanged: { editing in
//                            // Fetch suggestions when editing begins
//                            if editing {
//                                fetchSuggestions()
//                            } else {
//                                // Clear suggestions when editing ends
//                                suggestions = []
//                            }
//                        })
//                        .padding(.horizontal)
//                        .frame(maxWidth: .infinity) // Take full width
//                    }
//                )
//                .padding(.horizontal) // Add horizontal padding to match TextField
//        }
//        .onReceive(viewModel.$suggestions) { suggestions in
//            self.suggestions = suggestions
//        }
//    }
//    
//    func fetchSuggestions() {
//        // Cancel previous search task
//        searchTask?()
//        
//        // Create a new search task with debounce time
//        searchTask = DispatchWorkItem { [weak self] in
//            guard let self = self else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                self.viewModel.fetchSuggestions(for: self.searchText)
//            }
//        }
//        
//        // Execute the search task after a delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: searchTask!)
//    }
//}
//
//
//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar()
//    }
//}
