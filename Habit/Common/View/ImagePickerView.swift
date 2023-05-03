import Foundation
import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: Image?
    @Binding var imageData: Data?

    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(
            image: $image,
            imageData: $imageData,
            isPresented: $isPresented
        )
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()

        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            pickerController.sourceType = .photoLibrary
        } else {
            pickerController.sourceType = sourceType
        }

        pickerController.delegate = context.coordinator

        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Binding var image: Image?
    @Binding var imageData: Data?
    @Binding var isPresented: Bool

    init(
        image: Binding<Image?>,
        imageData: Binding<Data?>,
        isPresented: Binding<Bool>
    ) {
        self._image = image
        self._imageData = imageData
        self._isPresented = isPresented
    }

    func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let width = CGFloat(420)
            let canvas = CGSize(
                width: width,
                height: CGFloat(ceil(width / image.size.width * image.size.height))
            )

            let imageResized = UIGraphicsImageRenderer(size: canvas, format: image.imageRendererFormat).image { _ in
                image.draw(in: CGRect(origin: .zero, size: canvas))
            }

            self.image = Image(uiImage: imageResized)
            self.imageData = imageResized.jpegData(compressionQuality: 0.2)
        }
        
        self.isPresented = false
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
}
