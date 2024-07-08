//
//  FirebaseStorageService.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 08/07/24.
//

import Foundation
import FirebaseStorage
import SwiftUI

class FirebaseStorageService {
    private let storage = Storage.storage()
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversionError", code: -1, userInfo: nil)))
            return
        }
        
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
    
    func uploadImages(_ images: [UIImage], completion: @escaping ([URL]?, Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var urls: [URL] = []
        var uploadError: Error?
        
        for image in images {
            dispatchGroup.enter()
            uploadImage(image) { result in
                switch result {
                case .success(let url):
                    urls.append(url)
                case .failure(let error):
                    uploadError = error
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(uploadError == nil ? urls : nil, uploadError)
        }
    }
}
