//
//  QuicklyFile.swift
//  QuicklySwift
//
//  Created by rztime on 2023/7/24.
//

import UIKit
import AVFoundation

public extension FileAttributeKey {
    /// 音视频时长
    static let qduration = FileAttributeKey.init(rawValue: "qduration")
}
/// 用于通过url来获取文件的信息，如类型、时长、size等等
public class QuicklyFile {
    /// 获取url对应的文件的头部信息，包括文件类型，音视频时长，文件szie等，url如果为本地文件，需要包含file://
    public class func fileInfo(with url: String?, complete: ((_ info: [AnyHashable: Any]?) -> Void)?) {
        guard let url = url?.qtoURL else {
            complete?(nil)
            return
        }
        /// 如果是http文件
        if url.absoluteString.hasPrefix("http") {
            var request = URLRequest.init(url: url)
            request.httpMethod = "HEAD"
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 5
            
            let session = URLSession.init(configuration: configuration)
            let task = session.dataTask(with: request) { data, response, error in
                session.invalidateAndCancel()
                let info = NSMutableDictionary.init()
                if let res = response as? HTTPURLResponse {
                    info.addEntries(from: res.allHeaderFields)
                }
                DispatchQueue.global().async {
                    let avasset = AVURLAsset(url: url)
                    info[FileAttributeKey.qduration] = CMTimeGetSeconds(avasset.duration)
                    DispatchQueue.main.async {
                        complete?(info as? [AnyHashable : Any])
                    }
                }
            }
            task.resume()
            return
        }
        // 如果是本地文件
        DispatchQueue.global().async {
            let info = NSMutableDictionary.init()
            if #available(iOS 16.0, *) {
                if let file = try? FileManager.default.attributesOfItem(atPath: url.path()) {
                    info.addEntries(from: file)
                }
            } else {
                if let file = try? FileManager.default.attributesOfItem(atPath: url.path) {
                    info.addEntries(from: file)
                }
            }
            let avasset = AVURLAsset(url: url)
            info[FileAttributeKey.qduration] = CMTimeGetSeconds(avasset.duration)
            DispatchQueue.main.async {
                complete?(info as? [AnyHashable : Any])
            }
        }
    }
}
public extension FileManager {
    /// 创建文件，返回true表示创建成功, 如已存在，则不处理
    @discardableResult
    func qcreateDirectory(at: URL, withIntermediateDirectories: Bool = true, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        if self.fileExists(atPath: at.path) {
            return true
        }
        try? self.createDirectory(at: at, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
        return self.fileExists(atPath: at.path)
    }
    /// 创建文件，返回true表示创建成功，如已存在，则不处理
    @discardableResult
    func qcreateDirectory(atPath: String, withIntermediateDirectories: Bool = true, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        guard let url = atPath.qtoURL else {
            return false
        }
        return self.qcreateDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
    }
    /// 删除文件 true: 删除成功
    @discardableResult
    func qdeleteFile(url: URL?) -> Bool {
        guard let url = url else { return false }
        if self.fileExists(atPath: url.path) {
            try? self.removeItem(at: url)
            return true
        }
        return false
    }
    /// 查找模式
    enum QFileFindModel {
        /// 完全一致
        case equal
        /// 包含
        case contain
        /// 头部匹配
        case prefix
        /// 尾部匹配
        case suffix
    }
    /// 通过文件名查找文件
    /// - Parameters:
    ///   - name: 文件名
    ///   - model: 匹配模式
    ///   - url: 查找路径，nil时，默认为NSHomeDirection()
    /// - Returns: 所有找到的文件的url
    func qfindFiles(name: String, model: QFileFindModel, from url: URL?) -> [URL] {
        func getFile(folder: QuicklyFileBrowserViewModel.FileFolder) -> [URL] {
            var urls: [URL] = []
            if folder.isDirection {
                folder.childPaths.forEach { folder in
                    let res = getFile(folder: folder)
                    urls.append(contentsOf: res)
                }
            } else {
                var success = false
                switch model {
                case .equal:
                    if folder.name == name { success = true }
                case .contain:
                    if folder.name.contains(name) { success = true }
                case .prefix:
                    if folder.name.hasPrefix(name) { success = true }
                case .suffix:
                    if folder.name.hasSuffix(name) { success = true }
                }
                if success, let u = folder.path.qtoURL {
                    urls.append(u)
                }
            }
            return urls
        }
        let folder = QuicklyFileBrowserViewModel.init(path: url?.absoluteString).folder
        let res = getFile(folder: folder)
        return res
    }
}
public extension FileManager {
    /// 将pcm转化为wav格式的data
    /// - Parameters:
    ///   - url: pcm文件路径
    ///   - sample_rate: 采样率 （一般8k， 16k），如果采样率和pcm不一致，转换出来的音频可能会变声
    ///   - channels: 通道
    /// - Returns: wav的data
    func qPCM2WAV(pcmUrl: URL?, sample_rate: Int, channels: Int) -> Data? {
        guard let url = pcmUrl, let data = try? Data(contentsOf: url) else { return nil }
        return self.qPCM2WAV(pcmData: data, sample_rate: sample_rate, channels: channels)
    }
    /// 将pcm转换为wav，并保存到wavURL
    @discardableResult
    func qPCM2WAVAndSave(pcmUrl: URL?, sample_rate: Int, channels: Int, wavURL: URL?) -> Bool {
        guard let url = pcmUrl, let data = try? Data(contentsOf: url), let wavURL = wavURL else { return false }
        let wav = self.qPCM2WAV(pcmData: data, sample_rate: sample_rate, channels: channels)
        return self.createFile(atPath: wavURL.path, contents: wav)
    }
    /// 将pcm转化为wav格式的data
    /// - Parameters:
    ///   - data: pcm data
    ///   - sample_rate: 采样率 （一般8k， 16k），如果采样率和pcm不一致，转换出来的音频可能会变声
    ///   - channels: 通道 1 or 2
    /// - Returns: wav的data
    func qPCM2WAV(pcmData: Data?, sample_rate: Int, channels: Int) -> Data? {
        guard let pcmData = pcmData else {
            return nil
        }
        // WAV 文件头的大小（44 字节）
        let headerSize: Int32 = 44
        // WAV 文件头
        var header = [UInt8](repeating: 0, count: Int(headerSize))
        // RIFF chunk descriptor
        header[0] = 0x52 // 'R'
        header[1] = 0x49 // 'I'
        header[2] = 0x46 // 'F'
        header[3] = 0x46 // 'F'
        // Chunk size (36 + PCM data size)
        let pcmDataSize = pcmData.count
        let chunkSize = pcmDataSize + 36
        header[4] = UInt8((chunkSize & 0xFF000000) >> 24)
        header[5] = UInt8((chunkSize & 0x00FF0000) >> 16)
        header[6] = UInt8((chunkSize & 0x0000FF00) >> 8)
        header[7] = UInt8(chunkSize & 0x000000FF)
        // Format type "WAVE"
        header[8] = 0x57 // 'W'
        header[9] = 0x41 // 'A'
        header[10] = 0x56 // 'V'
        header[11] = 0x45 // 'E'
        // fmt sub-chunk
        header[12] = 0x66 // 'f'
        header[13] = 0x6D // 'm'
        header[14] = 0x74 // 't'
        header[15] = 0x20 // ' '
        // Sub-chunk 1 size 16 for PCM
        header[16] = 0x10 // 16
        header[17] = 0x00
        header[18] = 0x00
        header[19] = 0x00
        // Audio format (PCM = 1)
        header[20] = 0x01
        header[21] = 0x00
        // Number of channels
        header[22] = (UInt8)(channels & 0xFF)
        header[23] = (UInt8)((channels >> 8) & 0xFF)
        // Sample rate
        header[24] = (UInt8)(sample_rate & 0xFF)
        header[25] = (UInt8)((sample_rate >> 8) & 0xFF)
        header[26] = (UInt8)((sample_rate >> 16) & 0xFF)
        header[27] = (UInt8)((sample_rate >> 24) & 0xFF)
        // Byte rate = SampleRate * NumChannels * BitsPerSample/8
        let byteRate = sample_rate * channels * 2 // Assuming 16-bit samples
        header[28] = (UInt8)(byteRate & 0xFF)
        header[29] = (UInt8)((byteRate >> 8) & 0xFF)
        header[30] = (UInt8)((byteRate >> 16) & 0xFF)
        header[31] = (UInt8)((byteRate >> 24) & 0xFF)
        // Block align = NumChannels * BitsPerSample/8
        let blockAlign = channels * 2 // Assuming 16-bit samples
        header[32] = (UInt8)(blockAlign & 0xFF)
        header[33] = (UInt8)((blockAlign >> 8) & 0xFF)
        // Bits per sample
        header[34] = 0x10 // 16 bits
        header[35] = 0x00
        // Sub-chunk 2 descriptor
        header[36] = 0x64 // 'd'
        header[37] = 0x61 // 'a'
        header[38] = 0x74 // 't'
        header[39] = 0x61 // 'a'
        // Sub-chunk 2 size = PCM data size
        header[40] = (UInt8)(pcmDataSize & 0xFF)
        header[41] = (UInt8)((pcmDataSize >> 8) & 0xFF)
        header[42] = (UInt8)((pcmDataSize >> 16) & 0xFF)
        header[43] = (UInt8)((pcmDataSize >> 24) & 0xFF)
        // Combine header and PCM data
        var wavData = Data(header)
        wavData.append(pcmData)
        return wavData
    }
}
