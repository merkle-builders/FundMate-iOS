import Foundation

struct Token: Identifiable, Equatable {
    let id: UUID
    let symbol: String
    let name: String
    let iconName: String // SF Symbol name
    let currentPrice: Double
    
    static let mockTokens = [
        Token(id: UUID(), symbol: "ETH", name: "Ethereum", iconName: "bitcoinsign.circle.fill", currentPrice: 2850.0),
        Token(id: UUID(), symbol: "BTC", name: "Bitcoin", iconName: "bitcoinsign.circle.fill", currentPrice: 93000.0),
        Token(id: UUID(), symbol: "USDC", name: "USD Coin", iconName: "dollarsign.circle.fill", currentPrice: 1.0),
        Token(id: UUID(), symbol: "APT", name: "Aptos", iconName: "bitcoinsign.circle.fill", currentPrice: 8.50)
    ]
} 