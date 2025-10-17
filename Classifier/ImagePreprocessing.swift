//
//  ImagePreprocessing.swift
//  MobileNet Classifier
//
//  Created by Sam Greenfield on 5/28/25.
//

import Foundation
import UIKit
import CoreML

func preprocess(image: UIImage, size: CGSize = CGSize(width: 192, height: 192)) -> (CVPixelBuffer?, UIImage?) {
    guard let resized = image.normalized().centerCropped(to: size),
          let cgImage = resized.cgImage else {
        return (nil, nil)
    }

    let attrs = [
        kCVPixelBufferCGImageCompatibilityKey: true,
        kCVPixelBufferCGBitmapContextCompatibilityKey: true
    ] as CFDictionary

    var buffer: CVPixelBuffer?
    let status = CVPixelBufferCreate(
        kCFAllocatorDefault,
        Int(size.width),
        Int(size.height),
        kCVPixelFormatType_32BGRA,
        attrs,
        &buffer
    )

    guard status == kCVReturnSuccess, let pixelBuffer = buffer else {
        return (nil, nil)
    }

    CVPixelBufferLockBaseAddress(pixelBuffer, [])
    let context = CGContext(
        data: CVPixelBufferGetBaseAddress(pixelBuffer),
        width: Int(size.width),
        height: Int(size.height),
        bitsPerComponent: 8,
        bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
    )

    context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
    CVPixelBufferUnlockBaseAddress(pixelBuffer, [])

    return (pixelBuffer, resized)
}

extension UIImage {
    func centerCropped(to size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)

        let squareLength = imageWidth
        let x: CGFloat = 0
        let y = (imageHeight - squareLength) / 2 // or use y = 0 if your overlay is at the top

        let cropRect = CGRect(x: x, y: y, width: squareLength, height: squareLength)
        guard let croppedCgImage = cgImage.cropping(to: cropRect) else { return nil }

        return UIImage(cgImage: croppedCgImage)
    }

    func toRGBData() -> [Float]? {
        guard let cgImage = self.cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var rawData = [UInt8](repeating: 0, count: height * width * bytesPerPixel)

        guard let context = CGContext(data: &rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var floatArray = [Float]()
        for i in 0..<width * height {
            let r = rawData[i * 4]
            let g = rawData[i * 4 + 1]
            let b = rawData[i * 4 + 2]
            floatArray.append(Float(r) / 255.0)
            floatArray.append(Float(g) / 255.0)
            floatArray.append(Float(b) / 255.0)
        }

        return floatArray
    }
    
    func normalized() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? self
    }
}
