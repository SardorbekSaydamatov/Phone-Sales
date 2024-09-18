//
//  Hisobot.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 11/07/24.
//

import SwiftUI

struct Hisobot: View {
    @StateObject var viewModel = SaledStatisticsViewModel()
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(viewModel.statistics) { datum in
                Text("Barcha mahsulotlar: \(datum.totalNumberOfSales) ta")
                Text("Barcha to'lovlar: \(datum.totalNumberOfPayments) ta")
                Text("O'rtacha savdo: \(datum.averageSaleAmount) summa")
                Text("Umimiy savdo: \(datum.totalSalesAmount) summa")
                Text("To'langan savdo: \(datum.totalPaidAmount) summa")
                Text("Nasyalar: \(datum.totalUnpaidAmount) summa")
                Text("Foyda: \(datum.totalProfit) summa")
            }
            Spacer()
        }
        .padding(.top, 50)
        .navigationTitle("Ombor haqida umumiy ma'lumot")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            viewModel.loadStatistics()
        })
    }
}

#Preview {
    NavigationStack {
        Hisobot()
    }
}
