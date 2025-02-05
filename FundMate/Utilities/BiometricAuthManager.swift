import LocalAuthentication

enum BiometricAuthManager {
    static func authenticate(reason: String) async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw error ?? NSError(domain: "BiometricAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Biometric authentication not available"])
        }
        
        return try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        )
    }
} 