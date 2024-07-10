//
//  ProductsCartView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 01/07/24.
//

import SwiftUI

struct ProductDetailView: View {
    @StateObject var viewModel = ProductViewModel()
    @State var id: String = ""
    @State var showCost: Bool = false
    @State var showSellView: Bool = false
    @State var showProductAddView: Bool = false
    @State var showMenu: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let product = viewModel.selectedProduct {
                
                Text(product.name)
                    .font(.largeTitle)
                Text("Imei: \(product.imei)")
                    .font(.title2)
                
                HStack(spacing: 10) {
                    ForEach(product.images, id: \.self) {image in
                        AsyncImage(url: URL(string: image)) {image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                        } placeholder: {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                                .foregroundStyle(Color.init(.secondarySystemBackground))
                        }
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(product.isNew ? "Xolati: Yangi" : "Xolati: Ishlatilgan")
                        Divider()
                            .background(.primary)
                        Text(product.haveDocument ? "Dokument: bor" : "Dokument: Yo'q")
                        Divider()
                            .background(.primary)
                        Text("Olingan odam: \(product.infoAboutOwner)")
                    }
                    Spacer()
                    
                    VStack (alignment: .leading, spacing: 10) {
                        if showCost {
                            Text("Kelgan narxi: \(product.cost)")
                            Divider()
                                .background(.primary)
                        }
                        Text("Sotish narxi: \(product.price)")
                        Divider()
                            .background(.primary)
                        Text("Kelgan sana: \(formatDate(product.createdAt))")
                    }
                }
                
                Text("Qo'shimcha ma'lumot")
                    .font(.title2)
                    .padding(.leading, 50)
                    .padding()
                
                Text(product.extraInfo)
                    .multilineTextAlignment(.center)
            } else {
                Text("Mahsulot topilmadi!")
                    .font(.title)
                    .padding(.top, 40)
            }
            
            Spacer()
        }
        .onAppear(perform: {
            viewModel.findProductById(id)
        })
        .navigationDestination(isPresented: $showProductAddView, destination: {
            if let selectedProduct = viewModel.selectedProduct {
                ProductAddView(
                    productId: id,
                    productName: selectedProduct.name,
                    productIMEI: selectedProduct.imei,
                    originalPrice: String(selectedProduct.price),
                    sellPrice: String(selectedProduct.cost),
                    additionInfo: selectedProduct.extraInfo,
                    ownerInfo: selectedProduct.infoAboutOwner,
                    documentTicked: selectedProduct.haveDocument,
                    isNewTicked: selectedProduct.isNew,
                    imageArr2: selectedProduct.images
                )
            }
        })
        .navigationDestination(isPresented: $showSellView, destination: {
            SellView(viewModel: viewModel, id: id)
        })
        .sheet(isPresented: $showMenu, content: {
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    showSellView.toggle()
                    showMenu.toggle()
                }, label: {
                    Text("Sotish")
                })
                
                Button(action: {
                    showProductAddView.toggle()
                    showMenu.toggle()
                }, label: {
                    Text("Tahrirlash")
                })
                
                Button(action: {
                    deleteProduct()
                    showMenu.toggle()
                }, label: {
                    Text("O'chirish")
                })
            }
            .foregroundStyle(.primary)
            .presentationDetents([.height(150)])
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showMenu.toggle()
                }, label: {
                    Image(systemName: "ellipsis")
                })
                .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal)
    }
    
    private func deleteProduct() {
        let service = AddProductService()
        service.deleteProduct(productID: id) { result in
            switch result {
            case .success():
                viewModel.selectedProduct = nil
                print("Product deleted successfully.")
            case .failure(let error):
                print("Failed to delete product: \(error.localizedDescription)")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
}

//#Preview {
//    NavigationStack {
//        ProductDetailView()
//    }
//}
