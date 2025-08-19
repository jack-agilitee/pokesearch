import Foundation

enum AppConstants {
    enum Camera {
        static let usageDescription = "This app needs camera access to scan Pokémon cards"
        static let permissionDeniedTitle = "Camera Access Required"
        static let permissionDeniedMessage = "Please enable camera access in Settings to scan Pokémon cards"
        static let settingsButtonTitle = "Open Settings"
        static let cancelButtonTitle = "Cancel"
    }
    
    enum UI {
        static let cardOverlayText = "Position card here"
        static let scanInstructionText = "Align card with frame"
        static let scanButtonTitle = "Scan Card"
        static let closeButtonTitle = "Close"
    }
    
    enum Animation {
        static let scanLineAnimationDuration: Double = 2.0
        static let pulseAnimationDuration: Double = 1.5
        static let overlayOpacity: Double = 0.8
    }
}