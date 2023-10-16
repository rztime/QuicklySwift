//
//  QuicklyPHAsset.swift
//  QuicklySwift
//
//  Created by rztime on 2023/3/6.
//

import UIKit
import Photos

public extension PHAsset {
    /// PHAsset的在本地文件的url
    var qurl: URL? {
        let resource = PHAssetResource.assetResources(for: self)
        if let u = resource.first?.value(forKey: "privateFileURL") as? URL {
            return u
        }
        return nil
    }
    /// 是否是无效资源
    var qisEmpty: Bool {
        return self.localIdentifier.contains("(null)")
    }
    /// 是否是iCloud资源，此方法会卡线程，谨慎使用
    var qisIcloud: Bool {
        let resource = PHAssetResource.assetResources(for: self)
        if resource.count >= 1 {
            let islocal = (resource.first?.value(forKey: "locallyAvailable") as? Bool) ?? false
            return !islocal
        }
        return false
    }
    /// 文件大小size
    var qbyteSize: Double {
        if let res = PHAssetResource.assetResources(for: self).first, let size = res.value(forKey: "fileSize") as? NSNumber {
            return size.doubleValue
        }
        return 0
    }
    /// 是否是gif
    var qisGif: Bool {
        if self.mediaType == .image {
            if let value = self.value(forKey: "filename") as? String, (value.hasSuffix("GIF") || value.hasSuffix("gif")) {
                return true
            }
        }
        return false
    }
    /// 获取缩略图
    @discardableResult
    func qfastImage(maxWidth: CGFloat = 480, progress: ((_ progress: Double) -> Void)?, complete: ((_ image: UIImage?) -> Void)?) -> PHImageRequestID {
        let option = PHImageRequestOptions.init()
        option.isNetworkAccessAllowed = true
        option.resizeMode = .fast
        option.deliveryMode = .fastFormat
        option.progressHandler = { p, _, _, _ in
            progress?(p)
        }
        let size = CGSize.init(width: self.pixelWidth, height: self.pixelHeight).qscaleto(maxWidth: maxWidth)
        return PHImageManager.default().requestImage(for: self, targetSize: size, contentMode: .default, options: option) { image, _ in
            complete?(image?.qfixOrientation)
        }
    }
    /// 获取原图（如果是iCloud会下载）
    @discardableResult
    func qoriginImage(progress: ((_ progress: Double) -> Void)?, complete: ((_ image: UIImage?) -> Void)?) -> PHImageRequestID {
        let option = PHImageRequestOptions.init()
        option.isNetworkAccessAllowed = true
        option.resizeMode = .fast
        option.deliveryMode = .highQualityFormat
        option.progressHandler = { p, error, _, _ in
            progress?(p)
        }
        let size = CGSize.init(width: self.pixelWidth, height: self.pixelHeight)
        return PHImageManager.default().requestImage(for: self, targetSize: size, contentMode: .default, options: option) { image, _ in
            complete?(image?.qfixOrientation)
        }
    }
    /// 获取原图（如果是iCloud会下载）
    @discardableResult
    func qoriginImageData(progress: ((_ progress: Double) -> Void)?, complete: ((_ data: Data?) -> Void)?) -> PHImageRequestID {
        let option = PHImageRequestOptions.init()
        option.isNetworkAccessAllowed = true
        option.resizeMode = .fast
        option.deliveryMode = .highQualityFormat
        option.progressHandler = { p, error, _, _ in
            progress?(p)
        }
        if #available(iOS 13, *) {
            return PHImageManager.default().requestImageDataAndOrientation(for: self, options: option) { data, _, _, _ in
                complete?(data)
            }
        } else {
            return PHImageManager.default().requestImageData(for: self, options: option) { data, _, _, _ in
                complete?(data)
            }
        }
    }
    /// 获取原视频（如果是iCloud会下载）
    @discardableResult
    func qoriginVideo(progress: ((_ progress: Double) -> Void)?, complete: ((_ video: AVURLAsset?) -> Void)?) -> PHImageRequestID {
        guard self.mediaType == .video else {
            progress?(1)
            complete?(nil)
            return PHInvalidImageRequestID
        }
        let option = PHVideoRequestOptions.init()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        option.progressHandler = { p, error, _, _ in
            progress?(p)
        }
        return PHImageManager.default().requestAVAsset(forVideo: self, options: option) { av, _, _ in
            DispatchQueue.main.async {
                complete?(av as? AVURLAsset)
            }
        }
    }
}


