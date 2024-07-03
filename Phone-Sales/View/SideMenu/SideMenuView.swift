//
//  SlideMenuView.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//

import SwiftUI

struct SideMenuView: View {
    @State private var selectedOption: SideMenuOptionModel?
    @Binding var selectedTab: Int
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                
                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(SideMenuOptionModel.allCases) {option in
                            Button(action: {
                                onOptionTapped(option: option)
                            }, label: {
                                SideMenuRawView(option: option, selectedOption: $selectedOption)
                            })
                            .foregroundStyle(Color.init(uiColor: .label))
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 100, alignment: .leading)
                    .background(Color.init(uiColor: .secondarySystemBackground))
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isShowing)
    }
    
    private func onOptionTapped(option: SideMenuOptionModel) {
        selectedOption = option
        selectedTab = option.rawValue
        isShowing = false
    }
}
#Preview {
    SideMenuView(selectedTab: .constant(0), isShowing: .constant(true))
}
