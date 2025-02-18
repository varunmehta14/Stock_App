//
//  ChartData.swift
//  stock-app
//
//  Created by Varun Mehta on 27/04/24.
//

import Foundation

struct ChartData: Codable {
    let v: Double // Volume
    let vw: Double // Volume Weighted Average Price
    let o: Double // Open
    let c: Double // Close
    let h: Double // High
    let l: Double // Low
    let t: Double // Timestamp
    let n: Double // Number of Trades
}

struct ChartDataResponse: Codable {
    let chartData: [ChartData]
}

