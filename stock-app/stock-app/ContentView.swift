//
//  ContentView.swift
//  stock-app
//
//  Created by Varun Mehta on 06/04/24.
//

// ContentView.swift
import SwiftUI


struct ContentView: View {
    var body: some View {
        // Create necessary view models
        let homeViewModel = HomeViewModel()
        
        VStack {
            HomeView(viewModel: homeViewModel)
                
            

        }
    }
}


//import SwiftUI
//
//struct ContentView: View {
//    @StateObject var homeViewModel = HomeViewModel()
//    @StateObject var stockDetailViewModel = StockDetailViewModel()
//    @State private var isShowingStockDetail = false // State variable to control navigation
//    
//    var body: some View {
//        NavigationView {
//            TabView {
//                // HomeView Tab
//                HomeView(viewModel: homeViewModel)
//                    .tabItem {
//                        Label("Home", systemImage: "house")
//                    }
//                
//                // StockDetailView Tab
//                VStack {
//                                if let stockData = stockDetailViewModel.stockData {
//                                    // Navigate to StockDetailView when stockData is available
//                                    EmptyView()
//                                        .hidden()
//                                        .navigationDestination(isPresented: $stockDetailViewModel.isLoading) {
//                                            StockDetailView(viewModel: stockDetailViewModel)
//                                        }
//                                }
//                            }
//                            .tabItem {
//                                Label("Stock Detail", systemImage: "chart.bar")
//                            }
//            }
//            .onReceive(stockDetailViewModel.$stockData) { _ in
//                // When stockData is updated, set isShowingStockDetail to true to trigger navigation
//                isShowingStockDetail = true
//            }
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview{
    ContentView()
}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var searchText: String = ""
//    @State private var isSearching: Bool = false
//    
//    var body: some View {
//        NavigationView {
//            TabView {
//                if isSearching {
//                    SearchView(searchText: $searchText)
//                        .tabItem {
//                            Label("Search", systemImage: "magnifyingglass")
//                        }
//                } else {
//                    Home2View(searchText: $searchText, isSearching: $isSearching)
//                        .tabItem {
//                            Label("Home", systemImage: "house")
//                        }
//                }
//            }
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//struct Home2View: View {
//    @Binding var searchText: String
//    @Binding var isSearching: Bool
//    
//    var body: some View {
//        VStack {
//            Text("Home View")
//            Search2Bar(searchText: $searchText, isSearching: $isSearching)
//        }
//    }
//}
//
//struct Search2Bar: View {
//    @Binding var searchText: String
//    @Binding var isSearching: Bool
//    
//    var body: some View {
//        HStack {
//            TextField("Search", text: $searchText) { isEditing in
//                isSearching = isEditing
//            } onCommit: {
//                isSearching = true
//            }
//            .padding()
//            .background(Color(.systemGray6))
//            .cornerRadius(8)
//            .padding(.horizontal)
//            
//            if !searchText.isEmpty {
//                Button(action: {
//                    searchText = ""
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .padding(.horizontal)
//                }
//            }
//        }
//    }
//}
//
//struct SearchView: View {
//    @Binding var searchText: String
//    
//    var body: some View {
//        VStack {
//            Text("Search View")
//            Text("Search Text: \(searchText)")
//                .padding()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//







