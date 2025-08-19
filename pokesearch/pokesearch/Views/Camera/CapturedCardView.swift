import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CapturedCardView: View {
    let image: CIImage
    @Environment(\.dismiss) private var dismiss
    @State private var uiImage: UIImage?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(5/7, contentMode: .fit)
                        .padding()
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Retake") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Use") {
                        // TODO: Process the card
                        print("Processing card...")
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                }
            }
        }
        .onAppear {
            processImage()
        }
    }
    
    private func processImage() {
        let context = CIContext()
        
        // Apply perspective correction if needed
        let correctedImage = image
        
        // Convert to UIImage
        if let cgImage = context.createCGImage(correctedImage, from: correctedImage.extent) {
            DispatchQueue.main.async {
                self.uiImage = UIImage(cgImage: cgImage)
            }
        }
    }
}