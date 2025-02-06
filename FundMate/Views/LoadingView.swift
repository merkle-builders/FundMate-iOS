import SwiftUI

struct LoadingView: View {
    let text: String
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: CGFloat = 0.6
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Modern animated loader
            ZStack {
                // Outer circle
                Circle()
                    .stroke(Theme.primary.opacity(0.2), lineWidth: 8)
                    .frame(width: 60, height: 60)
                
                // Animated arc
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Theme.primary, style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round
                    ))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotation))
                
            }
            
            // Loading text
            Text(text)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .onAppear {
            // Start animations
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            
            withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                scale = 0.8
                opacity = 1.0
            }
        }
    }
} 