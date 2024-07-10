//
//  ProductAddView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 28/06/24.
//

import SwiftUI



struct ProductAddView: View {
    @StateObject private var addViewModel = AddProductViewModel()
    
    @State var productId: String = ""
    @State var productName: String = ""
    @State var productIMEI: String = ""
    @State var originalPrice: String = ""
    @State var sellPrice: String = ""
    @State var additionInfo: String = ""
    @State var ownerInfo: String = ""
    @State var documentTicked: Bool = false
    @State var isNewTicked: Bool = false
    @State var imageArr: [UIImage] = []
    @State var imageArr2: [String] = []
    @State var selectedImage: UIImage?
    @State var isShowingImagePicker = false
    @State var isShowingImageCropper = false
    @State private var buttonDisabled: Bool = true
    @State private var validationAlertMessage: String = ""
    @State private var showValidationAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                YTextField(text: $productName, placeholder: "Mahsulot nomi: Apple Vision Pro 2")
                    .onChange(of: productName) {
                        buttonDisabled = false
                    }
                YTextField(text: $productIMEI, placeholder: "23122342342344376")
                    .onChange(of: productIMEI) {
                        buttonDisabled = false
                    }
                YTextField(text: $originalPrice, placeholder: "Kelish narxi: 4000")
                    .onChange(of: originalPrice) {
                        buttonDisabled = false
                    }
                YTextField(text: $sellPrice, placeholder: "Sotilish narxi: 4400")
                    .onChange(of: sellPrice) {
                        buttonDisabled = false
                    }
                YTextField(text: $ownerInfo, placeholder: "Owner Info")
                    .onChange(of: ownerInfo) {
                        buttonDisabled = false
                    }
                
                infoTextField
                
                HStack {
                    CheckboxView(isChecked: $documentTicked, title: "Dokument bormi?")
                        .onChange(of: documentTicked) {
                            buttonDisabled = false
                        }
                    Spacer()
                    CheckboxView(isChecked: $isNewTicked, title: "Yangimi?")
                        .onChange(of: isNewTicked) {
                            buttonDisabled = false
                        }
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
                                    buttonDisabled = false
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
            .navigationTitle(productId == "" ? "Mahsulot qo'shish" : "Mahsulotni tahrirlash")
            .navigationBarTitleDisplayMode(.inline)
            
            if addViewModel.isLoading {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            if imageArr == [] {
                fetchImages()
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .alert(isPresented: $addViewModel.showAlert) {
            Alert(title: Text("Xatolik"), message: Text(addViewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $addViewModel.isProductSaved) {
            Alert(
                title: Text("Muvaffaqiyat"),
                message: Text("Mahsulot muvaffaqiyatli qo'shildi!"),
                dismissButton: .default(Text("OK")) {
                    productIMEI = ""
                    productName = ""
                    isNewTicked = false
                    originalPrice = ""
                    sellPrice = ""
                    additionInfo = ""
                    ownerInfo = ""
                    documentTicked = false
                }
            )
        }
        .alert(isPresented: $showValidationAlert) {
            Alert(title: Text("Xatolik"), message: Text(validationAlertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    if selectedImage != nil {
                        isShowingImageCropper = true
                    }
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
            .onChange(of: additionInfo) {
                buttonDisabled = false
            }
    }
    
    private var buttons: some View {
        VStack {
            Button(action: {
                if imageArr.count < 2 {
                    isShowingImagePicker = true
                } else {
                    addViewModel.alertMessage = "Ikkitadan ko'p rasm yuklab bo'lmadyi."
                    addViewModel.showAlert = true
                }
            }, label: {
                Text("Rasm tanlash")
            })
            
            SubmitButton(title: "Saqlash") {
                if validateFields() {
                    addViewModel.saveProduct(
                        productName: productName,
                        productIMEI: productIMEI,
                        originalPrice: originalPrice,
                        sellPrice: sellPrice,
                        additionInfo: additionInfo,
                        ownerInfo: ownerInfo,
                        documentTicked: documentTicked,
                        isNewTcked: isNewTicked,
                        imageArr: imageArr,
                        productID: productId
                    )
                } else {
                    validationAlertMessage = "Nomi, imei, narxlar va egasi haqida ma'lumotlarni to'ldiring"
                    showValidationAlert = true
                }
            }
            .disabled(buttonDisabled ? true : false)
            .opacity(buttonDisabled ? 0.3 : 1)
            .padding(.vertical)
        }
    }
    
    private func fetchImages() {
        for url in imageArr2 {
            let request = URLRequest(url: URL(string: url)!)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    if let uiImage = UIImage(data: data) {
                        imageArr.append(uiImage)
                    }
                }
            }.resume()
        }
    }

    private func validateFields() -> Bool {
        return !productName.isEmpty && !productIMEI.isEmpty && !originalPrice.isEmpty && !sellPrice.isEmpty && !ownerInfo.isEmpty
    }
}

#Preview {
    ProductAddView()
}
