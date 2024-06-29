//
//  Created by Alfian Losari on 29/06/24.
//

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
import Foundation

public struct SuccessScanResult: Identifiable {
    public let id = UUID()
    public let image: ReceiptImage
    public let receipt: Receipt
    
    public init(image: ReceiptImage, receipt: Receipt) {
        self.image = image
        self.receipt = receipt
    }
}

public enum ScanStatus {
    case idle
    case prompting
    case success(SuccessScanResult)
    case failure(Error)
    
    public var isPrompting: Bool {
        if case .prompting = self {
            return true
        }
        return false
    }
    
    public var scanResult: SuccessScanResult? {
        if case .success(let result) = self {
            return result
        }
        return nil
    }
    
    public var error: Error? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
}
#endif
