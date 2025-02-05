//
//  FundMateApp.swift
//  FundMate
//
//  Created by Mihir Sahu on 5/2/25.
//

import SwiftUI

@main
struct FundMateApp: App {
    @StateObject private var priceTracker = TokenPriceTracker()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(priceTracker)
        }
    }
}
