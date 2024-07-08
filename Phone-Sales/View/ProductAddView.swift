//
//  ProductAddView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 28/06/24.
//

import SwiftUI

struct ProductAddView: View {
    @State private var productName: String = ""
    @State private var productIMEI: String = ""
    @State private var originalPrice: String = ""
    @State private var sellPrice: String = ""
    @State private var additionInfo: String = ""
    @State private var ownerInfo: String = ""
    @State private var documentTicked: Bool = false
    @State private var isNewTcked: Bool = false
    
    @State private var imageArr: [UIImage] = []
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isShowingImageCropper = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var isProductSaved = false

    private let storageService = FirebaseStorageService()
    private let productService = AddProductService()
    
    var body: some View {
        ZStack {
            VStack {
                YTextField(text: $productName, placeholder: "Mahsulot nomi: Apple Vision Pro 2")
                YTextField(text: $productIMEI, placeholder: "23122342342344376")
                YTextField(text: $originalPrice, placeholder: "Kelish narxi: 4000")
                YTextField(text: $sellPrice, placeholder: "Sotilish narxi: 4400")
                YTextField(text: $ownerInfo, placeholder: "Owner Info")
                
                infoTextField
                
                HStack {
                    CheckboxView(isChecked: $documentTicked, title: "Dokument bormi?")
                    Spacer()
                    CheckboxView(isChecked: $isNewTcked, title: "Yangimi?")
                }
                .padding(.vertical)
                
                HStack(spacing: 20) {
                    ForEach(imageArr.indices, id: \.self) { index in
                        Image(uiImage: imageArr[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Button(action: {
                                    imageArr.remove(at: index)
                                }, label: {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(.red)
                                        .padding(5)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .offset(x: 15, y: -15)
                                })
                                .opacity(0.8)
                                .padding(.leading, -5)
                                .padding(.top, -5),
                                alignment: .topTrailing
                            )
                    }
                }
                
                buttons
            }
            .scrollable(showIndicators: false)
            .padding()
            .navigationTitle("Mahsulot qo'shish")
            .navigationBarTitleDisplayMode(.inline)
            if isLoading {
                ProgressView("Loading...")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $isProductSaved) {
            Alert(
                title: Text("Success"),
                message: Text("Mahsulot muvaffaqiyatli qo'shildi!"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var infoTextField: some View {
        TextField("", text: $additionInfo, prompt: Text("Qo'shimcha ma'lumot").foregroundStyle(Color.gray), axis: .vertical)
            .lineLimit(3, reservesSpace: true)
            .font(Font.custom("Raleway", size: 16))
            .padding()
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1)
            )
    }
    
    private var buttons: some View {
        VStack {
            Button(action: {
                if imageArr.count < 2 {
                    isShowingImagePicker = true
                } else {
                    alertMessage = "Ikkitadan ko'p rasm yuklab bo'lmadyi."
                    showAlert = true
                }
            }, label: {
                Text("Rasm tanlash")
            })
            
            SubmitButton(title: "Saqlash") {
                saveProduct()
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    isShowingImageCropper = true
                }
        }
        .sheet(isPresented: $isShowingImageCropper) {
            ImageCropper(image: $selectedImage)
                .onDisappear {
                    if let croppedImage = selectedImage {
                        imageArr.append(croppedImage)
                        selectedImage = nil
                    }
                }
        }
    }
    
    private func saveProduct() {
        guard let cost = Double(originalPrice), let price = Double(sellPrice) else {
            alertMessage = "Iltimos kerakli ma'lumotlarni kiriting."
            showAlert = true
            return
        }
        
        isLoading = true
        
        storageService.uploadImages(imageArr) { urls, error in
            if let error = error {
                alertMessage = "Rasmlarni yuklashda muammo: \(error.localizedDescription)"
                showAlert = true
                isLoading = false
                return
            }
            
            guard let urls = urls else {
                alertMessage = "Rasmlar yuklanmadi."
                showAlert = true
                isLoading = false
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
            
            productService.addProduct(product: product) { result in
                isLoading = false
                
                switch result {
                case .success:
                    isProductSaved = true
                    productIMEI = ""
                    productName = ""
                    isNewTcked = false
                    originalPrice = ""
                    sellPrice = ""
                    additionInfo = ""
                    ownerInfo = ""
                    documentTicked = false
                case .failure(let error):
                    alertMessage = "Failed to save product: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    ProductAddView()
}
