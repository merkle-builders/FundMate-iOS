import SwiftUI
import AVFoundation

struct QRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraManager = CameraManager()
    @State private var showingPaymentSheet = false
    @State private var scannedAddress: String?
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Camera view
                CameraPreview(captureSession: cameraManager.captureSession)
                    .edgesIgnoringSafeArea(.all)
                
                // Scanning overlay
                VStack(spacing: 20) {
                    Spacer()
                    
                    // QR Frame
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(.white, lineWidth: 3)
                        .frame(width: 250, height: 250)
                        .background(.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Scanning text
                    Text("Scanning for QR Code...")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .background(Color.black.opacity(0.5))
            }
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
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
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(cameraManager.error?.localizedDescription ?? "Unknown error")
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