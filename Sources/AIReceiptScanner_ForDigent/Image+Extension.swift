import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

#if canImport(AppKit)
import AppKit
public typealias ReceiptImage = NSImage
public extension ReceiptImage {
    var swiftUiImage: Image {
        Image(nsImage: self)
    }
}
#endif

#if canImport(UIKit)
import UIKit
public typealias ReceiptImage = UIImage
public extension ReceiptImage {
    var swiftUiImage: Image {
        Image(uiImage: self)
    }
}
#endif
