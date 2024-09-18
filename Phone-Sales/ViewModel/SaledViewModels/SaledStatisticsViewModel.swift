//
//  SaledStatisticsViewModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 07/08/24.
//

import Foundation

class SaledStatisticsViewModel: ObservableObject {
    @Published var statistics: [Datum] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = GetSaledStatistics()
    
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
