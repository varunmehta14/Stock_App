//
//  InsiderSentimentTableView.swift
//  stock-app
//
//  Created by Varun Mehta on 17/04/24.
//

//import SwiftUI
//
//struct InsiderSentimentTableView: View {
//   
//    let sentimentData: SentimentData
//        var body: some View {
//        VStack {
//           
//            Text(sentimentData.symbol)
//            
//            // Calculate total, positive, and negative MSPR and change values
//            let totalMSPR = sentimentData.data.reduce(0) { $0 + $1.mspr }
//            let positiveMSPR = sentimentData.data.filter { $0.mspr > 0 }.reduce(0) { $0 + $1.mspr }
//            let negativeMSPR = sentimentData.data.filter { $0.mspr < 0 }.reduce(0) { $0 + $1.mspr }
//            
//            let totalChange = sentimentData.data.reduce(0) { $0 + Double($1.change) }
//            let positiveChange = sentimentData.data.filter { $0.change > 0 }.reduce(0) { $0 + Double($1.change) }
//            let negativeChange = sentimentData.data.filter { $0.change < 0 }.reduce(0) { $0 + Double($1.change) }
//            
//            // Display the table
//            List {
//                Section(header: Text("Total")) {
//                    Text("MSPR: \(totalMSPR)")
//                    Text("Change: \(totalChange)")
//                }
//                Section(header: Text("Positive")) {
//                    Text("MSPR: \(positiveMSPR)")
//                    Text("Change: \(positiveChange)")
//                }
//                Section(header: Text("Negative")) {
//                    Text("MSPR: \(negativeMSPR)")
//                    Text("Change: \(negativeChange)")
//                }
//            }
//        }
//    }
//}
//struct InsiderSentimentTableView: View {
//    let sentimentData: SentimentData
//    
//    var body: some View {
//        VStack {
//            Text(sentimentData.symbol)
//                .font(.headline)
//                .padding(.bottom, 10)
//            
//            // Iterate over SentimentItem array and print each item's properties
//            ForEach(sentimentData.data, id: \.year) { sentimentItem in
//                VStack {
//                    Text("Year: \(sentimentItem.year)")
//                    Text("Month: \(sentimentItem.month)")
//                    Text("Change: \(sentimentItem.change)")
//                    Text("MSPR: \(sentimentItem.mspr)")
//                    Divider() // Add divider between each SentimentItem
//                }
//                .padding(.vertical, 5)
//            }
//        }
//        .padding()
//    }
//}
import SwiftUI

struct InsiderSentimentTableView: View {
    let sentimentData: SentimentData
    let companyName:String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Insights")
                .font(.title)
                .padding(.bottom, 5)
            HStack{
                Spacer()
                Text("Insider Sentiments")
                    .font(.title)
                    .padding(.bottom, 10)
                Spacer()
            }
            
            
            // Calculate total, positive, and negative MSPR and change values
            let totalMSPR = sentimentData.data.reduce(0) { $0 + $1.mspr }
            let positiveMSPR = sentimentData.data.filter { $0.mspr > 0 }.reduce(0) { $0 + $1.mspr }
            let negativeMSPR = sentimentData.data.filter { $0.mspr < 0 }.reduce(0) { $0 + $1.mspr }
            
            let totalChange = sentimentData.data.reduce(0) { $0 + Double($1.change) }
            let positiveChange = sentimentData.data.filter { $0.change > 0 }.reduce(0) { $0 + Double($1.change) }
            let negativeChange = sentimentData.data.filter { $0.change < 0 }.reduce(0) { $0 + Double($1.change) }
            
            // Display the table
            VStack {
                HStack {
                    Text(companyName)
                        .font(.headline)
                    Spacer()
                    Text("MSPR ").fontWeight(.bold)
                    Spacer()
                    Text("Change ").fontWeight(.bold)
                }
                
                .padding(.horizontal)
                
                Divider()
                
                VStack(spacing: 10) {
                                   HStack {
                                       Text("Total").fontWeight(.bold)
                                       Spacer()
                                       Text(String(format: "%.2f", totalMSPR))
                                       Spacer()
                                       Text(String(format: "%.2f", totalChange))
                                   }
                                   Divider() // Horizontal line
                                   HStack {
                                       Text("Positive").fontWeight(.bold)
                                       Spacer()
                                       Text(String(format: "%.2f", positiveMSPR))
                                       Spacer()
                                       Text(String(format: "%.2f", positiveChange))
                                   }
                                   Divider() // Horizontal line
                                   HStack {
                                       Text("Negative").fontWeight(.bold)
                                       Spacer()
                                       Text(String(format: "%.2f", negativeMSPR))
                                       Spacer()
                                       Text(String(format: "%.2f", negativeChange))
                                   }
                               }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}
