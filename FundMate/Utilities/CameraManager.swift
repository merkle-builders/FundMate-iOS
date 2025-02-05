import AVFoundation
import SwiftUI

class CameraManager: NSObject, ObservableObject {
    @Published var error: Error?
    @Published var scannedCode: String?
    
    var captureSession: AVCaptureSession?
    private let metadataOutput = AVCaptureMetadataOutput()
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    func startScanning() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
    }
    
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            error = NSError(domain: "Camera", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Camera not available"
            ])
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            }
            
        } catch {
            self.error = error
        }
    }
}

extension CameraManager: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, 
                       didOutput metadataObjects: [AVMetadataObject], 
                       from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            scannedCode = stringValue
            HapticManager.notification(type: .success)
        }
    }
} 