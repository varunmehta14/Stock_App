//
//  SearchData.swift
//  stock-app
//
//  Created by Varun Mehta on 12/04/24.
//

import SwiftUI

import Foundation

// Define structures to match the JSON response

struct StockData: Codable {
    let quoteData: QuoteData
    let profileData: ProfileData
    let peersData: [String] // Change to array of strings
    let earningsData: [EarningsItem]? // hange to array of EarningsItem
    let sentimentData: SentimentData
    let recommendationData: [RecommendationItem]? // Change to array of RecommendationItem
    let newsData: [NewsItem] // Change to array of NewsItem
}


struct QuoteData: Codable {
    let c: Double
    let d: Double
    let dp: Double
    let h: Double
    let l: Double
    let o: Double
    let pc: Double
    let t: Int
}

struct ProfileData: Codable {
    let country: String
    let currency: String
    let estimateCurrency: String
    let exchange: String
    let finnhubIndustry: String
    let ipo: String
    let logo: String
    let marketCapitalization: Double
    let name: String
    let phone: String
    let shareOutstanding: Double
    let ticker: String
    let weburl: String
}

struct EarningsItem: Codable {
    let actual: Double
    let estimate: Double
    let period: String
    let quarter: Int
    let surprise: Double
    let surprisePercent: Double
    let symbol: String
    let year: Int
}

struct SentimentData: Codable {
    let data: [SentimentItem]
    let symbol: String
}

struct SentimentItem: Codable {
    let symbol: String
    let year: Int
    let month: Int
    let change: Int
    let mspr: Double
}

struct RecommendationItem: Codable {
    let buy: Int
    let hold: Int
    let period: String
    let sell: Int
    let strongBuy: Int
    let strongSell: Int
    let symbol: String
}

struct NewsItem: Codable,Identifiable,Equatable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let id: Int
    let image: String?
    let related: String
    let source: String
    let summary: String
    let url: String
}





