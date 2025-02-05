import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreview {
        let view = CameraPreview()
        view.backgroundColor = .black
        view.session = session
        return view
    }
    
    func updateUIView(_ uiView: CameraPreview, context: Context) {}
}

class CameraPreview: UIView {
    var session: AVCaptureSession? {
        get { previewLayer.session }
        set { previewLayer.session = newValue }
    }
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 