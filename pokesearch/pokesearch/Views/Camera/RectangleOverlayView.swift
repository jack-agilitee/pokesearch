import SwiftUI

struct RectangleOverlayView: View {
    let rectangle: RectangleObservation?
    let isStable: Bool
    let viewSize: CGSize
    let cameraAspectRatio: CGFloat = 3.0/4.0  // Camera aspect ratio when phone is vertical
    
    @State private var animateAppearance = false
    
    private func adjustedCoordinates(from rect: RectangleObservation) -> (topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        // Camera uses aspectFill, so we need to calculate the scaling
        let viewAspectRatio = viewSize.width / viewSize.height
        
        var effectiveSize = viewSize
        var offset = CGPoint.zero
        
        if cameraAspectRatio > viewAspectRatio {
            // Camera is wider - scale by height, crop width
            let scale = viewSize.height
            effectiveSize.width = scale * cameraAspectRatio
            offset.x = (viewSize.width - effectiveSize.width) / 2.0
        } else {
            // Camera is taller - scale by width, crop height  
            let scale = viewSize.width
            effectiveSize.height = scale / cameraAspectRatio
            offset.y = (viewSize.height - effectiveSize.height) / 2.0
        }
        
        // Convert to effective coordinates
        let coords = rect.toViewCoordinates(in: effectiveSize)
        
        // Apply offset from centering
        return (
            topLeft: CGPoint(x: coords.topLeft.x + offset.x, y: coords.topLeft.y + offset.y),
            topRight: CGPoint(x: coords.topRight.x + offset.x, y: coords.topRight.y + offset.y),
            bottomLeft: CGPoint(x: coords.bottomLeft.x + offset.x, y: coords.bottomLeft.y + offset.y),
            bottomRight: CGPoint(x: coords.bottomRight.x + offset.x, y: coords.bottomRight.y + offset.y)
        )
    }
    
    var body: some View {
        ZStack {
            if let rect = rectangle {
                let coords = adjustedCoordinates(from: rect)
                
                // Draw corner markers for the detected rectangle
                RectangleCorners(
                    topLeft: coords.topLeft,
                    topRight: coords.topRight,
                    bottomLeft: coords.bottomLeft,
                    bottomRight: coords.bottomRight,
                    color: isStable ? .green : .gray,
                    lineWidth: isStable ? 3 : 2
                )
                .opacity(animateAppearance ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: animateAppearance)
                .onAppear {
                    animateAppearance = true
                }
                .onDisappear {
                    animateAppearance = false
                }
            }
        }
        .frame(width: viewSize.width, height: viewSize.height)
    }
}

struct RectangleCorners: View {
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
    let color: Color
    let lineWidth: CGFloat
    
    private let cornerLength: CGFloat = 30
    
    var body: some View {
        Canvas { context, size in
            var path = Path()
            
            // Top-left corner
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerLength))
            path.addLine(to: topLeft)
            path.addLine(to: CGPoint(x: topLeft.x + cornerLength, y: topLeft.y))
            
            // Top-right corner
            path.move(to: CGPoint(x: topRight.x - cornerLength, y: topRight.y))
            path.addLine(to: topRight)
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y + cornerLength))
            
            // Bottom-left corner
            path.move(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - cornerLength))
            path.addLine(to: bottomLeft)
            path.addLine(to: CGPoint(x: bottomLeft.x + cornerLength, y: bottomLeft.y))
            
            // Bottom-right corner
            path.move(to: CGPoint(x: bottomRight.x - cornerLength, y: bottomRight.y))
            path.addLine(to: bottomRight)
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerLength))
            
            context.stroke(path, with: .color(color), lineWidth: lineWidth)
        }
    }
}

struct DetectionStatusView: View {
    let isDetecting: Bool
    let isStable: Bool
    
    var statusText: String {
        if isStable {
            return "Card detected - Hold steady"
        } else if isDetecting {
            return "Detecting card..."
        } else {
            return "Position card in frame"
        }
    }
    
    var statusColor: Color {
        if isStable {
            return .green
        } else if isDetecting {
            return .yellow
        } else {
            return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
                .overlay(
                    Circle()
                        .stroke(statusColor.opacity(0.3), lineWidth: 8)
                        .scaleEffect(isStable ? 2 : 1)
                        .opacity(isStable ? 0 : 1)
                        .animation(.easeOut(duration: 1).repeatForever(autoreverses: false), value: isStable)
                )
            
            Text(statusText)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.7))
        .cornerRadius(20)
    }
}