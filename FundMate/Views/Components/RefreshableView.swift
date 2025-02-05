import SwiftUI

struct RefreshableView<Content: View>: View {
    let content: Content
    @Binding var isRefreshing: Bool
    let action: () async -> Void
    
    init(
        isRefreshing: Binding<Bool>,
        action: @escaping () async -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self._isRefreshing = isRefreshing
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        content
            .refreshable {
                isRefreshing = true
                await action()
            }
    }
} 