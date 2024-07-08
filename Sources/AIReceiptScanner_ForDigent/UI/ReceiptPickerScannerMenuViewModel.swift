//
//
//  Created by Alfian Losari on 30/06/24.
//

#if canImport(SwiftUI)
import PhotosUI
import Observation
import SwiftUI

@Observable
class ReceiptPickerScannerMenuViewModel {

    let receiptScanner: AIReceiptScanner_ForDigent
    var selectedImage: ReceiptImage?
    var selectedPhotoPickerItem: PhotosPickerItem?
    var shouldPresentPhotoPicker = false
    var scanStatus: ScanStatus = .idle
    var isPickingFile = false
    var isShowingCamera = false
    var cameraImage: ReceiptImage?
    
    public init(apiKey: String) {
        self.receiptScanner = .init(apiKey: apiKey)
    }
    
    @MainActor
    func scanImage() async {
        guard let image = selectedImage else { return }
        self.scanStatus = .prompting(image)
        do {
            let receipt = try await receiptScanner.scanImage(image)
            self.scanStatus = .success(.init(image: image, receipt: receipt))
        } catch {
            self.scanStatus = .failure(error, image)
        }
    }

}
#endif
