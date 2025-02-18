//
//  SearchSuggestionsView.swift
//  stock-app
//
//  Created by Varun Mehta on 21/04/24.
//

import SwiftUI

struct SearchSuggestionsView: View {
    @ObservedObject var searchViewModel: SearchBarViewModel
    
    var body: some View {
        Section{
            ScrollView {
                VStack {
                    ForEach(searchViewModel.suggestions, id: \.displaySymbol) { suggestion in
                        NavigationLink(destination: StockDetailView(symbol: suggestion.displaySymbol)) {
                            VStack{
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(suggestion.displaySymbol)
                                            .font(.title3)
                                            .foregroundColor(.black)
                                            .bold()
                                        Text(suggestion.description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 1)
                                    
                                    
                                }
                                
                                .padding(.horizontal)
                                .padding(.top, 5)
                                Divider()
                            }
                           
                           
                        }
                   }
               }
            }.background(Color.white)
        }
       
    }
}

struct SearchSuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSuggestionsView(searchViewModel: SearchBarViewModel())
    }
}

