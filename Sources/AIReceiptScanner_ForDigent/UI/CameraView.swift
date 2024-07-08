//
//  File.swift
//  
//
//  Created by Alfian Losari on 30/06/24.
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI

#if os(iOS)
struct CameraView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: ReceiptImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var image: ReceiptImage?

        init(isPresented: Binding<Bool>, image: Binding<ReceiptImage?>) {
            _isPresented = isPresented
            _image = image
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented = false
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }
            isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented, image: $image)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}
#endif

#endif
