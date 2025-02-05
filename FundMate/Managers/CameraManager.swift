import AVFoundation
import SwiftUI

class CameraManager: NSObject, ObservableObject {
    @Published var captureSession: AVCaptureSession?
    @Published var error: Error?
    @Published var scannedCode: String?
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    func setupCaptureSession() {
        let session = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            error = NSError(domain: "CameraManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Camera not available"])
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            }
            
            captureSession = session
        } catch {
            self.error = error
        }
    }
    
    func startScanning() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
    }
}

extension CameraManager: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            scannedCode = stringValue
            stopScanning()
        }
    }
} 