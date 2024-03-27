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
        guard let data = pcmData else { return nil }
        let total = data.count + 44
        var header: [UInt8] = Array(repeating: 0, count: 44)
        // RIFF/WAVE header
        header[0] = UInt8(ascii: "R")
        header[1] = UInt8(ascii: "I")
        header[2] = UInt8(ascii: "F")
        header[3] = UInt8(ascii: "F")
        header[4] = (UInt8)(total & 0xff)
        header[5] = (UInt8)((total >> 8) & 0xff)
        header[6] = (UInt8)((total >> 16) & 0xff)
        header[7] = (UInt8)((total >> 24) & 0xff)
        //WAVE
        header[8] = UInt8(ascii: "W")
        header[9] = UInt8(ascii: "A")
        header[10] = UInt8(ascii: "V")
        header[11] = UInt8(ascii: "E")
        // 'fmt' chunk
        header[12] = UInt8(ascii: "f")
        header[13] = UInt8(ascii: "m")
        header[14] = UInt8(ascii: "t")
        header[15] = UInt8(ascii: " ")
        // 4 bytes: size of 'fmt ' chunk
        header[16] = 16
        header[17] = 0
        header[18] = 0
        header[19] = 0
        // format = 1
        header[20] = 1
        header[21] = 0
        //chanel
        header[22] = UInt8(channels)
        header[23] = 0
        
        header[24] = (UInt8)(sample_rate & 0xff)
        header[25] = (UInt8)((sample_rate >> 8) & 0xff)
        header[26] = (UInt8)((sample_rate >> 16) & 0xff)
        header[27] = (UInt8)((sample_rate >> 24) & 0xff)
        
        let byteRate = sample_rate * channels * (16 >> 3)
        header[28] = (UInt8)(byteRate & 0xff)
        header[29] = (UInt8)((byteRate >> 8) & 0xff)
        header[30] = (UInt8)((byteRate >> 16) & 0xff)
        header[31] = (UInt8)((byteRate >> 24) & 0xff)
        // block align
        header[32] = 2 * (16 >> 3)
        header[33] = 0
        // bits per sample
        header[34] = 16
        header[35] = 0
        //data
        header[36] = UInt8(ascii: "d")
        header[37] = UInt8(ascii: "a")
        header[38] = UInt8(ascii: "t")
        header[39] = UInt8(ascii: "a")
        
        let audioCount = data.count
        
        header[40] = UInt8(audioCount & 0xff)
        header[41] = UInt8((audioCount >> 8) & 0xff)
        header[42] = UInt8((audioCount >> 16) & 0xff)
        header[43] = UInt8((audioCount >> 24) & 0xff)

        return Data.init(header) + data
    }
}
