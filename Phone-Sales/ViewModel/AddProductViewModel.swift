import Foundation
import SwiftUI

class AddProductViewModel: ObservableObject {
    private let storageService = FirebaseStorageService()
    private let productService = AddProductService()
    
    @Published var isLoading = false
    @Published var isProductSaved = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    func saveProduct(
        productName: String,
        productIMEI: String,
        originalPrice: String,
        sellPrice: String,
        additionInfo: String,
        ownerInfo: String,
        documentTicked: Bool,
        isNewTcked: Bool,
        imageArr: [UIImage],
        productID: String = ""
    ) {
        guard let cost = Double(originalPrice), let price = Double(sellPrice) else {
            alertMessage = "Iltimos kerakli ma'lumotlarni kiriting."
            showAlert = true
            return
        }
        
        isLoading = true
        
        storageService.uploadImages(imageArr) { [weak self] urls, error in
            guard let self = self else { return }
            
            if let error = error {
                self.alertMessage = "Rasmlarni yuklashda muammo: \(error.localizedDescription)"
                self.showAlert = true
                self.isLoading = false
                return
            }
            
            guard let urls = urls else {
                self.alertMessage = "Rasmlar yuklanmadi."
                self.showAlert = true
                self.isLoading = false
                return
            }
            
            let product = AddProductModel(
                cost: cost,
                extra_info: additionInfo,
                have_document: documentTicked,
                images: urls.map { $0.absoluteString },
                name: productName,
                imei: productIMEI,
                info_about_owner: ownerInfo,
                is_new: isNewTcked,
                price: price
            )
            
            self.productService.addProduct(product: product, productID: productID) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch result {
                    case .success:
                        self.isProductSaved = true
                    case .failure(let error):
                        self.alertMessage = "Mahsulot saqlashda xatolik yuz berdi: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                }
            }
        }
    }
}

