# AIReceiptScanner for Swift

![Alt text](https://i.ibb.co.com/ZKhcwPg/Screenshot-2024-06-30-at-11-36-16.png "image")

Scan for items and details in a receipt using ChatGPT

## Features
- Receipt Scanner - Scan input of image receipt to output Swift Model containing receipt detail and items purchased.
- Receipt Picker Scanner Menu View (Apple Platforms Only) - Menu Button to select receipt image from photo library/file picker to prompt ChatGPT with 
- Receipt Scanner Scan Result View (Apple Platforms Only) - Display the result of receipt scan in SwiftUI List with copy as JSON button
- Receipt Picker Scanner View (Apple Platforms Only) - Combine both Menu and Result View to provide E2E flow to users for picking, scanning, and viewing the result.

## Supported Platforms
- iOS 17
- macOS 14
- tvOS 17
- watchOS 9
- visionOS 1.x
- Linux

## Installation

### Swift Package Manager
- File > Swift Packages > Add Package Dependency
- Copy and paste this URL

```swift
https://github.com/alfianlosari/AIReceiptScanner
```

### Import
Import to your project source file.

```swift
import AIReceiptScanner
```

## Requirement

Register for API key fromx [OpenAI](https://openai.com/api). Initialize with api key

## Usage

### AI Receipt Scanner

Simply initialize passing the `apiKey` in SwiftUI View

```swift
let myImage // NSImage/UIImage
let receiptScanner = AIReceiptScanner(apiKey: apiKey)
let receipt = try await receiptScanner.scanImage(image)
print(receipt)
```

Pass these optional params for customization:
- `targetSize`: Size used to crop the image, default is 512x512, you should not pass resolution larger than 1024
- `compressionQuality`: JPG Compression rate used to compress the image before sending to ChatGPT
- `model` ChatGPTModel enum (gpt-4o, or any models that support multi-modal vision)
- `temperature` Temperature used by ChatGPT for response.


Make sure you are in tier that eligible for gpt-4o models access. You can learn more from here [How can I access GPT-4, GPT-4 Turbo and GPT-4o?](https://help.openai.com/en/articles/7102672-how-can-i-access-gpt-4-gpt-4-turbo-and-gpt-4o). 

If you're not sure just pass gpt-4o models, by default it uses `gpt-4o`

### Receipt Picker Scanner Menu View (Apple Platform Only)

You can use `ReceiptPickerScannerDefaultMenuView` SwiftUI View to display Menu for users to select image from Photo Library or File Picker. By default, it will shows the selected image and a Text informing the user to select an image.

Declare a state for `scanStatus`. This is an `enum` containing the state such as `pickingImage`, `prompting`, `success` that you can observe using `onChange` modifier

You need to add key of `Privacy - Photo Library Usage Description` in `info.plist` when using this

```swift
@State var scanStatus = .idle

var body: some View {
    ReceiptPickerScannerDefaultMenuView(apiKey: apiKey, scanStatus: $scanStatus)
    .onChange(of: vm.scanStatus) { _, newValue in
        switch newValue {
        case .pickingImage:
            print("Picking image")
        case .prompting(let image):
            print("prompting gpt-4o with receipt image")
        case .success(let scanResult):
            print("Success with \(scanResult)")
        case .failure(let error, let image):
            print("Error \(error.localizedDescription)")
        default: break
        }
    }
}
```

You can also provide your own Custom Menu label if you prefer to using `ReceiptPickerScannerMenuView`
```swift
var body: some View {
    ReceiptPickerScannerMenuView(apiKey: apiKey, scanStatus: $scanStatus, label: {
        Text("My Custom Menu View Label")
    })
}
```

### Receipt Scan Result View (Apple Platform Only)

You can use this SwiftUI View to display the result of scanned receipt in a List

```swift
var body: some View {
     ReceiptScanResultView(scanResult: scanResult)
}
```

If you're displaying the result in a resizable sheet, you can also pass `applyBottomSheetTrayStyle` as `true` to apply default transparent visual style and presentation detents.
```swift
var body: some View {
     ReceiptScanResultView(scanResult: scanResult, applyBottomSheetTrayStyle: true)
}
```
### Receipt Picker Scanner View (Apple Platform Only)

This View combines the `ReceiptScanResultView` & `ReceiptPickerScannerMenuView`. Based on the environemtn horizontal size class, it will adjust the layout:
- `compact`: display the scan result in resizable bottom sheet tray
- `regular`: display the receipt image and the scan result side-by-side with in an `HStack`

```swift
@State var scanStatus: ScanStatus = .idle

var body: some View {
    ReceiptPickerScannerView(apiKey: apiKey, scanStatus: $scanStatus)
        .navigationTitle("XCA AI Receipt Scanner")
        .onChange(of: scanStatus) { _, newValue in
        
        }
}
```