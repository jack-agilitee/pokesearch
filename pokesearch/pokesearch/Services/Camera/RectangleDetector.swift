import Vision
import CoreImage
import UIKit

class RectangleDetector {
    // Pokémon cards are 2.5" x 3.5" (5:7 ratio), width/height = 5/7 = 0.714
    // But we need wider range to detect cards at various angles
    private let minimumAspectRatio: Float = 0.5   // More permissive minimum
    private let maximumAspectRatio: Float = 1.5   // Allow up to 1.5 ratio for rotated cards
    private let minimumSize: Float = 0.2  // Rectangle must be at least 20% of image
    private let maximumObservations = 10  // Get multiple rectangles so we can pick the largest
    
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
    
    private func calculateArea(_ rectangle: VNRectangleObservation) -> Float {
        // Calculate area using the shoelace formula for a quadrilateral
        let x1 = rectangle.topLeft.x
        let y1 = rectangle.topLeft.y
        let x2 = rectangle.topRight.x
        let y2 = rectangle.topRight.y
        let x3 = rectangle.bottomRight.x
        let y3 = rectangle.bottomRight.y
        let x4 = rectangle.bottomLeft.x
        let y4 = rectangle.bottomLeft.y
        
        let area = abs((x1*y2 - x2*y1) + (x2*y3 - x3*y2) + (x3*y4 - x4*y3) + (x4*y1 - x1*y4)) / 2.0
        return area
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
              !observations.isEmpty else {
            DispatchQueue.main.async { [weak self] in
                self?.completionHandler?(nil)
            }
            return
        }
        
        // Find the largest rectangle by area
        let largestRectangle = observations.max { rect1, rect2 in
            let area1 = calculateArea(rect1)
            let area2 = calculateArea(rect2)
            return area1 < area2
        }
        
        guard let rectangle = largestRectangle else {
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