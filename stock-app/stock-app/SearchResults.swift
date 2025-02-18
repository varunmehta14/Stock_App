//
//  SearchResults.swift
//  stock-app
//
//  Created by Varun Mehta on 21/04/24.
//

// Define a struct representing each item in the response
struct SearchResults: Codable {
    let description: String
    let displaySymbol: String
    let symbol:String
    let type:String
}

struct SearchResponse: Decodable {
    let count: Int
    let result: [SearchResults]
}
