//
//  HomeViewModel.swift
//  stock-app
//
//  Created by Varun Mehta on 07/04/24.
//

// ViewModels
// HomeViewModel.swift
import Foundation

class HomeViewModel: ObservableObject {
    @Published var currentDate: String = ""
//    @Published var portfolioViewModel = PortfolioSectionViewModel()
//    @Published var favoritesViewModel = FavoritesSectionViewModel()
//    
    // Initialize view model with current date and other data
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        currentDate = dateFormatter.string(from: Date())
    }
}

