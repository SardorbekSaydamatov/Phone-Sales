//
//  SaledStatistics.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 07/08/24.
//

import Foundation

struct SaledStatisticsResponse: Codable {
    let success: Bool
    let data: [Datum]
}

struct Datum: Codable, Identifiable {
    var id: Int { totalSalesAmount.hashValue ^ totalNumberOfSales.hashValue }
    let totalSalesAmount, totalNumberOfSales: Int
    let averageSaleAmount: Double
    let totalNumberOfPayments, totalPaidAmount, totalUnpaidAmount, totalProfit: Int
}
