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
    @State private var documentTicked: Bool = false
    @State private var isNewTcked: Bool = false
    @State private var additionInfo: String = ""
    @Environment (\.dismiss) var dismiss
    
    
    @State private var imageArr: [UIImage] = []
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isShowingImageCropper = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            VStack() {
                YTextField(text: $productName, placeholder: "Mahsulot nomi: Apple Vision Pro 2")
                YTextField(text: $productIMEI, placeholder: "23122342342344376")
                YTextField(text: $originalPrice, placeholder: "Kelish narxi: 4000")
                YTextField(text: $sellPrice, placeholder: "Sotilish narxi: 4400")
                
                infoTextField
                
                HStack {
                    CheckboxView(isChecked: $documentTicked, title: "Dokument bormi?")
                    Spacer()
                    CheckboxView(isChecked: $isNewTcked, title: "Yangimi?")
                }
                .padding(.vertical)
                
                HStack(spacing: 20) {
                    ForEach(imageArr, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    }
                }
                
                buttons
            }
            .scrollable(showIndicators: false)
        }
        .scrollDismissesKeyboard(.interactively)
        .padding()
        .navigationTitle("Mahsulot qo'shish")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var infoTextField: some View {
        TextField("", text: $additionInfo, prompt: Text("Enter a task").foregroundStyle(Color.gray), axis: .vertical)
            .lineLimit(3, reservesSpace: true)
            .font(Font.custom("Raleway", size: 16))
            .padding()
            .background(content: {Color.init(uiColor: .systemBackground)})
            .clipShape(.rect(cornerRadius: 10))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color.blue))
                    .ignoresSafeArea()
    }
    
    
    private var buttons: some View {
        VStack {
            Button(action: {
                if imageArr.count < 2 {
                    isShowingImagePicker = true
                } else {
                    alertMessage = "You can only upload up to 2 images."
                    showAlert = true
                }
            }, label: {
                Text("Rasm tanlash")
            })
            
            SubmitButton(title: "Saqlash") {
                // Your save action here
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear(perform: {
                    isShowingImageCropper = true
                })
        }
        .sheet(isPresented: $isShowingImageCropper) {
            if selectedImage != nil {
                    ImageCropper(image: $selectedImage)
                        .onDisappear {
                            if let croppedImage = selectedImage {
                                imageArr.append(croppedImage)
                                selectedImage = nil
                            }
                        }
                }
            }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Limit Exceeded"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ProductAddView()
}
