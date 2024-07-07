//
//  SellView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 05/07/24.
//

import SwiftUI


struct SellView: View {
    @StateObject var viewModel = ProductViewModel()
    @State var id: String = ""
    @State var title: String = "Iphone 11"
    @State var customerName: String = ""
    @State var phoneNumber: String = ""
    @State var extraInfo: String = ""
    @State var price: String = "4500"
    @State var firstPayment: String = "0"
    @State var numberOfPayments: String = "3"
    @State var duration: String = "10"
    @State var installmentTapped: Bool = false
    @State var isLoading: Bool = false
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if let product = viewModel.selectedProduct {
                Text(product.name)
                    .font(.title)
                YTextField(text: $customerName, placeholder: "Haridor ismi:")
                YTextField(text: $phoneNumber, placeholder: "Telefon raqami:")
                YTextField(text: $extraInfo, placeholder: "Qo'shimcha ma'lumot:")
                YTextField(text: $price, placeholder: "Narxi:")
                
                HStack {
                    Button(action: {
                        installmentTapped.toggle()
                    }, label: {
                        Text("Mudatli savdomi?")
                    })
                    Spacer()
                    Image(systemName: installmentTapped ? "checkmark" : "")
                        .foregroundStyle(Color.blue)
                }
                .padding(.horizontal)
                
                YTextField(text: $firstPayment, placeholder: "Birinchi to'lov", color: installmentTapped ? .blue : .gray, disabled: !installmentTapped)
                HStack {
                    YTextField(text: $numberOfPayments, placeholder: "To'lovlar soni", color: installmentTapped ? .blue : .gray, disabled: !installmentTapped)
                    YTextField(text: $duration, placeholder: "To'lovlar oralig'i", color: installmentTapped ? .blue : .gray, disabled: !installmentTapped)
                }
                SubmitButton(title: "Submit") {
                    submitTapped()
                    title = ""
                    customerName = ""
                    phoneNumber = ""
                    extraInfo = ""
                    price = ""
                }
            }
            if isLoading {
                ProgressView()
                    .padding()
            }
        }
        .onAppear {
            viewModel.findProductById(id)
        }
        .onDisappear {
            viewModel.selectedProduct = nil
        }
        .scrollable()
        .scrollDismissesKeyboard(.interactively)
        .dismissKeyboardOnTap()
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func submitTapped() {
        guard !customerName.isEmpty, !extraInfo.isEmpty, !price.isEmpty else {
            alertMessage = "Ism, qo'shimcha ma'lumot va narx bo'limlari to'ldirilishi kerak"
            showAlert = true
            return
        }
        
        isLoading = true
        
        let sale = Sale(
            productId: id,
            buyer: customerName,
            description: extraInfo,
            amount: Double(price) ?? 0,
            instalmentCount: installmentTapped ? Int(numberOfPayments) : nil,
            delayInDays: installmentTapped ? Int(duration) : nil,
            firstPayment: installmentTapped ? Double(firstPayment) : nil,
            phone: phoneNumber.isEmpty ? nil : phoneNumber
        )
        
        SaleService().createSale(sale: sale) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success():
                    alertMessage = "Sotuv muvaffaqiyatli amalga oshirildi!"
                    showAlert = true
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    SellView()
}
