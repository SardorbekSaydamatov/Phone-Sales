//
//  HisobotView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 06/07/24.
//

import SwiftUI

struct HisobotView: View {
    @StateObject var viewModel = StatisticsViewModel()
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if viewModel.statistics.isEmpty {
                Text("No statistics available")
            } else {
                
                ForEach(viewModel.statistics) {stat in
                    Text("Asosiy ma'lumotlar")
                        .font(.title)
                        .position(x: UIScreen.main.bounds.width / 2)
                        .padding(.top)
                    Text("Barcha mahsulotlar: \(stat.totalProducts)ta")
                    Text("Jami kelish narxi: \(stat.totalCost)")
                    Text("Jami sotilish narxi: \(stat.totalPrice)")
                    
                    Divider()
                        .background(.primary)
                        .frame(height: 2)
                    
                    Text("Qo'shimcha ma'lumotlar")
                        .font(.title)
                        .position(x: UIScreen.main.bounds.width / 2)
                        .padding(.top)
                    
                    Text("Yangi mahsulotlar: \(stat.newProductsCount)ta")
                    Text("Dokumenti borlar: \(stat.documentCount)ta")
                    Text("Sotish narxi borlar: \(stat.productsWithPriceCount)ta")
                    Text("Ortacha kelish narxi: \(stat.averageCost)")
                    Text("O'rtacha sotilish narxi: \(stat.averagePrice)")
                }
            }
        }
        .onAppear(perform: {
            viewModel.loadStatistics()
        })
        .padding()
        .scrollable()
    }
}

#Preview {
    HisobotView()
}
