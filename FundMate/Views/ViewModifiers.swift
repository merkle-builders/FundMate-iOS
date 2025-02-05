import SwiftUI

struct SlideTransition: ViewModifier {
    let edge: Edge
    
    func body(content: Content) -> some View {
        content
            .transition(.move(edge: edge).combined(with: .opacity))
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct TabTransition: ViewModifier {
    let direction: Double
    
    func body(content: Content) -> some View {
        content
            .transition(.asymmetric(
                insertion: .offset(x: direction > 0 ? 50 : -50).combined(with: .opacity),
                removal: .offset(x: direction < 0 ? 50 : -50).combined(with: .opacity)
            ))
    }
}

extension View {
    func slideTransition(_ edge: Edge = .trailing) -> some View {
        modifier(SlideTransition(edge: edge))
    }
    
    func shake(animating: Bool) -> some View {
        modifier(ShakeEffect(animatableData: animating ? 1 : 0))
    }
    
    func tabTransition(direction: Double) -> some View {
        modifier(TabTransition(direction: direction))
    }
} 