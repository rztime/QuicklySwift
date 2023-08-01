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

