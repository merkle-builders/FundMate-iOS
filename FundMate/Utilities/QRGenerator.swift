import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRGenerator {
    static func generateQRCode(from string: String, size: CGFloat = 200) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        filter.correctionLevel = "H"
        
        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: size/10, y: size/10))
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
} 