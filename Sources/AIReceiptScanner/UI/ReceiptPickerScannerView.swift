//  Created by Alfian Losari on 30/06/24.
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI

public struct ReceiptPickerScannerView: View {
    
    @Binding var scanStatus: ScanStatus
    @State var scanResultViewItem: SuccessScanResult?
    let apiKey: String
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    public init(apiKey: String, scanStatus: Binding<ScanStatus>) {
        self.apiKey = apiKey
        self._scanStatus = scanStatus
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                switch horizontalSizeClass {
                case .compact:
                    ReceiptPickerScannerDefaultMenuView(apiKey: apiKey, scanStatus: $scanStatus)
                        .disabled(scanStatus.isPrompting)
                        .frame(minHeight: 80)
                        .padding()
                    
                    if scanStatus.isPrompting {
                        ProgressView("Analyzing Image")
                    }
                    
                    if let scanResult = scanStatus.scanResult {
                        Button("Show Scan Result") {
                            scanResultViewItem = scanResult
                        }
                    }
                    
                    if let error = scanStatus.error {
                        Text(error.localizedDescription)
                            .foregroundStyle(Color.red)
                    }
                    
                default:
                    HStack(alignment: .top, spacing: 16) {
                        ReceiptPickerScannerDefaultMenuView(apiKey: apiKey, scanStatus: $scanStatus)
                            .disabled(scanStatus.isPrompting)
                            .frame(maxWidth: .infinity)
                        
                        Group {
                            if scanStatus.isPrompting {
                                VStack {
                                    Spacer()
                                    ProgressView("Analyzing Image")
                                    Spacer()
                                }
                                
                            }
                            if let scanResult = scanStatus.scanResult {
                                ReceiptScanResultView(scanResult: scanResult, applyBottomSheetTrayStyle: false)
                            }
                            
                            if let error = scanStatus.error {
                                Text(error.localizedDescription)
                                    .foregroundStyle(Color.red)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    
                    }
                    .padding()
                    .frame(maxWidth: 1024, alignment: .center)
                    
                }
                  
       
                    
            }
        }
        #if !os(macOS)
        .sheet(item: $scanResultViewItem) {
            ReceiptScanResultView(scanResult: $0, applyBottomSheetTrayStyle: true)
        }
        #endif
        .onChange(of: scanStatus) { _, newValue in
            self.scanStatus = newValue
            switch newValue {
            case .success(let result):
                self.scanResultViewItem = result
            default:
                break
            }
        }
    
    }
}

#endif
