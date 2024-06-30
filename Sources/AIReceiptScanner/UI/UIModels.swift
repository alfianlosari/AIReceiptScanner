//
//  Created by Alfian Losari on 29/06/24.
//

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
import Foundation
import SwiftUI

public struct SuccessScanResult: Identifiable, Equatable {
    public let id = UUID()
    public let image: ReceiptImage
    public let receipt: Receipt
    
    public init(image: ReceiptImage, receipt: Receipt) {
        self.image = image
        self.receipt = receipt
    }
}

public enum ScanStatus: Equatable {
    case idle
    case pickingImage
    case prompting(ReceiptImage)
    case success(SuccessScanResult)
    case failure(Error, ReceiptImage)
    
    public var isPrompting: Bool {
        if case .prompting = self {
            return true
        }
        return false
    }
    
    public var receiptImage: Image? {
        if case .prompting(let receiptImage) = self {
            return receiptImage.swiftUiImage
        } else if case .success(let successScanResult) = self {
            return successScanResult.image.swiftUiImage
        } else if case .failure(_, let receiptImage) = self {
            return receiptImage.swiftUiImage
        }
        return nil
    }
    
    public var scanResult: SuccessScanResult? {
        if case .success(let result) = self {
            return result
        }
        return nil
    }
    
    public var error: Error? {
        if case .failure(let error, _) = self {
            return error
        }
        return nil
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.pickingImage, .pickingImage): return true
        case (.prompting(let image1), .prompting(let image2)):
            return image1 == image2
        case (.success(let result1), .success(let result2)):
            return result1 == result2
        case (.failure(let error1, let image1), .failure(let error2, let image2)):
            return error1.localizedDescription == error2.localizedDescription && image1 == image2
        default: return false
        }
    }
}
#endif
