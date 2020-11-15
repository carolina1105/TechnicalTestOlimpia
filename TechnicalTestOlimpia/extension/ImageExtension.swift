//
//  ImageExtension.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit
import ImageIO
import Photos
import CoreServices

fileprivate func <<T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

extension UIImage {
    static let zero: CGFloat = 0
    static let width: CGFloat = 1024
    
    func resized(withPercentage percentage: CGFloat,
                 isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat,
                 isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func resize(image: UIImage) -> UIImage {
        let scale = UIImage.width / image.size.width
        let height = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: UIImage.width,
                                           height: height))
        image.draw(in: CGRect(x: UIImage.zero,
                              y: UIImage.zero,
                              width: UIImage.width,
                              height: height))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

struct ImageHeaderData {
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
}

enum ImageFormat: String {
    case unknown = "unknown"
    case png = "png"
    case jpeg = "jpeg"
    case gif = "gif"
    case tiff = "tiff"
}


extension NSData {
    var `extension`: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 1)
        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
        if buffer == ImageHeaderData.PNG {
            return .png
        } else if buffer == ImageHeaderData.JPEG {
            return .jpeg
        } else if buffer == ImageHeaderData.GIF {
            return .gif
        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02 {
            return .tiff
        } else {
            return .unknown
        }
    }
}

extension UIImage {
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        guard let gif = UIImage.animatedImageWithSource(source)?.withRenderingMode(.alwaysTemplate) else {
            return nil
        }
        return gif
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)!.withRenderingMode(.alwaysTemplate)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle(identifier: "co.com.naposystems.NNKeyboard")?
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)!.withRenderingMode(.alwaysTemplate)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}

//extension UIImage {
//    static let docIconSize: CGFloat = 0.75
//    static let documentSize: CGFloat = 45.0
//    
//    static func icon(by type: DocumentType) -> UIImage {
//        let symbol = UIImage.SymbolConfiguration(pointSize: documentSize * docIconSize,
//                                                 weight: .regular)
//        switch type {
//            case .doc:
//                return UIImage(named: "AttachmentDoc")!
//                    .withRenderingMode(.alwaysTemplate)
//            case .docx:
//                return UIImage(named: "AttachmentDocx")!
//                    .withRenderingMode(.alwaysTemplate)
//            case .pdf:
//                return UIImage(named: "AttachmentPdf")!
//                    .withRenderingMode(.alwaysTemplate)
//            case .ppt:
//                return UIImage(named: "AttachmentPpt")!
//                    .withRenderingMode(.alwaysTemplate)
//            case .pptx:
//                return UIImage(named: "AttachmentPptx")!
//                    .withRenderingMode(.alwaysTemplate)
//            case .xls:
//                return UIImage(named: "AttachmentXls")!
//                    .withRenderingMode(.alwaysTemplate)
//            case .xlsx:
//                return UIImage(named: "AttachmentXlsx")!
//                    .withRenderingMode(.alwaysTemplate)
//        default:
//            return UIImage(systemName: "book.circle",
//                           withConfiguration: symbol)!
//                .withRenderingMode(.alwaysTemplate)
//        }
//    }
//}

extension PHAsset {
    var fileSize: Float {
        get {
            let resource = PHAssetResource.assetResources(for: self)
            let imageSizeByte = resource.first?.value(forKey: "fileSize") as! Int64
            let imageSizeMB = imageSizeByte / (1024*1024)
            return Float(imageSizeMB)
        }
    }
}

extension CIContext {
    func createCGImage_(image:CIImage, fromRect:CGRect) -> CGImage? {
        let width = Int(fromRect.width)
        let height = Int(fromRect.height)

        let rawData =  UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
        render(image, toBitmap: rawData, rowBytes: width * 4, bounds: fromRect, format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        let dataProvider = CGDataProvider(dataInfo: nil, data: rawData, size: height * width * 4) { info, data, size in
            data.deallocate()
        }
        
        guard let provier = dataProvider else {
            return nil
        }

        return CGImage(width: width,
                       height: height,
                       bitsPerComponent: 8,
                       bitsPerPixel: 32, bytesPerRow: width * 4,
                       space: CGColorSpaceCreateDeviceRGB(),
                       bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                       provider: provier,
                       decode: nil,
                       shouldInterpolate: false,
                       intent: CGColorRenderingIntent.defaultIntent)!
    }
}
