//
//  SideMenuOptionModel.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 27/06/24.
//

import Foundation

enum SideMenuOptionModel: Int, CaseIterable {
    case store
    case sales
    case incomeOutcome
    case profil
    
    var title: String {
        switch self {
        case .store:
            return "Ombor"
        case .sales:
            return "Savdo tarixi"
        case .incomeOutcome:
            return "Kirim chiqim"
        case .profil:
            return "Profil"
        }
    }
}

extension SideMenuOptionModel: Identifiable {
    var id: Int { return self.rawValue}
}
