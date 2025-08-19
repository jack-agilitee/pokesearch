import Vision
import CoreImage
import UIKit

class RectangleDetector {
    // Pokémon cards are 2.5" x 3.5" (5:7 ratio)
    // When phone is vertical scanning vertical card: Vision sees it as 7:5 (1.4)
    // When phone is horizontal scanning vertical card: Vision sees it as 5:7 (0.714)
    // We need to detect BOTH orientations
    private let minimumAspectRatio: Float = 0.65  // Covers 5:7 ratio with variance
    private let maximumAspectRatio: Float = 1.54  // Covers 7:5 ratio with variance (1.4 + 10%)
    private let minimumSize: Float = 0.15  // Rectangle must be at least 15% of image
    private let maximumObservations = 1  // Only detect the most prominent rectangle
    
    private lazy var rectangleRequest: VNDetectRectanglesRequest = {
        let request = VNDetectRectanglesRequest { [weak self] request, error in
            self?.handleDetection(request: request, error: error)
        }
        request.minimumAspectRatio = minimumAspectRatio
        request.maximumAspectRatio = maximumAspectRatio
        request.minimumSize = minimumSize
        request.maximumObservations = maximumObservations
        request.minimumConfidence = 0.5
        return request
    }()
    
    private var completionHandler: ((RectangleObservation?) -> Void)?
    
    func detectRectangle(in pixelBuffer: CVPixelBuffer, completion: @escaping (RectangleObservation?) -> Void) {
        self.completionHandler = completion
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                try handler.perform([self.rectangleRequest])
            } catch {
                print("Failed to perform rectangle detection: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    private func handleDetection(request: VNRequest, error: Error?) {
        guard error == nil else {
            print("Rectangle detection error: \(error!)")
            DispatchQueue.main.async { [weak self] in
                self?.completionHandler?(nil)
            }
            return
        }
        
        guard let observations = request.results as? [VNRectangleObservation],
              let rectangle = observations.first else {
            DispatchQueue.main.async { [weak self] in
                self?.completionHandler?(nil)
            }
            return
        }
        
        // Convert Vision coordinates to our model
        let observation = RectangleObservation(
            topLeft: rectangle.topLeft,
            topRight: rectangle.topRight,
            bottomLeft: rectangle.bottomLeft,
            bottomRight: rectangle.bottomRight,
            confidence: rectangle.confidence
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.completionHandler?(observation)
        }
    }
}

extension RectangleObservation {
    func toPerspectiveCorrection(imageSize: CGSize) -> CGAffineTransform {
        // Convert normalized points to image coordinates
        let topLeft = CGPoint(x: self.topLeft.x * imageSize.width, y: (1 - self.topLeft.y) * imageSize.height)
        let topRight = CGPoint(x: self.topRight.x * imageSize.width, y: (1 - self.topRight.y) * imageSize.height)
        let bottomLeft = CGPoint(x: self.bottomLeft.x * imageSize.width, y: (1 - self.bottomLeft.y) * imageSize.height)
        let bottomRight = CGPoint(x: self.bottomRight.x * imageSize.width, y: (1 - self.bottomRight.y) * imageSize.height)
        
        // Create perspective transform
        // For now, return identity transform - full perspective correction would require CIPerspectiveCorrection
        return CGAffineTransform.identity
    }
}