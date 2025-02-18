//
//  CurrentPriceRsponse.swift
//  stock-app
//
//  Created by Varun Mehta on 27/04/24.
//

import Foundation

struct CurrentPriceResponse: Codable {
    let c: Double // Current price
    let d: Double // Difference from previous close
    let dp: Double // Difference percentage
    let h: Double // High price
    let l: Double // Low price
    let o: Double // Open price
    let pc: Double // Previous close price
    let t: Int // Time (timestamp)
}
