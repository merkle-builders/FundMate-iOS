import SwiftUI

struct PaymentConfirmationSheet: View {
    let amount: Double
    let sourceToken: Token
    let destToken: Token
    let recipientAddress: String
    let note: String?
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Payment Summary Card
                    VStack(spacing: 16) {
                        Text("Payment Summary")
                            .font(.headline)
                        
                        Divider()
                        
                        // Amount Details
                        HStack {
                            Text("You Pay")
                            Spacer()
                            Text("\(amount, specifier: "%.2f") \(sourceToken.symbol)")
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Text("They Receive")
                            Spacer()
                            Text("\(amount * (sourceToken.currentPrice / destToken.currentPrice), specifier: "%.2f") \(destToken.symbol)")
                                .fontWeight(.medium)
                        }
                        
                        if let note = note, !note.isEmpty {
                            Divider()
                            VStack(alignment: .leading) {
                                Text("Note")
                                    .font(.subheadline)
                                Text(note)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Divider()
                        
                        // Recipient
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Recipient")
                                .font(.subheadline)
                            Text(recipientAddress)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Theme.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Confirm Button
                    Button(action: onConfirm) {
                        Text("Confirm Payment")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primary)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            .navigationTitle("Confirm Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 