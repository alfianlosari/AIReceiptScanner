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
        #if os(macOS) || os(visionOS)
        VStack {
            if let image = scanStatus.receiptImage {
                image
                    .resizable()
                    .scaledToFit()
                    .clipped()
                #if os(macOS)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                #endif
            }
            
            ReceiptPickerScannerMenuView(apiKey: apiKey, scanStatus: $scanStatus) {
                HStack {
                    Image(systemName: "photo.badge.plus")
                        .imageScale(.large)
                        
                    if scanStatus.receiptImage == nil {
                        Text("Select Image")
                    } else {
                        Text("Select Other Image")
                    }
                }
            }
       
        }
        #else
        ReceiptPickerScannerMenuView(apiKey: apiKey, scanStatus: $scanStatus) {
            DefaultReceiptPickerScannerMenuViewLabel(image: scanStatus.receiptImage)
        }
        #endif
    }
    
}

#endif

