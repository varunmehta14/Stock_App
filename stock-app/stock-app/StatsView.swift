//
//  StatsView.swift
//  stock-app
//
//  Created by Varun Mehta on 17/04/24.
//

import SwiftUI

struct StatsView: View {
    let stockData: StockData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stats")
                .font(.title)
                .padding(.bottom, 5)
                        
            HStack{
                VStack(alignment:.leading){
                    HStack{
                        Text("High Price:").fontWeight(.bold).font(.body)
                        Text("$\(String(format: "%.2f", stockData.quoteData.h))").font(.body)
                    }.padding(.bottom,1)
                    HStack{
                        Text("Open Price:").fontWeight(.bold).font(.body)
                        Text("$\(String(format: "%.2f", stockData.quoteData.o))").font(.body)
                    }
                    
                }
                Spacer()
                VStack(alignment:.leading){
                    HStack{
                        Text("Low Price:").fontWeight(.bold).font(.body)
                        Text("$\(String(format: "%.2f", stockData.quoteData.l))").font(.body)
                    }.padding(.bottom,1)
                    HStack{
                        Text("Prev. Close:").fontWeight(.bold).font(.body)
                        Text("$\(String(format: "%.2f", stockData.quoteData.pc))").font(.body)
                    }
                }
               
            }
        }
    }
}


//#Preview {
//    StatsView()
//}
