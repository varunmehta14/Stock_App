//
//  PortfolioSectionView.swift
//  stock-app
//
//  Created by Varun Mehta on 07/04/24.
//

//import SwiftUI
//
//struct PortfolioItemView: View {
//    let item: PortfolioItem
//    
//    var body: some View {
//        VStack {
//            Text("Symbol: \(item.symbol)")
//            Text("Name: \(item.name)")
//            Text("Quantity: \(item.quantity)")
//        }.padding(.horizontal, 8)
//    }
//}
//
//struct PortfolioSectionView: View {
//    @ObservedObject var viewModel: PortfolioSectionViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Cash Balance: \(viewModel.cashBalance)")
//            Text("Net Worth: \(viewModel.netWorth)")
//            
//            List {
//                ForEach(viewModel.portfolioItems, id: \.symbol) { item in
//                    PortfolioItemView(item: item)
//                }
//                .onDelete(perform: deletePortfolioItems)
//                .onMove(perform: movePortfolioItem)
//            }
//            .listStyle(InsetGroupedListStyle()) // Apply InsetGroupedListStyle
//                   }
//                   .padding()
//    }
//    
//    
//    func deletePortfolioItems(at offsets: IndexSet) {
////        for index in offsets {
//            viewModel.deletePortfolioItem(at: offsets)
////        }
//    }
//    
//    func movePortfolioItem(from source: IndexSet, to destination: Int) {
//        viewModel.movePortfolioItem(from: source, to: destination)
//    }
//}
//
//
//
//struct PortfolioSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PortfolioSectionView(viewModel: PortfolioSectionViewModel())
//    }
//}

import SwiftUI

struct PortfolioItemView: View {
    
    let item: PortfolioItem

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
                    Text("\(item.quantity) shares")
                        .font(.body)
                   
                    Spacer()
                    if item.change < 0 {
                        Image(systemName: "arrow.down.right")
                            .foregroundColor(.red)
                    } else if item.change > 0 {
                        Image(systemName: "arrow.up.right")
                            .foregroundColor(.green)
                    }
                    else{
                        Image(systemName: "minus")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("$\(String(format: "%.2f", item.change)) (\(String(format: "%.2f", (item.change * 100) / item.currentPrice))%)")
                        .font(.body)
                        .foregroundColor(item.change < 0 ? .red : (item.change > 0 ? .green : .gray))
                }
            }
//            .padding(.vertical, 8)
        }
}

//struct PortfolioSectionView: View {
//    @ObservedObject var viewModel = PortfolioSectionViewModel()
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Text("Net Worth")
//                    .font(.title2)
//                Spacer()
//                Text("Cash Balance")
//                    .font(.title2)
//            }
//            HStack {
//                Text("$\(viewModel.netWorth, specifier: "%.2f")")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                Spacer()
//                Text("$\(viewModel.cashBalance, specifier: "%.2f")")
//                    .font(.title2)
//                    .fontWeight(.bold)
//            }
//            
//            
//            Divider()
//            
////                                    ScrollView {
//                                                    VStack(alignment: .leading, spacing: 16) {
//                                                        List{
//                                                            ForEach(viewModel.portfolioItems, id: \.symbol) { item in
//                                                                NavigationLink(destination: StockDetailView(symbol: item.symbol)) {
//                                                                    PortfolioItemView(item: item)
//                                                                }
//                                                                .buttonStyle(PlainButtonStyle()) // Remove default styling
//                                                                                            .foregroundColor(.primary) // Text color
//                
//                                                                                            .background(Color.clear) // Remove background color
//                                                                                            .frame(maxWidth: .infinity, alignment: .leading) // Fill the width
//                
//                                                            }.onMove(perform: { indices, newOffset in
//                                                                viewModel.portfolioItems.move(fromOffsets: indices, toOffset: newOffset)
//                                                            })
//                                                        }.onAppear(perform : viewModel.fetchPortfolioItems)
//                                                        
//                                                    }
//
//        .onAppear{
//            Task{
//                await viewModel.fetchWalletBalance()
//                await viewModel.fetchPortfolioItems()
//                await viewModel.calculateNetWorth()
//            }
//        }
//        .padding()
//    }
//
//    
//}
//
//struct PortfolioSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        PortfolioSectionView()
//    }
//}






