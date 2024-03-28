//
//  QuicklyAuthorization.swift
//  QuicklySwift
//
//  Created by rztime on 2022/7/22.
//

import UIKit
import AVFoundation
import Photos
import CoreTelephony
#if Q_NSLocationWhenInUseUsageDescription || Q_NSLocationAlwaysUsageDescription || Q_NSLocationAlwaysAndWhenInUseUsageDescription
import CoreLocation
#endif
#if Q_NSContactsUsageDescription
import Contacts
#endif

#if Q_NSCalendarsUsageDescription
import EventKit
#endif

#if Q_NSAppleMusicUsageDescription
import MediaPlayer
#endif

#if Q_NSSpeechRecognitionUsageDescription
import Speech
#endif

#if Q_NSSiriUsageDescription
import Intents
#endif

#if Q_NSMotionUsageDescription
import CoreMotion
#endif

#if Q_NSUserTrackingUsageDescription
import AdSupport
import AppTrackingTransparency
#endif
/// 权限类型
public enum QAuthorizationType: String {
    /// 相机
    case camera = "NSCameraUsageDescription"
    /// 相册 有可能有限制
    case photoLibrary = "NSPhotoLibraryUsageDescription"
    /// 麦克风
    case microphone = "NSMicrophoneUsageDescription"
    /// 通知权限  有可能有限制
    case notification = "notconfig_notification"
    /// 通讯录
    case contact = "NSContactsUsageDescription"
    /// 定位权限 用户使用过程中
    case locationWhenInUse = "NSLocationWhenInUseUsageDescription"
    /// 定位权限 always
    case locationAlways = "NSLocationAlwaysUsageDescription"
    /// 日历权限
    case events = "NSCalendarsUsageDescription"
    /// 提醒事项
    case reminder = "NSRemindersUsageDescription"
    /// apple Music
    case appleMusic = "NSAppleMusicUsageDescription"
    /// 语言识别
    case speech = "NSSpeechRecognitionUsageDescription"
    /// siri权限
    case siri = "NSSiriUsageDescription"
    /// 活动与体能训练记录
    case motion = "NSMotionUsageDescription"
    /// 广告追踪权限
    case idfa = "NSUserTrackingUsageDescription"
}
// MARK: - 权限获取结果
public struct QAuthorizationResult {
    /// 是否授权通过
    public var granted: Bool = false
    /// 是否有限制
    public var limit: Bool = false
    /// 状态，具体内容看各个的权限结果
    public var status: Any
    /// 提示信息，比如相机无法使用
    public var message: String?
    
    public init(granted: Bool, limit: Bool, status: Any, message: String? = nil) {
        self.granted = granted
        self.limit = limit
        self.status = status
        self.message = message
    }
}
// MARK: - iOS 权限 判断 方法入口
public struct QuicklyAuthorization {
    ///内部使用单例，用于单独获取某一个权限时的方法
    static var shared = QuicklyAuthorizationHelper.init()
    
    /// 判断是否拥有权限
    public static func result(with authorizationType: QAuthorizationType, handle: ((_ result: QAuthorizationResult) -> Void)?) {
#if DEBUG
        let key = authorizationType.rawValue
        if !key.hasPrefix("notconfig") {
            let hasKey: Bool = !Bundle.main.object(forInfoDictionaryKey: authorizationType.rawValue).qisEmpty
            assert(hasKey, "\n\n\n需要在 info.plist 里添加:\(authorizationType.rawValue)")
        }
#endif
        let res: ((_ result: QAuthorizationResult) -> Void)? = { res in
            if Thread.isMainThread {
                handle?(res)
            } else {
                DispatchQueue.main.async {
                    handle?(res)
                }
            }
        }
        switch authorizationType {
        case .camera:
            self.shared.requestCamera(result: res)
        case .photoLibrary:
            self.shared.requestPhotoLibrary(result: res)
        case .microphone:
            self.shared.requestMicrophone(result: res)
        case .notification:
            self.shared.requestNotification(result: res)
        case .contact:
            self.shared.requestContact(result: res)
        case .locationWhenInUse:
#if Q_NSLocationWhenInUseUsageDescription || Q_NSLocationAlwaysUsageDescription || Q_NSLocationAlwaysAndWhenInUseUsageDescription
            self.shared.requestLocation(type: .authorizedWhenInUse, result: res)
#endif
            break
        case .locationAlways:
#if Q_NSLocationWhenInUseUsageDescription || Q_NSLocationAlwaysUsageDescription || Q_NSLocationAlwaysAndWhenInUseUsageDescription
            self.shared.requestLocation(type: .authorizedAlways, result: res)
#endif
            break
        case .events:
            self.shared.requestEvents(type: .events, result: res)
        case .reminder:
            self.shared.requestEvents(type: .reminder, result: res)
        case .appleMusic:
            self.shared.requestAppleMusic(result: res)
        case .speech:
            self.shared.requestSpeech(result: res)
        case .siri:
            self.shared.requestSiri(result: res)
        case .motion:
            self.shared.requestMotion(result: res)
        case .idfa:
            self.shared.requestIdfa(result: res)
        }
    }
}
/// 权限获取
class QuicklyAuthorizationHelper {
#if Q_NSLocationWhenInUseUsageDescription || Q_NSLocationAlwaysUsageDescription || Q_NSLocationAlwaysAndWhenInUseUsageDescription
    /// 定位
    var locationWhenInUse: QLocationAuthorization?
    /// 长定位
    var locationAlways: QLocationAuthorization?
#endif
    
