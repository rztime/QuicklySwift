//
//  QuicklyImage.swift
//  QuicklySwift
//
//  Created by rztime on 2023/3/7.
//

import UIKit
import AVKit

public extension UIImage {
    /// 将颜色转化为图片
    class func qimageBy(color: UIColor, size: CGSize) -> UIImage {
        return color.qtoImage(size) ?? .init()
    }
    
    /// 将渐变色转换为图片
    /// - Parameters:
    ///   - gradinentColors: 渐变色
    ///   - locations: 渐变色开始位置，数量和颜色保持一致
    ///   - start: 七点
    ///   - end: 终点
    ///   - size: 图片大小
    class func qimageBy(gradinentColors: [UIColor], locations: [NSNumber], start: CGPoint, end: CGPoint, size: CGSize) -> UIImage {
        let view = UIView.init(frame: .init(origin: .zero, size: size))
        view.qgradientColors(gradinentColors, locations: locations, start: start, end: end)
        let image = view.qtoImage()
        return image ?? .init()
    }
}
public extension UIImage {
    /// 将图片(png)重新绘制为另一个颜色
    func qreDraw(color: UIColor) -> UIImage? {
        let size = self.size
        let rect = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size, format: .default())
        return renderer.image { [weak self] context in
            color.setFill()
            context.fill(rect)
            self?.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        }
    }
    /// 将图片（png）重新绘制为渐变色， star、end的x、y范围只能为0-1
    func qreDrawWithGradient(colors: [UIColor], star: CGPoint, end: CGPoint) -> UIImage? {
        let size = self.size
        let renderer = UIGraphicsImageRenderer(size: size, format: .default())
        return renderer.image { [weak self] ctx in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let cgColors = colors.map { $0.cgColor } as CFArray
            guard let gradient = CGGradient(colorsSpace: colorSpace,
                                            colors: cgColors,
                                            locations: nil) else { return }
            let startPoint = CGPoint(x: size.width * star.x, y: size.height * star.y)
            let endPoint = CGPoint(x: size.width * end.x, y: size.height * end.y)
            ctx.cgContext.drawLinearGradient(gradient,
                                             start: startPoint,
                                             end: endPoint,
                                             options: [])
            self?.draw(in: CGRect(origin: .zero, size: size), blendMode: .destinationIn, alpha: 1.0)
        }
    }
}
public extension UIImage {
    /// 旋转（方向）
    func qrotatedBy(orientation: UIImage.Orientation) -> UIImage? {
        guard let cgImage = self.cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: orientation)
    }
    /// 旋转(角度)
    func qrotatedBy(degrees: CGFloat) -> UIImage? {
        let size = self.size
        let radians = degrees * .pi / 180
        var rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: rotatedSize, format: format)
        return renderer.image { [weak self] ctx in
            let context = ctx.cgContext
            context.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2)
            context.rotate(by: radians)
            self?.draw(in: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
        }
    }
    /// 修正图片方向
    var qfixOrientation: UIImage {
        if self.imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
        default: break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
        default: break
        }
        if let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace {
            let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)
            ctx?.concatenate(transform)
            switch self.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx?.draw(cgImage, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            default:
                ctx?.draw(cgImage, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            }
            if let cgimg: CGImage = (ctx?.makeImage()) {
                let img = UIImage(cgImage: cgimg)
                return img
            }
        }
        return self
    }
    /// 等比缩放至最大宽度maxWidth，如果图片比这个尺寸小，则不缩放
    func qscaleTo(maxWidth: CGFloat) -> UIImage {
        let size = self.size
        if size.width <= maxWidth { return self }
        return self.qscaleTo(width: maxWidth)
    }
    /// 等比缩放至宽度为width
    func qscaleTo(width: CGFloat) -> UIImage {
        guard width > 0 else { return self }
        let size = self.size.qscaleto(width: width)
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale  // 保持原图缩放比例
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { [weak self] _ in
            self?.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    /// 转换为jpeg data
    func qtoJpegData(compressionQuality: CGFloat) -> Data? {
        #if swift(>=4.2)
        return self.jpegData(compressionQuality: compressionQuality)
        #else
        return UIImageJPEGRepresentation(self, compressionQuality)
        #endif
    }
    
    /// 转换为JPEG data，单位byte， 1kb = 1024byte
    /// - Parameter maxLength: 最大长度
    func qtoJpegData(maxLength: CGFloat) -> Data? {
        return self.qtoJepgData(maxBytes: Int(maxLength), maxIterations: 10)
    }
    /// 转换为最接近maxBytes的data, 单位byte， 1kb = 1024byte
    func qtoJepgData(maxBytes: Int, maxIterations: Int = 10) -> Data? {
        guard maxBytes > 0 else { return nil }
        if let maxQualityData = jpegData(compressionQuality: 1), maxQualityData.count <= maxBytes {
            return maxQualityData
        }
        guard let minQualityData = jpegData(compressionQuality: 0.1) else { return nil }
        if minQualityData.count > maxBytes {
            return minQualityData
        }
        var (minQ, maxQ) = (CGFloat(0.1), CGFloat(0.95))
        var bestData: Data? = minQualityData
        autoreleasepool {
            for _ in 0..<maxIterations {
                let midQ = (minQ + maxQ) / 2
                guard let data = jpegData(compressionQuality: midQ) else { continue }
                if data.count <= maxBytes {
                    bestData = data
                    minQ = midQ
                } else {
                    maxQ = midQ
                }
                if (maxQ - minQ) < 0.01 { break }
            }
        }
        return bestData
    }
    /// 转换成Jpeg image
    func qtoJpegImage() -> UIImage {
        if let data = self.qtoJpegData(compressionQuality: 1) {
            return .init(data: data) ?? self
        }
        return self
    }
    /// 转换成PNG data
    func qtoPngData() -> Data? {
        #if swift(>=4.2)
        return self.pngData()
        #else
        return UIImagePNGRepresentation(self)
        #endif
    }
    /// 转换成PNG image
    func qtoPngImage() -> UIImage {
        if let data = self.qtoPngData() {
            return .init(data: data) ?? self
        }
        return self
    }
}

public extension UIImage {
    /// 通过url获取视频的首帧图
    class func qimageByVideoUrl(_ url: String?, complete: ((_ url: String?, _ image: UIImage?) -> Void)?) {
        if url.qisEmpty {
            complete?(url, nil)
            return
        }
        let helper = QImageHelper(url: url, complete: complete)
        QImageDownload.share.dowm(helper: helper)
    }
}
struct QImageHelper {
    var url: String?
    var complete: ((_ url: String?, _ image: UIImage?) -> Void)?
    
    func download(complete: ((_ helper: QImageHelper, _ image: UIImage?) -> Void)?) {
        guard let url = self.url, let U = url.qtoURL else {
            complete?(self, nil)
            return
        }
        DispatchQueue.global().async {
            let asset = AVURLAsset.init(url: U)
            let gen = AVAssetImageGenerator.init(asset: asset)
            gen.appliesPreferredTrackTransform = true
            gen.apertureMode = .encodedPixels
            var image: UIImage?
            if let thumb = try? gen.copyCGImage(at: .init(value: 0, timescale: 60), actualTime: nil) {
                image = UIImage.init(cgImage: thumb)
            }
            DispatchQueue.main.async {
                complete?(self, image)
            }
        }
    }
}
class QImageDownload {
    static var share: QImageDownload = .init()
    var list: [QImageHelper] = []
    func dowm(helper: QImageHelper) {
        if let _ = self.list.first(where: {$0.url == helper.url}) {
            
        } else {
            helper.download { [weak self] helper, image in
                self?.list.forEach({ h in
                    if h.url == helper.url {
                        h.complete?(h.url, image)
                    }
                })
                self?.list.removeAll(where: {$0.url == helper.url})
            }
        }
        self.list.append(helper)
    }
}
