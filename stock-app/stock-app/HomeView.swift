//
//  HomeView.swift
//  stock-app
//
//  Created by Varun Mehta on 07/04/24.
//

//import SwiftUI
//
//struct HomeView: View {
//    @ObservedObject var viewModel: HomeViewModel
//    @ObservedObject var searchviewModel = SearchBarViewModel()
//    @State private var isEditing = false
//    
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//List {
//                    // Search bar
////                    SearchBar()
////                        .listRowInsets(EdgeInsets()) // Remove default insets for the search bar
//                    
//                    // Current date section
//                    Section() {
//                        Text("\(viewModel.currentDate)")
//                    }
//                    
//                    // Portfolio section
//                    Section(header: Text("Portfolio")) {
//                        PortfolioSectionView(viewModel: viewModel.portfolioViewModel)
//                    }
//                    
//                    // Favorites section
//                    Section(header: Text("Favorites")) {
//                        FavoritesSectionView(viewModel: viewModel.favoritesViewModel)
//                    }
//    
//    Section(){
//        Link("Powered by Finnhub.io",destination: URL(string: "https://www.finnhub.io")!)
//    }
//                }
////                .listStyle(InsetGroupedListStyle()) // Apply inset grouped list style
//                .navigationTitle("Stocks")
//                .navigationBarItems(trailing:EditButton())
//                .searchable(text:$searchviewModel.fetchSuggestions(for: searchText),placement:
//                        .navigationBarDrawer(displayMode: .always)){
//                            SearchSuggestionsView(searchviewModel:searchviewModel)
//                        }
//                        .toolbar{
//                            ToolbarItem(placement:.navigationBarLeading){}
//                        }
//                                       
//                )
//}
//        }
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(viewModel: HomeViewModel())
//    }
//}

//import SwiftUI
//
//struct HomeView: View {
//    @ObservedObject var viewModel: HomeViewModel
//    @State private var isEditing = false
//    
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 16) {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 16) {
//                        // Current date section
//                        Text("\(viewModel.currentDate)")
//                            .font(.title)
//                            .bold()
//
//                        // Portfolio section
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Portfolio")
//                                .font(.title2)
//                                .bold()
//                            PortfolioSectionView(viewModel: viewModel.portfolioViewModel)
//                        }
//
//                        // Favorites section
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Favorites")
//                                .font(.title2)
//                                .bold()
//                            FavoritesSectionView(viewModel: viewModel.favoritesViewModel)
//                        }
//                    }
//                    .padding()
//                }
//
//                Divider()
//
//                // Search bar
//                SearchBar()
//                    .padding()
//
//                Spacer()
//            }
//            .navigationBarTitle("Stocks", displayMode: .inline)
//            .navigationBarItems(trailing:
//                Button(action: {
//                    isEditing.toggle()
//                }) {
//                    Text(isEditing ? "Done" : "Edit")
//                }
//            )
//        }
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(viewModel: HomeViewModel())
//    }
//}

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var searchViewModel = SearchBarViewModel()
    @ObservedObject var portfolioViewModel = PortfolioSectionViewModel()
    
    @ObservedObject var favoritesViewModel = FavoritesSectionViewModel()
    @State private var searchText = ""
    func deleteFavoriteItem(at offsets: IndexSet) {
        for offset in offsets {
                    let symbol = favoritesViewModel.favorites[offset].symbol
            favoritesViewModel.deleteFavorite(symbol: symbol)
                }
//        viewModel.deleteFavorite(at: offsets)
    }

    func moveFavoriteItem(from source: IndexSet, to destination: Int) {
        favoritesViewModel.moveFavorite(from: source, to: destination)
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Current date section
                    Section() {
                        Text("\(viewModel.currentDate)")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.gray)
                    }
                    
                    // Portfolio section
                    Section(header: Text("Portfolio")) {
                        //                        PortfolioSectionView()

                        HStack{
                            VStack(alignment: .leading){
                                Text("Net Worth")
                                    .font(.title2)
                                    .padding(.bottom, 1.0)
                                Text("$\(portfolioViewModel.netWorth, specifier: "%.2f")")
                                        .font(.title2)
                                        .fontWeight(.bold)
                            }
                            Spacer()
                            VStack(alignment: .leading){
                                Text("Cash Balance")
                                        .font(.title2)
                                        .padding(.bottom, 1.0)
                                    Text("$\(portfolioViewModel.cashBalance, specifier: "%.2f")")
                                        .font(.title2)
                                        .fontWeight(.bold)
                            }
                        }
                       
                        
                        
//                        Divider()
                        ForEach(portfolioViewModel.portfolioItems, id: \.symbol) { item in
                            NavigationLink(destination: StockDetailView(symbol: item.symbol)) {
                                PortfolioItemView(item: item)
                            }
                            .buttonStyle(PlainButtonStyle()) // Remove default styling
                            .foregroundColor(.primary) // Text color
                            
                            .background(Color.clear) // Remove background color
                            .frame(maxWidth: .infinity, alignment: .leading) // Fill the width
                            
                        }.onMove(perform: { indices, newOffset in
                            portfolioViewModel.portfolioItems.move(fromOffsets: indices, toOffset: newOffset)
                        })
                    }
//                    .task {
//                                           await portfolioViewModel.fetchData()
//                                       }
                    .onAppear{
                        Task {
                            portfolioViewModel.fetchWalletBalance()
                            portfolioViewModel.fetchPortfolioItems()
//                            portfolioViewModel.updatePortfolioCurrentPrices(currentBalance:portfolioViewModel.cashBalance)
                            await portfolioViewModel.fetchData()
                           
                            }
                    }
//                    .onAppear(perform : portfolioViewModel.fetchPortfolioItems)
//                }
//                    }
                    
                    // Favorites section
                    Section(header: Text("Favorites")) {
//                        FavoritesSectionView(viewModel: favoritesViewModel)
                        ForEach(favoritesViewModel.favorites,id: \.symbol) { item in
                            NavigationLink(destination: StockDetailView(symbol: item.symbol)){
                                FavoritesItemView(item: item)
                            }
                        }.onDelete(perform: deleteFavoriteItem)
                            .onMove(perform: moveFavoriteItem)
                        
                    }.onAppear(perform : favoritesViewModel.fetchFavoriteItems)
                    
                    Section {
                        HStack {
                            Spacer()
                            Link(destination: URL(string: "https://www.finnhub.io")!) {
                                Text("Powered by Finnhub.io")
                                    .font(.footnote) // Change font size
                                    .foregroundColor(.gray) // Change text color
                            }
                            Spacer()
                        }
                    }
                    }
                    
                    
                }
                .navigationTitle("Stocks")
                .navigationBarItems(trailing: EditButton())
            }
            .searchable(text: $searchViewModel.searchText, placement: .navigationBarDrawer(displayMode: .always)) {
             
                    SearchSuggestionsView(searchViewModel: searchViewModel)
           
                        }
            .onChange(of: searchViewModel.searchText) { searchText in
                if searchText.isEmpty {
                    searchViewModel.clearSuggestions()
                }
            }
            
//        }
    
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
