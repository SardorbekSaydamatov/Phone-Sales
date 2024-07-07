//
//  ProductStatisticsViewModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 07/07/24.
//

import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var statistics: [ProductStatistics] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = GetProductStatistics()
    
    func loadStatistics() {
        isLoading = true
        errorMessage = nil
        
        service.getStatistics { [weak self] statistics in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let statistics = statistics {
                    self?.statistics = statistics
                } else {
                    self?.errorMessage = "Failed to load statistics"
                }
            }
        }
    }
}

