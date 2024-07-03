//
//  Test.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 01/07/24.
//

import SwiftUI

struct Test: View {
    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/phone-sale-pos.appspot.com/o/productsc6a7f8d7-2dc0-468d-85b3-c47e90fd49b8.jpeg?alt=media&token=950dc5a5-b86e-4228-96cc-a3cb630efcb5")!

        var body: some View {
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView() // or any placeholder view
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
        }
}

#Preview {
    Test()
}
