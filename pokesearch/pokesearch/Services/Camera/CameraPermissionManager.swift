import AVFoundation
import SwiftUI

@MainActor
class CameraPermissionManager: ObservableObject {
    @Published var authorizationStatus: AVAuthorizationStatus
    @Published var showPermissionAlert = false
    
    init() {
        self.authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func checkCameraAuthorizationStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        self.authorizationStatus = status
        
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            showPermissionAlert = true
        case .authorized:
            break
        @unknown default:
            break
        }
    }
    
    func requestCameraPermission() async -> Bool {
        guard authorizationStatus == .notDetermined else {
            return authorizationStatus == .authorized
        }
        
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        self.authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return granted
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    var permissionDeniedAlert: Alert {
        Alert(
            title: Text(AppConstants.Camera.permissionDeniedTitle),
            message: Text(AppConstants.Camera.permissionDeniedMessage),
            primaryButton: .default(Text(AppConstants.Camera.settingsButtonTitle)) {
                self.openSettings()
            },
            secondaryButton: .cancel(Text(AppConstants.Camera.cancelButtonTitle))
        )
    }
}

extension CameraPermissionManager {
    var hasPermission: Bool {
        authorizationStatus == .authorized
    }
    
    var isDenied: Bool {
        authorizationStatus == .denied || authorizationStatus == .restricted
    }
    
    var isNotDetermined: Bool {
        authorizationStatus == .notDetermined
    }
    
    func refreshAuthorizationStatus() {
        self.authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }
}