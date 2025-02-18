//
//  StockItem.swift
//  stock-app
//
//  Created by Varun Mehta on 10/04/24.
//

import Foundation

struct StockItem:Codable {
    var symbol: String
    var marketValue: Double
    var changeInPrice: Double
    var totalSharesOwned: Int
}
