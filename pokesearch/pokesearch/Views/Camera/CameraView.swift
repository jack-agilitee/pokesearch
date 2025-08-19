import SwiftUI
import AVFoundation
import UIKit
import Combine

struct CameraView: View {
    @StateObject private var cameraModel = CameraModel()
    @StateObject private var visionService = VisionService()
    @Environment(\.dismiss) private var dismiss
    @State private var scanLineOffset: CGFloat = -175
    @State private var pulseOpacity: Double = 0.3
    @State private var showManualOverlay = true
    @State private var capturedImage: CIImage?
    @State private var showCapturedCard = false
    @State private var lastBuffer: CMSampleBuffer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraPreview(session: cameraModel.session)
                    .edgesIgnoringSafeArea(.all)
                
                // Vision-based rectangle detection overlay
                RectangleOverlayView(
                    rectangle: visionService.detectedRectangle,
                    isStable: visionService.isStable,
                    viewSize: geometry.size
                )
                
                // Manual positioning overlay (shown when no card detected)
                if showManualOverlay && visionService.detectedRectangle == nil {
                    CameraOverlay(
                        scanLineOffset: $scanLineOffset,
                        pulseOpacity: $pulseOpacity
                    )
                    .opacity(0.3)
                }
                
                VStack {
                    HStack {
                        // Detection status indicator
                        DetectionStatusView(
                            isDetecting: visionService.detectedRectangle != nil,
                            isStable: visionService.isStable
                        )
                        
                        Spacer()
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .background(Circle().fill(Color.black.opacity(0.5)))
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Capture button when card is stable
                    if visionService.isStable {
                        Button(action: captureCard) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                        .frame(width: 80, height: 80)
                                )
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear {
            cameraModel.checkPermissions()
            startAnimations()
            setupVisionProcessing()
        }
        .onDisappear {
            cameraModel.stopSession()
            visionService.reset()
        }
        .onReceive(NotificationCenter.default.publisher(for: .captureStableCard)) { _ in
            captureCard()
        }
        .fullScreenCover(isPresented: $showCapturedCard) {
            if let capturedImage = capturedImage {
                CapturedCardView(image: capturedImage)
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(
            .easeInOut(duration: AppConstants.Animation.scanLineAnimationDuration)
            .repeatForever(autoreverses: true)
        ) {
            scanLineOffset = 175
        }
        
        withAnimation(
            .easeInOut(duration: AppConstants.Animation.pulseAnimationDuration)
            .repeatForever(autoreverses: true)
        ) {
            pulseOpacity = 0.8
        }
    }
    
    private func setupVisionProcessing() {
        cameraModel.setFrameHandler { [weak visionService] buffer in
            visionService?.processBuffer(buffer)
            // Store buffer directly on main actor
            Task { @MainActor in
                self.lastBuffer = buffer
            }
        }
    }
    
    private func captureCard() {
        guard let buffer = lastBuffer else { return }
        
        if let croppedImage = visionService.captureStableRectangle(from: buffer) {
            capturedImage = croppedImage
            showCapturedCard = true
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
}

struct CameraOverlay: View {
    @Binding var scanLineOffset: CGFloat
    @Binding var pulseOpacity: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                ZStack {
                    // Calculate dimensions based on screen width with padding
                    // Use 80% of screen width, then calculate height based on 5:7 ratio
                    let cardWidth = geometry.size.width * 0.8
                    let cardHeight = cardWidth * 1.4 // 7/5 = 1.4
                    
                    // Vertical card frame (aspect ratio 5:7 for standard Pokémon card)
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(pulseOpacity), lineWidth: 3)
                        .frame(width: cardWidth, height: cardHeight)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.01))
                        .frame(width: cardWidth, height: cardHeight)
                    
                    // Vertical scanning line
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: cardWidth * 0.9, height: 2)
                        .offset(y: scanLineOffset * (cardHeight / 350)) // Scale offset based on card height
                    
                    VStack {
                        Text(AppConstants.UI.cardOverlayText)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill  // Back to aspectFill to fill screen
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            DispatchQueue.main.async {
                previewLayer.frame = uiView.bounds
            }
        }
    }
}

@MainActor
class CameraModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var videoDataOutput: AVCaptureVideoDataOutput?
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated)
    @Published var isSessionRunning = false
    @Published var permissionGranted = false
    
    // Use a non-isolated class to hold the frame handler
    private let frameHandlerHolder = FrameHandlerHolder()
    
    func setFrameHandler(_ handler: @escaping (CMSampleBuffer) -> Void) {
        frameHandlerHolder.handler = handler
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.permissionGranted = granted
                    if granted {
                        self?.setupSession()
                    }
                }
            }
        default:
            permissionGranted = false
        }
    }
    
    private func setupSession() {
        session.beginConfiguration()
        
        session.sessionPreset = .photo
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            session.commitConfiguration()
            return
        }
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            }
            
            // Add video data output for Vision processing
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
                self.videoDataOutput = videoOutput
            }
        } catch {
            print("Error setting up camera: \(error)")
        }
        
        session.commitConfiguration()
        startSession()
    }
    
    private func startSession() {
        guard !isSessionRunning else { return }
        
        Task {
            session.startRunning()
            await MainActor.run {
                self.isSessionRunning = session.isRunning
            }
        }
    }
    
    func stopSession() {
        guard isSessionRunning else { return }
        
        session.stopRunning()
        isSessionRunning = false
    }
}

// Non-isolated class to hold the frame handler
class FrameHandlerHolder: @unchecked Sendable {
    var handler: ((CMSampleBuffer) -> Void)?
}

extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameHandlerHolder.handler?(sampleBuffer)
    }
}

#Preview {
    CameraView()
}