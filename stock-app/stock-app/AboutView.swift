//
//  AboutView.swift
//  stock-app
//
//  Created by Varun Mehta on 17/04/24.
//

import SwiftUI

struct AboutView: View {
    let stockData: StockData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("About")
                .font(.title)
            HStack{
                VStack(alignment:.leading){
                    Text("IPO Start Date:").fontWeight(.bold).padding(.bottom, 0.7)
                    Text("Industry:").fontWeight(.bold).padding(.bottom, 0.7)
                    Text("Webpage:").fontWeight(.bold).padding(.bottom, 0.7)
                    Text("Company Peers:").fontWeight(.bold).padding(.bottom, 0.7)
                }
                Spacer()
                VStack(alignment:.leading){
                    Text("\(stockData.profileData.ipo)").padding(.bottom, 0.7)
                    Text("\(stockData.profileData.finnhubIndustry)").padding(.bottom, 0.7)
                    if let webpageURL = URL(string: stockData.profileData.weburl) {
                        Link(stockData.profileData.weburl, destination: webpageURL).padding(.bottom, 0.7)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(stockData.peersData, id: \.self) { peer in
                                NavigationLink(destination: StockDetailView(symbol: peer)) {
                                    Text(peer)
                                        .foregroundColor(.blue)
                                        .padding(.bottom, 0.7)
    //                                    .underline()
                                }
                            }
                        }
                    }
                }
            }
            
            

        }
//        .padding()
    }
}



//
//#Preview {
//    AboutView()
//}
