#if canImport(SwiftUI)
import PhotosUI
import SwiftUI

public struct ReceiptPickerScannerMenuView<Label>: View where Label: View {
    
    @State var vm: ReceiptPickerScannerMenuViewModel
    @Binding var scanStatus: ScanStatus

    var label: () -> Label
    
    public init(apiKey: String, scanStatus: Binding<ScanStatus>, @ViewBuilder label: @escaping () -> Label) {
        self._vm = State(initialValue: ReceiptPickerScannerMenuViewModel(apiKey: apiKey))
        self._scanStatus = scanStatus
        self.label = label
    }
 
    public var body: some View {
        Menu(content: {
            #if os(iOS)
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    vm.scanStatus = .pickingImage
                    vm.isShowingCamera = true
                }
            }
            #endif
            
            Button("File") {
                vm.scanStatus = .pickingImage
                vm.isPickingFile = true
            }
            Button("Photos Library") {
                vm.scanStatus = .pickingImage
                vm.shouldPresentPhotoPicker = true
            }
            
           
        }, label: label)
        #if os(iOS)
        .sheet(isPresented: $vm.isShowingCamera) {
            CameraView(isPresented: $vm.isShowingCamera, image: $vm.cameraImage)
        }
        #endif
        .photosPicker(isPresented: $vm.shouldPresentPhotoPicker, selection: $vm.selectedPhotoPickerItem, matching: .images)
        .fileImporter(
            isPresented: $vm.isPickingFile,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first, url.startAccessingSecurityScopedResource() {
                    
                    var image: ReceiptImage?
                    #if os(macOS)
                    image = NSImage(contentsOf: url)
                    #else
                    if let data = try? Data(contentsOf: url) {
                        image = UIImage(data: data)
                    }
                    #endif
                    
                    url.stopAccessingSecurityScopedResource()
                    self.vm.selectedImage = image
                    Task { await self.vm.scanImage() }
                }
                
            case .failure(let error):
                print("File import failed: \(error.localizedDescription)")
            }
        }

        .onChange(of: vm.selectedPhotoPickerItem) { loadInputImage(fromPhotosPickerItem: $1) }
        .onChange(of: vm.scanStatus) { scanStatus = $1 }
        .onChange(of: vm.cameraImage) { image in
            DispatchQueue.main.async {
                self.vm.selectedImage = image
                Task { await self.vm.scanImage() }
            }
        }
    }
    
    func loadInputImage(fromPhotosPickerItem item: PhotosPickerItem?) {
        vm.selectedPhotoPickerItem = nil
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .failure(let error):
                print("Failed to load: \(error)")
                return
                
            case .success(let _data):
                guard let data = _data else {
                    print("Failed to load image data")
                    return
                }
                
                guard var image = CIImage(data: data) else {
                    print("Failed to create image from selected photo")
                    return
                }
                
                if let orientation = image.properties["Orientation"] as? Int32, orientation != 1 {
                    image = image.oriented(forExifOrientation: orientation)
                }
                let cgImage = render(ciImage: image)
                
                DispatchQueue.main.async {
                    let image: ReceiptImage
                    #if os(macOS)
                    image = NSImage(cgImage: cgImage, size: .init(width: cgImage.width, height: cgImage.height))
                    #else
                    image = UIImage(cgImage: cgImage)
                    #endif
                    self.vm.selectedImage = image
                    Task { await self.vm.scanImage() }
                }
            }
        }
    }
    
    func render(ciImage img: CIImage) -> CGImage {
        guard let cgImage = CIContext(options: nil).createCGImage(img, from: img.extent) else {
            fatalError("failed to render CIImage")
        }
        return cgImage
    }
}
#endif

