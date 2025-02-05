import SwiftUI

enum HapticManager {
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // Custom patterns
    static func paymentSuccess() {
        // Double tap success pattern
        Task {
            impact(style: .light)
            try? await Task.sleep(nanoseconds: 100_000_000)
            notification(type: .success)
        }
    }
    
    static func paymentFailed() {
        // Error pattern
        Task {
            impact(style: .heavy)
            try? await Task.sleep(nanoseconds: 100_000_000)
            notification(type: .error)
        }
    }
} 