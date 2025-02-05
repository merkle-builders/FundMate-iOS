import Foundation
import Combine

class TokenPriceTracker: ObservableObject {
    @Published private(set) var prices: [String: Double] = [:]
    private var timer: Timer?
    
    init() {
        // Start with initial prices
        updatePrices()
        
        // Update prices every 30 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.updatePrices()
        }
    }
    
    private func updatePrices() {
        // Simulate price updates with random fluctuations
        let tokens = Token.mockTokens
        for token in tokens {
            let currentPrice = prices[token.symbol] ?? token.currentPrice
            let fluctuation = Double.random(in: -0.02...0.02) // ±2% change
            prices[token.symbol] = currentPrice * (1 + fluctuation)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
} 