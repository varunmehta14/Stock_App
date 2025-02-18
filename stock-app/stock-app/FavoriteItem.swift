//
//  FavoriteItem.swift
//  stock-app
//
//  Created by Varun Mehta on 08/04/24.
//

// FavoriteItem.swift
import Foundation

struct FavoriteItem: Codable { // Ensure FavoriteItem conforms to Identifiable
    let symbol: String
    let name: String
    let currentPrice: Double
    let difference: Double
    let differencePercentage: Double
}

struct FavoriteRepositories:Codable{
    let favorites:[FavoriteItem]
}

