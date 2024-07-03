//
//  ProductsCartView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 01/07/24.
//

import SwiftUI

struct ProductDetailView: View {
    
    @State var images: [String] = [
        "https://firebasestorage.googleapis.com/v0/b/phone-sale-pos.appspot.com/o/productse0f0be51-c8b3-480d-a899-dc051329b1fb.jpeg?alt=media&token=306f1596-161b-4c27-a47a-7bcacf1bc223",
        "https://firebasestorage.googleapis.com/v0/b/phone-sale-pos.appspot.com/o/products7a1b12e9-3f31-47d4-b3d6-6ddac79f5e92.jpeg?alt=media&token=731d6e10-e02a-457e-9674-a2bea1d25194"
    ]
    @State var title: String = "house"
    @State var imei: String = "13242323"
    @State var cost: Int = 4000
    @State var price: Int = 4400
    @State var isNew: Bool = false
    @State var haveDocument: Bool = false
    @State var extraInfo: String = ""
    @State var infoAboutOwner: String = "Sardor"
    @State var createdDate: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.largeTitle)
            Text("Imei: \(imei)")
                .font(.title2)
            if images != nil {
                HStack(spacing: 10) {
                    ForEach(images, id: \.self) {image in
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
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(isNew ? "Xolati: Yangi" : "Xolati: Ishlatilgan")
                    Text(haveDocument ? "Dokument: bor" : "Dokument: Yo'q")
                    Text("Olingan odam: \(infoAboutOwner)")
                }
                
                Spacer()
                
                VStack (alignment: .leading, spacing: 10) {
                    Text("Kelgan narxi: \(cost)")
                    Text("Sotish narxi: \(price)")
                    if let date = createdDate {
                        Text("Kelgan sana: \(formatDate(date))")
                    }
                }
            }
            
            Text("Qo'shimcha ma'lumot")
                .font(.title2)
                .padding(.leading, 50)
                .padding()
            
            Text(extraInfo)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ProductDetailView()
}
