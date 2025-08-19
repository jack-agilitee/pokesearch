import Foundation
import CoreGraphics

struct RectangleObservation: Equatable {
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
    let confidence: Float
    
    var center: CGPoint {
        CGPoint(
            x: (topLeft.x + topRight.x + bottomLeft.x + bottomRight.x) / 4,
            y: (topLeft.y + topRight.y + bottomLeft.y + bottomRight.y) / 4
        )
    }
    
    var width: CGFloat {
        let topWidth = distance(from: topLeft, to: topRight)
        let bottomWidth = distance(from: bottomLeft, to: bottomRight)
        return (topWidth + bottomWidth) / 2
    }
    
    var height: CGFloat {
        let leftHeight = distance(from: topLeft, to: bottomLeft)
        let rightHeight = distance(from: topRight, to: bottomRight)
        return (leftHeight + rightHeight) / 2
    }
    
    var aspectRatio: CGFloat {
        guard height > 0 else { return 0 }
        return width / height
    }
    
    private func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func isStable(comparedTo other: RectangleObservation, threshold: CGFloat = 0.05) -> Bool {
        let centerDiff = distance(from: self.center, to: other.center)
        let sizeDiff = abs(self.width - other.width) + abs(self.height - other.height)
        
        // Check if position and size are within threshold (5% by default)
        return centerDiff < threshold && sizeDiff < threshold * 2
    }
    
    // Convert Vision coordinates (0-1 range) to view coordinates
    func toViewCoordinates(in size: CGSize) -> (topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        // Vision uses bottom-left origin, SwiftUI uses top-left
        // Also Vision coordinates are normalized (0-1)
        return (
            topLeft: CGPoint(x: topLeft.x * size.width, y: (1 - topLeft.y) * size.height),
            topRight: CGPoint(x: topRight.x * size.width, y: (1 - topRight.y) * size.height),
            bottomLeft: CGPoint(x: bottomLeft.x * size.width, y: (1 - bottomLeft.y) * size.height),
            bottomRight: CGPoint(x: bottomRight.x * size.width, y: (1 - bottomRight.y) * size.height)
        )
    }
}