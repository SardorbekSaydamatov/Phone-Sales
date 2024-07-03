//
//  Array + Extension.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 01/07/24.
//

import Foundation
import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        var currentIndex = 0
        while currentIndex < self.count {
            let chunk = Array(self[currentIndex..<Swift.min(currentIndex + size, self.count)])
            chunks.append(chunk)
            currentIndex += size
        }
        return chunks
    }
}
