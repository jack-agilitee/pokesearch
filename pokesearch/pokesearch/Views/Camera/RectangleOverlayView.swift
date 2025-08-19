import SwiftUI

struct RectangleOverlayView: View {
    let rectangle: RectangleObservation?
    let isStable: Bool
    let viewSize: CGSize
    let cameraAspectRatio: CGFloat
    
    @State private var animateAppearance = false
    
    var body: some View {
        ZStack {
            if let rect = rectangle {
                let coords = rect.toViewCoordinates(in: viewSize)
                
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