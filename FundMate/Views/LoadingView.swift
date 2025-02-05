import SwiftUI

struct LoadingView: View {
    let text: String
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            Text(text)
                .foregroundStyle(.secondary)
        }
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.red)
            
            Text("Oops!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
        .padding()
    }
} 