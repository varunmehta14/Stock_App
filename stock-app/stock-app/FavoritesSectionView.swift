//
//  FavoritesSectionView.swift
//  stock-app
//
//  Created by Varun Mehta on 07/04/24.
//

// FavoritesSectionView.swift
//import SwiftUI
//
//struct FavoritesSectionView: View {
//    @ObservedObject var viewModel: FavoritesSectionViewModel
//    
//    var body: some View {
//        List(viewModel.favorites,id: \.symbol) { favorite in
//            VStack(alignment: .leading) {
//                Text("Symbol: \(favorite.symbol)")
//                Text("Current Price: \(favorite.currentPrice)")
//                Text("Change: \(favorite.difference)")
//            }
//        }
//        .navigationTitle("Favorites")
//    }
//}
//
//struct FavoritesSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesSectionView(viewModel: FavoritesSectionViewModel())
//    }
//}

import SwiftUI

struct FavoritesSectionView: View {
    @ObservedObject var viewModel: FavoritesSectionViewModel
    
    var body: some View {
        
            
            List{
                ForEach(viewModel.favorites,id: \.symbol) { item in
                    NavigationLink(destination: StockDetailView(symbol: item.symbol)){
                        FavoritesItemView(item: item)
                    }
                }.onDelete(perform: deleteFavoriteItem)
                    .onMove(perform: moveFavoriteItem)
                
            }.onAppear(perform : viewModel.fetchFavoriteItems)
            
            Spacer()
      
}
    func deleteFavoriteItem(at offsets: IndexSet) {
        for offset in offsets {
                    let symbol = viewModel.favorites[offset].symbol
                    viewModel.deleteFavorite(symbol: symbol)
                }
//        viewModel.deleteFavorite(at: offsets)
    }

    func moveFavoriteItem(from source: IndexSet, to destination: Int) {
        viewModel.moveFavorite(from: source, to: destination)
    }
}

struct FavoritesItemView: View {
    let item: FavoriteItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(item.symbol)")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("$\(String(format: "%.2f", item.currentPrice))")
                    .font(.body)
                    .fontWeight(.bold)
            }
            HStack {
                Text("\(item.name)") // Assuming item.name is the company name
                    .font(.body)
                Spacer()
                if item.difference < 0 {
                    Image(systemName: "arrow.down.right")
                        .foregroundColor(.red)
                } else if item.difference > 0 {
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.green)
                }
                else{
                    Image(systemName: "minus")
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("$\(String(format: "%.2f", item.difference)) (\(String(format: "%.2f", (item.difference * 100) / item.currentPrice))%)")
                    .font(.body)
                    .foregroundColor(item.difference < 0 ? .red : (item.difference > 0 ? .green : .gray))
            }
        }
        .padding(.horizontal, 8)
    }
}

//struct FavoritesItemView: View {
//    let item: FavoriteItem
//    @State private var currentResponse: CurrentPriceResponse? // Store current price response as a state variable
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text("\(item.symbol)")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                Spacer()
//                if let currentPrice = currentResponse?.c, let difference = currentResponse?.d {
//                    Text("$\(String(format: "%.2f", currentPrice))")
//                        .font(.body)
//                        .fontWeight(.bold)
//                } else {
//                    Text("Loading...") // Placeholder for loading state
//                        .font(.body)
//                        .fontWeight(.bold)
//                }
//            }
//            HStack {
//                Text("\(item.name)")
//                    .font(.body)
//                Spacer()
//                if  let difference = currentResponse?.d {
//                    if difference < 0 {
//                        Image(systemName: "arrow.down.right")
//                            .foregroundColor(.red)
//                    } else if difference > 0 {
//                        Image(systemName: "arrow.up.right")
//                            .foregroundColor(.green)
//                    }
//                    else {
//                        Image(systemName: "minus")
//                            .foregroundColor(.gray)
//                    }
//                }
//                else {
//                    Text("N/A")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                }
//                Spacer()
//                if let currentPrice = currentResponse?.c, let difference = currentResponse?.d, currentPrice != 0 {
//                    Text("$\(String(format: "%.2f", difference)) (\(String(format: "%.2f", (difference * 100) / currentPrice))%)")
//                        .font(.body)
//                        .foregroundColor(difference < 0 ? .red : (difference > 0 ? .green : .gray))
//                } else {
//                    Text("N/A")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                }
//            }
//        }
//        .padding(.horizontal, 8)
//        .onAppear {
//            fetchCurrentPrice()
//            // Start a timer to fetch current price every 15 seconds
//            Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
//                fetchCurrentPrice()
//            }
//        }
//    }
//    
//    private func fetchCurrentPrice() {
//        // Fetch current price response for the symbol
//        FavoritesSectionViewModel().fetchCurrentPrice(for: item.symbol) { response in
//            // Update current price response when fetched
//            currentResponse = response
//        }
//    }
//}



struct FavoritesSectionView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesSectionView(viewModel: FavoritesSectionViewModel())
    }
}


