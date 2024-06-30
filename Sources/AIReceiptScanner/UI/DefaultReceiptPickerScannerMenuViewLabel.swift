//
//  Created by Alfian Losari on 17/06/24.
//

#if canImport(SwiftUI)
import SwiftUI
struct DefaultReceiptPickerScannerMenuViewLabel: View {
    
    var image: Image?
    
    init(image: Image? = nil) {
        self.image = image
    }

    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            HStack {
                Image(systemName: "photo.badge.plus")
                    .imageScale(.large)
                    
                if image == nil {
                    Text("Select Image")
                } else {
                    Text("Select Other Image")
                }
            }
        }
    }
}
#endif
