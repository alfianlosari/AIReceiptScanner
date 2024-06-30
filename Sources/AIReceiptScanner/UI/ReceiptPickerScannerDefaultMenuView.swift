#if canImport(SwiftUI)
import PhotosUI
import SwiftUI

public struct ReceiptPickerScannerDefaultMenuView: View {
    
    let apiKey: String
    @Binding var scanStatus: ScanStatus
    
    public init(apiKey: String, scanStatus: Binding<ScanStatus>) {
        self.apiKey = apiKey
        self._scanStatus = scanStatus
    }
    
    public var body: some View {
        ReceiptPickerScannerMenuView(apiKey: apiKey, scanStatus: $scanStatus) {
            DefaultReceiptPickerScannerMenuViewLabel(image: scanStatus.receiptImage)
        }
    }
    
}

#endif