    private var _montion: Any? = nil
#if Q_NSMotionUsageDescription
    /// 活动与体能训练记录
    @available(iOS 11.0, *)
    var motion: QMotionAuthorization? {
        get {
            return _montion as? QMotionAuthorization
        }
        set {
            _montion = newValue
        }
    }
#endif
    /// 相机
    func requestCamera(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSCameraUsageDescription
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                self?.requestCamera(result: result)
            }
        case .restricted, .denied:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let isable = UIImagePickerController.isSourceTypeAvailable(.camera)
            if isable {
                let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
                result?(res)
            } else {
                let res = QAuthorizationResult.init(granted: true, limit: true, status: status, message: "相机无法使用")
                result?(res)
            }
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
    /// 相册
    func requestPhotoLibrary(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSPhotoLibraryUsageDescription
        let status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        switch status {
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                    self?.requestPhotoLibrary(result: result)
                }
            } else {
                PHPhotoLibrary.requestAuthorization { [weak self] status in
                    self?.requestPhotoLibrary(result: result)
                }
            }
        case .restricted, .denied:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        case .limited:
            let res = QAuthorizationResult.init(granted: true, limit: true, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
    /// 麦克风
    func requestMicrophone(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSMicrophoneUsageDescription
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
                self?.requestMicrophone(result: result)
            }
        case .restricted, .denied:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
    /// 通知权限
    func requestNotification(result: ((_ result: QAuthorizationResult) -> Void)?) {
        func handle(status: UNAuthorizationStatus) {
            switch status {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization { [weak self] _, _ in
                    self?.requestNotification(result: result)
                }
            case .denied:
                let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
                result?(res)
            case .authorized:
                let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
                result?(res)
            case .provisional, .ephemeral:
                let res = QAuthorizationResult.init(granted: true, limit: true, status: status)
                result?(res)
            @unknown default:
                let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
                result?(res)
            }
        }
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status = settings.authorizationStatus
            handle(status: status)
        }
    }
    /// 通讯录
    func requestContact(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSContactsUsageDescription
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { [weak self] _, _ in
                self?.requestContact(result: result)
            }
        case .restricted, .denied:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
#if Q_NSLocationWhenInUseUsageDescription || Q_NSLocationAlwaysUsageDescription || Q_NSLocationAlwaysAndWhenInUseUsageDescription
    /// app使用中的 定位权限
    func requestLocation(type: CLAuthorizationStatus, result: ((_ result: QAuthorizationResult) -> Void)?) {
        guard CLLocationManager.locationServicesEnabled() else {
            let res = QAuthorizationResult.init(granted: false, limit: false, status: 0, message: "未开启GPS服务")
            result?(res)
            return
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            if type == .authorizedWhenInUse {
                self.locationWhenInUse = .init(type: type)
                self.locationWhenInUse?.requestAuthorization(status: { [weak self] status in
                    self?.locationWhenInUse = nil
                    self?.requestLocation(type: type, result: result)
                })
            } else {
                self.locationAlways = .init(type: type)
                self.locationAlways?.requestAuthorization(status: { [weak self] status in
                    self?.locationAlways = nil
                    self?.requestLocation(type: type, result: result)
                })
            }
        case .restricted, .denied:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorizedAlways:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        case .authorizedWhenInUse:
            let res = QAuthorizationResult.init(granted: type == .authorizedWhenInUse, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
    }
#endif
    /// 日历
    func requestEvents(type: QAuthorizationType, result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSCalendarsUsageDescription
        let t : EKEntityType
        switch type {
        case .events:
            t = .event
        case .reminder:
            t = .reminder
        default:
            t = .event
        }
        let status = EKEventStore.authorizationStatus(for: t)
        switch status {
        case .notDetermined:
            EKEventStore().requestAccess(to: t) { [weak self] _, _ in
                self?.requestEvents(type: type, result: result)
            }
        case .restricted, .denied:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        case .fullAccess:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        case .writeOnly:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
    /// apple music
    func requestAppleMusic(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSAppleMusicUsageDescription
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { status in
                let r = status == .authorized
                let res = QAuthorizationResult.init(granted: r, limit: false, status: status)
                result?(res)
            }
        case .denied, .restricted:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
    /// 语言识别权限
    func requestSpeech(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSSpeechRecognitionUsageDescription
        let status = SFSpeechRecognizer.authorizationStatus()
        switch status {
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { status in
                let r = status == .authorized
                let res = QAuthorizationResult.init(granted: r, limit: false, status: status)
                result?(res)
            }
        case .denied, .restricted:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
    /// siri权限
    func requestSiri(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSSiriUsageDescription
        let status = INPreferences.siriAuthorizationStatus()
        switch status {
        case .notDetermined:
            INPreferences.requestSiriAuthorization { status in
                let r = status == .authorized
                let res = QAuthorizationResult.init(granted: r, limit: false, status: status)
                result?(res)
            }
        case .denied, .restricted:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
    /// 活动与体能训练记录
    func requestMotion(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSMotionUsageDescription
        guard CMMotionActivityManager.isActivityAvailable(), #available(iOS 11.0, *) else {
            let res = QAuthorizationResult.init(granted: false, limit: false, status: 0, message: "活动与体能训练记录不支持")
            result?(res)
            return
        }
        let status = CMMotionActivityManager.authorizationStatus()
        switch status {
        case .notDetermined:
            motion = .init()
            motion?.requestAuthorization(status: {[weak self] status in
                self?.motion = nil
                self?.requestMotion(result: result)
            })
        case .denied, .restricted:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        case .authorized:
            let res = QAuthorizationResult.init(granted: true, limit: false, status: status)
            result?(res)
        @unknown default:
            let res = QAuthorizationResult.init(granted: false, limit: false, status: status)
            result?(res)
        }
#endif
    }
    /// IDFA广告权限
    func requestIdfa(result: ((_ result: QAuthorizationResult) -> Void)?) {
#if Q_NSUserTrackingUsageDescription
        var uuid = "00000000-0000-0000-0000-000000000000"
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
            case .notDetermined:
                ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                    if status == .notDetermined {
                        let res = QAuthorizationResult.init(granted: false, limit: false, status: status, message: uuid)
                        result?(res)
                        return
                    }
                    self?.requestIdfa(result: result)
                }
            case .restricted, .denied:
                let res = QAuthorizationResult.init(granted: false, limit: false, status: status, message: uuid)
                result?(res)
            case .authorized:
                uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                let res = QAuthorizationResult.init(granted: true, limit: false, status: status, message: uuid)
                result?(res)
            @unknown default:
                let res = QAuthorizationResult.init(granted: false, limit: false, status: status, message: uuid)
                result?(res)
            }
        } else {
            let enable = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            if enable {
                uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
            let res = QAuthorizationResult.init(granted: enable, limit: false, status: "", message: uuid)
            result?(res)
        }
#endif
    }
}

#if Q_NSLocationWhenInUseUsageDescription || Q_NSLocationAlwaysUsageDescription || Q_NSLocationAlwaysAndWhenInUseUsageDescription
// MARK: - 定位权限辅助
class QLocationAuthorization: NSObject, CLLocationManagerDelegate {
    var complete: ((_ status: CLAuthorizationStatus) -> Void)?
    
    lazy var location : CLLocationManager = {
        let l = CLLocationManager()
        l.delegate = self
        return l
    }()
    var type : CLAuthorizationStatus
    init(type: CLAuthorizationStatus) {
        self.type = type
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        self.complete?(status)
    }
    
    func requestAuthorization(status: ((_ status: CLAuthorizationStatus) -> Void)?) {
        self.complete = status
        switch type {
        case .notDetermined, .restricted, .denied:
            break
        case .authorizedAlways:
            self.location.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            self.location.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}
#endif

#if Q_NSMotionUsageDescription
// MARK: - 活动与体能训练记录
/// 活动与体能训练记录
@available(iOS 11.0, *)
class QMotionAuthorization {
    var complete: ((_ status: CMAuthorizationStatus) -> Void)?
    
    lazy var motionManager: CMMotionActivityManager = {
        return CMMotionActivityManager()
    }()
    func requestAuthorization(status: ((_ status: CMAuthorizationStatus) -> Void)?) {
        let now = Date()
        self.complete = status
        motionManager.queryActivityStarting(from: now, to: now, to: .main) { [weak self] _, error in
            self?.motionManager.stopActivityUpdates()
            var status: CMAuthorizationStatus
            if error != nil {
                status = .denied
            } else {
                status = .authorized
            }
            self?.complete?(status)
        }
    }
}
#endif
