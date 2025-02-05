import SwiftUI
import AVFoundation

struct QRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraManager = CameraManager()
    @State private var showingPaymentSheet = false
    @State private var scannedAddress: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let session = cameraManager.captureSession {
                    CameraPreviewView(session: session)
                        .overlay {
                            QRScannerOverlay()
                        }
                } else {
                    Color.black
                        .overlay {
                            if let error = cameraManager.error {
                                ErrorView(error: error) {
                                    cameraManager.setupCaptureSession()
                                }
                            } else {
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                }
            }
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Toggle torch
                    } label: {
                        Image(systemName: "flashlight.off.fill")
                    }
                }
            }
            .onAppear {
                cameraManager.startScanning()
            }
            .onDisappear {
                cameraManager.stopScanning()
            }
            .onChange(of: cameraManager.scannedCode) { oldCode, newCode in
                if let newCode {
                    scannedAddress = newCode
                    showingPaymentSheet = true
                }
            }
            .sheet(isPresented: $showingPaymentSheet) {
                if let address = scannedAddress {
                    PaymentSheet(receiverAddress: address)
                }
            }
        }
    }
}

struct QRScannerOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .overlay {
                    Rectangle()
                        .stroke(Theme.primary, lineWidth: 3)
                        .frame(width: 250, height: 250)
                        .background(.clear)
                }
                .mask {
                    Rectangle()
                        .overlay {
                            Rectangle()
                                .frame(width: 250, height: 250)
                                .blendMode(.destinationOut)
                        }
                }
            
            VStack {
                Spacer()
                Text("Position the QR code within the frame")
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding(.bottom, 60)
            }
        }
        .ignoresSafeArea()
    }
} 