import SwiftUI

// MARK: - Animation Modifiers
struct SlideTransitionModifier: ViewModifier {
    let edge: Edge
    
    func body(content: Content) -> some View {
        content.transition(
            .asymmetric(
                insertion: .move(edge: edge).combined(with: .opacity),
                removal: .move(edge: edge).combined(with: .opacity)
            )
        )
    }
}

struct TabTransitionModifier: ViewModifier {
    let direction: Double
    
    func body(content: Content) -> some View {
        content.transition(
            .asymmetric(
                insertion: .offset(x: 30 * direction).combined(with: .opacity),
                removal: .offset(x: -30 * direction).combined(with: .opacity)
            )
        )
    }
}

struct LogoBounceModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - View Extensions
extension View {
    func slideTransition(edge: Edge) -> some View {
        modifier(SlideTransitionModifier(edge: edge))
    }
    
    func tabTransition(direction: Double) -> some View {
        modifier(TabTransitionModifier(direction: direction))
    }
} 