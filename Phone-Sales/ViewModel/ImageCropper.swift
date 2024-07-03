//
//  ImageCropper.swift
//  Phone-Sales
//
//  Created by Sardorbek Saydamatov on 28/06/24.
//

import SwiftUI
import CropViewController

struct ImageCropper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, CropViewControllerDelegate {
        var parent: ImageCropper

        init(parent: ImageCropper) {
            self.parent = parent
        }

        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.image = image
            parent.presentationMode.wrappedValue.dismiss()
        }

        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> CropViewController {
        let cropViewController = CropViewController(image: image!)
        cropViewController.delegate = context.coordinator
        cropViewController.customAspectRatio = CGSize(width: 3, height: 4)
        
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}
}
