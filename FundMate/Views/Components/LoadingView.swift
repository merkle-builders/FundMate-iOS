import SwiftUI

// Add a reusable loading view
struct LoadingView: View {
    let text: String
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            Text(text)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
} 