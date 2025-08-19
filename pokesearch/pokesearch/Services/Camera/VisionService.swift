import Vision
import AVFoundation
import CoreImage

@MainActor
class VisionService: ObservableObject {
    @Published var detectedRectangle: RectangleObservation?
    @Published var isStable: Bool = false
    
    private let rectangleDetector = RectangleDetector()
    private let stabilityTracker = RectangleStabilityTracker()
    private let context = CIContext()
    
    init() {
        setupStabilityTracking()
    }
    
    private func setupStabilityTracking() {
        stabilityTracker.onStabilityChanged = { [weak self] stable in
            Task { @MainActor in
                self?.isStable = stable
            }
        }
    }
    
    func processBuffer(_ buffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return }
        
        rectangleDetector.detectRectangle(in: pixelBuffer) { [weak self] observation in
            guard let self = self else { return }
            
            Task { @MainActor in
                if let observation = observation {
                    self.detectedRectangle = observation
                    self.stabilityTracker.addObservation(observation)
                } else {
                    self.detectedRectangle = nil
                    self.stabilityTracker.reset()
                }
            }
        }
    }
    
    func captureStableRectangle(from buffer: CMSampleBuffer) -> CIImage? {
        guard isStable,
              let rectangle = detectedRectangle,
              let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            return nil
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Apply perspective correction to extract the card
        let perspectiveCorrection = rectangle.toPerspectiveCorrection(
            imageSize: CGSize(
                width: CVPixelBufferGetWidth(pixelBuffer),
                height: CVPixelBufferGetHeight(pixelBuffer)
            )
        )
        
        return ciImage.transformed(by: perspectiveCorrection)
    }
    
    func reset() {
        detectedRectangle = nil
        isStable = false
        stabilityTracker.reset()
    }
}