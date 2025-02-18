//
//  PortfolioItem.swift
//  stock-app
//
//  Created by Varun Mehta on 08/04/24.
//

// PortfolioItem.swift

import Foundation

struct PortfolioItem: Codable {
   
    let symbol: String
    let name: String
    let quantity: Int
    let totalCost: Double
    let averageValuePerShare: Double
    let change: Double
    let currentPrice: Double
    let marketValue: Double
}

struct PortfolioRepositories:Codable{
    let portfolios:[PortfolioItem]
}



