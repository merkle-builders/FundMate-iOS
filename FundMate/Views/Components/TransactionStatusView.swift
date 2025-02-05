import SwiftUI

struct TransactionStatusView: View {
    let status: TransactionStatus
    let onDismiss: () -> Void
    
    enum TransactionStatus {
        case processing
        case success
        case failure(Error)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            switch status {
            case .processing:
                ProgressView()
                    .controlSize(.large)
                Text("Processing Payment...")
                    .font(.headline)
                
            case .success:
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                Text("Payment Successful!")
                    .font(.headline)
                Button("Done") {
                    onDismiss()
                }
                .buttonStyle(.bordered)
                
            case .failure(let error):
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.red)
                Text("Payment Failed")
                    .font(.headline)
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Try Again") {
                    onDismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 20)
        .padding()
    }
} 