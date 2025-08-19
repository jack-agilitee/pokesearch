import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraModel = CameraModel()
    @Environment(\.dismiss) private var dismiss
    @State private var scanLineOffset: CGFloat = -175
    @State private var pulseOpacity: Double = 0.3
    
    var body: some View {
        ZStack {
            CameraPreview(session: cameraModel.session)
                .edgesIgnoringSafeArea(.all)
            
            CameraOverlay(
                scanLineOffset: $scanLineOffset,
                pulseOpacity: $pulseOpacity
            )
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .onAppear {
            cameraModel.checkPermissions()
            startAnimations()
        }
        .onDisappear {
            cameraModel.stopSession()
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
        previewLayer.videoGravity = .resizeAspectFill
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
class CameraModel: ObservableObject {
    let session = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput?
    @Published var isSessionRunning = false
    @Published var permissionGranted = false
    
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

#Preview {
    CameraView()
}