import Foundation

struct Message: Identifiable, Equatable {
    let id: UUID
    let content: String
    let timestamp: Date
    let isFromCurrentUser: Bool
    let type: MessageType
    
    enum MessageType: Equatable {
        case text
        case payment(amount: Double, status: PaymentStatus)
    }
    
    enum PaymentStatus: Equatable {
        case pending
        case completed
        case failed
    }
    
    static let mockMessages = [
        Message(id: UUID(), content: "Hey! Can you send me $20 for lunch?", timestamp: Date().addingTimeInterval(-3600), isFromCurrentUser: false, type: .text),
        Message(id: UUID(), content: "Sure, sending it now!", timestamp: Date().addingTimeInterval(-3500), isFromCurrentUser: true, type: .text),
        Message(id: UUID(), content: "$20.00", timestamp: Date().addingTimeInterval(-3400), isFromCurrentUser: true, type: .payment(amount: 20.0, status: .completed)),
        Message(id: UUID(), content: "Thanks! 😊", timestamp: Date().addingTimeInterval(-3300), isFromCurrentUser: false, type: .text),
    ]
} 