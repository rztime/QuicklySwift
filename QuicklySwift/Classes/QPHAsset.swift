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
    /// 导出视频到沙盒，并转换格式
    func qconvertTo(_ type: AVFileType, progress: ((_ progress: Double) -> Void)?, complete: @escaping ((_ url: URL?, _ error: Error?) -> Void)) {
        guard self.mediaType == .video else {
            complete(nil, NSError(domain: "非视频文件", code: 0))
            return
        }
        self.qoriginVideo { p in
            progress?(min(p, 0.5))
        } complete: { video in
            video?.convertTo(type, progress: { p in
                progress?(max(p, 0.5))
            }, complete: { url, error in
                complete(url, error)
            })
        }
    }
}
public extension PHAsset {
    /// 获取图片原始data
    /// png、gif 直接返回原图data，jpeg方向正确时也返回原图data
    /// 方向需要修正、其他格式图片，将转换为jpeg data
    /// rate用于计算压缩比例, 如果转换后data比原data大，则压缩至data.count * rate
    /// maxIterations 在压缩至rate时，最大循环次数
    @discardableResult
    func qimageData(rate: CGFloat = 1.1, maxIterations: Int = 10, progress: ((_ progress: Double) -> Void)?, complete: ((_ data: Data?, _ suffix: String) -> Void)?) -> PHImageRequestID {
        let option = PHImageRequestOptions.init()
        option.isNetworkAccessAllowed = true
        option.resizeMode = .fast
        option.deliveryMode = .highQualityFormat
        option.progressHandler = { p, error, _, _ in
            progress?(p)
        }
        func exe(data: Data?, uti: String?, up: Bool) {
            guard let data = data, let suffix = uti?.lowercased().components(separatedBy: ".").last else {
                complete?(data, "")
                return
            }
            if suffix == "gif"
                || suffix == "png"
                || ((suffix == "jpeg" || suffix == "jpg") && up) {
                complete?(data, suffix)
                return
            }
            let maxCount = CGFloat(data.count) * rate
            let temp = UIImage(data: data)?.qfixOrientation.qtoJepgData(maxBytes: Int(maxCount), maxIterations: maxIterations)
            complete?(temp, "jpeg")
        }
        if #available(iOS 13, *) {
            return PHImageManager.default().requestImageDataAndOrientation(for: self, options: option) { data, uti, orientation, _ in
                exe(data: data, uti: uti, up: orientation == .up)
            }
        } else {
            return PHImageManager.default().requestImageData(for: self, options: option) { data, uti, orientation, _ in
                exe(data: data, uti: uti, up: orientation == .up)
            }
        }
    }
}
public extension AVURLAsset {
    /// 导出视频到沙盒，并转换格式
    func convertTo(_ type: AVFileType, progress: ((_ progress: Double) -> Void)?, complete: @escaping ((_ url: URL?, _ error: Error?) -> Void)) {
        let video = self
        guard let exportSession = AVAssetExportSession(asset: video, presetName: AVAssetExportPresetHighestQuality) else {
            complete(nil, NSError(domain: "导出视频失败", code: 0))
            return
        }
        var session: AVAssetExportSession?
        session = exportSession
        let tmpPath = APPLive.share.tmpPath
        let url = "\(tmpPath)/\(type.nameExtension)_\(getFile_index()).\(type.nameExtension)".qtoURL
        exportSession.outputFileType = type
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = url
        exportSession.exportAsynchronously {
            guard let s = session else {
                complete(nil, NSError(domain: "导出视频失败", code: 0))
                return
            }
            switch s.status {
            case .completed:
                complete(url, nil)
                session = nil
            case .failed:
                complete(nil, NSError(domain: "导出视频失败", code: 0))
                session = nil
            case .unknown, .waiting, .exporting:
                break
            case .cancelled:
                complete(nil, NSError(domain: "导出操作取消", code: 0))
                session = nil
            @unknown default:
                session = nil
                break
            }
        }
        Timer.qtimer(interval: 0.1, target: exportSession, repeats: true, mode: .common) { [weak session] t in
            guard let s = session else {
                t.invalidate()
                return
            }
            switch s.status {
            case .exporting:
                let p = s.progress
                progress?(Double(p))
            default:
                break
            }
        }
    }
}

public class APPLive {
    public static var share = APPLive.init()
    public let target = NSObject()
    public init() {
        FileManager.default.qdeleteFile(url: self.tmpPath.qtoURL)
        NotificationCenter.default.qaddObserver(name: UIApplication.willTerminateNotification, object: nil, target: target) { notification in
            FileManager.default.qdeleteFile(url: self.tmpPath.qtoURL)
        }
        FileManager.default.qcreateDirectory(atPath: self.tmpPath)
    }
    public var tmpPath: String {
        return "file://\(NSHomeDirectory())/tmp/QuicklySwift"
    }
}

public var file_index: Int = 0
public func getFile_index() -> Int {
    file_index += 1
    return file_index
}
public extension AVFileType {
    var nameExtension: String {
        if #available(iOS 11.0, *) {
            switch self {
            case .jpg:
                return "jpg"
            case .heic:
                return "heic"
            case .heif:
                return "heif"
            default:
                break
            }
        }
        switch self {
        case .mov:
            return "mov"
        case .mp4:
            return "mp4"
        case .m4v:
            return "m4v"
        case .m4a:
            return "m4a"
        case .mobile3GPP:
            return "3gp"
        case .mobile3GPP2:
            return "3g2"
        case .caf:
            return "caf"
        case .wav:
            return "wav"
        case .aiff:
            return "aif"
        case .aifc:
            return "aifc"
        case .amr:
            return "amr"
        case .mp3:
            return "mp3"
        case .au:
            return "au"
        case .ac3:
            return "ac3"
        default:
            return ""
        }
    }
}
