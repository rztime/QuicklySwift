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
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let res = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return res
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
        guard var data = self.qtoJpegData(compressionQuality: 1) else { return nil }
        var rate = CGFloat(data.count) / maxLength
        while CGFloat(data.count) > maxLength {
            data = self.qtoJpegData(compressionQuality: 1/rate) ?? .init()
            rate += 0.1
        }
        return data
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
