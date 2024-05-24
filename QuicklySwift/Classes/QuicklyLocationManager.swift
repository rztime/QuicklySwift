//
//  QuicklyLocationManager.swift
//  QuicklySwift
//
//  Created by rztime on 2024/3/28.
//

#if Q_NSLocationWhenInUseUsageDescription || Q_NSLocationAlwaysUsageDescription || Q_NSLocationAlwaysAndWhenInUseUsageDescription
import UIKit
import CoreLocation

private var qlocationhelper: UInt8 = 1
public extension CLPlacemark {
    /// 建议地址
    var qsuggestionAddressString: String {
        var loc = ""
        if let name = self.areasOfInterest?.first {
            loc = name
        } else if let name = self.name {
            loc = name
        } else if let name = self.thoroughfare {
            loc = name
        }
//        else {
//            loc = "\(self.locality ?? "")\(self.subLocality ?? "")\(self.thoroughfare ?? "")"
//        }
        return loc
    }
}
public extension CLLocation {
    /// 将坐标反地址编码，得到地址信息
    func qreverseGeocodeLocation(_ placemark: ((_ placemarks: [CLPlacemark]?, _ error: Error?) -> Void)?) {
        var p: ((_ placemarks: [CLPlacemark]?, _ error: Error?) -> Void)? = placemark
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(self) { places, error in
            p?(places, error)
            p = nil
        }
    }
}
// MARK: - delegate 相关回调
public extension CLLocationManager {
    @discardableResult
    /// 位置更新
    func qdidUpdateLocations(_ locations: ((_ manager: CLLocationManager, _ locations: [CLLocation]) -> Void)?) -> Self {
        self.qhelper.didUpdateLocations = locations
        return self
    }
    @discardableResult
    /// heading更新
    func qdidUpdateHeading(_ heading: ((_ manager: CLLocationManager, _ newHeading: CLHeading) -> Void)?) -> Self {
        self.qhelper.didUpdateHeading = heading
        return self
    }
    @discardableResult
    /// 位置错误
    func qdidFailWithError(_ error: ((_ manager: CLLocationManager, _ error: Error) -> Void)?) -> Self {
        self.qhelper.didFailWithError = error
        return self
    }
    @discardableResult
    /// 权限改变
    func qlocationDidChangeAuthorization(_ change: ((_ manager: CLLocationManager) -> Void)?) -> Self {
        self.qhelper.locationDidChangeAuthorization = change
        return self
    }
    @discardableResult
    /// 定位暂停
    func qlocationDidPauseLocationUpdates(_ pause: ((_ manager: CLLocationManager) -> Void)?) -> Self {
        self.qhelper.locationDidPauseLocationUpdates = pause
        return self
    }
    @discardableResult
    /// 定位继续
    func qlocationDidResumeLocationUpdates(_ resume: ((_ manager: CLLocationManager) -> Void)?) -> Self {
        self.qhelper.locationDidResumeLocationUpdates = resume
        return self
    }
    @discardableResult
    func qdidvisit(_ visit: ((_ manager: CLLocationManager, _ visit: CLVisit) -> Void)?) -> Self {
        self.qhelper.didvisit = visit
        return self
    }
    @discardableResult
    func qdidExitRegion(_ region: ((_ manager: CLLocationManager, _ region: CLRegion) -> Void)?) -> Self {
        self.qhelper.didExitRegion = region
        return self
    }
    @discardableResult
    func qdidEnterRegion(_ region: ((_ manager: CLLocationManager, _ region: CLRegion) -> Void)?) -> Self {
        self.qhelper.didEnterRegion = region
        return self
    }
    @discardableResult
    @available(iOS 13.0, *)
    func qdidRangeBeaconsSatisfying(_ beacons: ((_ manager: CLLocationManager, _ beacons: [CLBeacon], _ beaconConstraint: CLBeaconIdentityConstraint) -> Void)?) -> Self {
        self.qhelper.didRangeBeaconsSatisfying = { manager, be, c in
            beacons?(manager, be, c as! CLBeaconIdentityConstraint)
        }
        return self
    }
    @discardableResult
    func qdidStartMonitoringFor(_ region: ((_ manager: CLLocationManager, _ region: CLRegion) -> Void)?) -> Self {
        self.qhelper.didStartMonitoringFor = region
        return self
    }
    @discardableResult
    func qdidDetermineStateFor(_ state: ((_ manager: CLLocationManager, _ state: CLRegionState, _ forRegion: CLRegion) -> Void)?) -> Self {
        self.qhelper.didDetermineStateFor = state
        return self
    }
    @discardableResult
    @available(iOS 13.0, *)
    func qdidFailRangingFor(_ beacon: ((_ manager: CLLocationManager, _ beaconConstraint: CLBeaconIdentityConstraint, _ error: Error) -> Void)?) -> Self {
        self.qhelper.didFailRangingFor = { m, b, e in
            beacon?(m, b as! CLBeaconIdentityConstraint, e)
        }
        return self
    }
    @discardableResult
    func qmonitoringDidFailFor(_ regin: ((_ manager: CLLocationManager, _ region: CLRegion?, _ error: Error) -> Void)?) -> Self {
        self.qhelper.monitoringDidFailFor = regin
        return self
    }
    @discardableResult
    func qdidFinishDeferredUpdatesWithError(_ error: ((_ manager: CLLocationManager, _ error: Error?) -> Void)?) -> Self {
        self.qhelper.didFinishDeferredUpdatesWithError = error
        return self
    }
    @discardableResult
    func qlocationShouldDisplayHeadingCalibration(_ display: ((_ manager: CLLocationManager) -> Bool)?) -> Self {
        self.qhelper.locationShouldDisplayHeadingCalibration = display
        return self
    }
    var qhelper: QLocationManagerDelegateHelper {
        set {
            objc_setAssociatedObject(self, &qlocationhelper, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let h = objc_getAssociatedObject(self, &qlocationhelper) as? QLocationManagerDelegateHelper {
                return h
            }
            let helper = QLocationManagerDelegateHelper.init(target: self)
            self.qhelper = helper
            return helper
        }
    }
}
// MARK: - 属性 方法
public extension CLLocationManager {
    @discardableResult
    func qactivityType(_ type: CLActivityType) -> Self {
        self.activityType = type
        return self
    }
    @discardableResult
    func qdistanceFilter(_ distanceFilter: CLLocationDistance) -> Self {
        self.distanceFilter = distanceFilter
        return self
    }
    @discardableResult
    func qdesiredAccuracy(_ desiredAccuracy: CLLocationAccuracy) -> Self {
        self.desiredAccuracy = desiredAccuracy
        return self
    }
    @discardableResult
    func qpausesLocationUpdatesAutomatically(_ pau: Bool) -> Self {
        self.pausesLocationUpdatesAutomatically = pau
        return self
    }
    @discardableResult
    func qallowsBackgroundLocationUpdates(_ allow: Bool) -> Self {
        self.allowsBackgroundLocationUpdates = allow
        return self
    }
    @discardableResult
    func qshowsBackgroundLocationIndicator(_ show: Bool) -> Self {
        if #available(iOS 11.0, *) {
            self.showsBackgroundLocationIndicator = show
        }
        return self
    }
    @discardableResult
    func qheadingFilter(_ filter: CLLocationDegrees) -> Self {
        self.headingFilter = filter
        return self
    }
    @discardableResult
    func qheadingOrientation(_ ori: CLDeviceOrientation) -> Self {
        self.headingOrientation = ori
        return self
    }
    @discardableResult
    func qrequestWhenInUseAuthorization() -> Self {
        self.requestWhenInUseAuthorization()
        return self
    }
    @discardableResult
    func qrequestAlwaysAuthorization() -> Self {
        self.requestAlwaysAuthorization()
        return self
    }
    @discardableResult
    func qrequestTemporaryFullAccuracyAuthorizationWithPurposeKey(_ key: String, complete: ((_ error: Error?) -> Void)?) -> Self {
        if #available(iOS 14.0, *) {
            self.requestTemporaryFullAccuracyAuthorization(withPurposeKey: key, completion: complete)
        }
        return self
    }
    @discardableResult
    func qrequestTemporaryFullAccuracyAuthorizationWithPurposeKey(_ key: String) -> Self {
        if #available(iOS 14.0, *) {
            self.requestTemporaryFullAccuracyAuthorization(withPurposeKey: key)
        }
        return self
    }
    @discardableResult
    func qstartUpdatingLocation() -> Self {
        self.startUpdatingLocation()
        return self
    }
    @discardableResult
    func qstopUpdatingLocation() -> Self {
        self.stopUpdatingLocation()
        return self
    }
    @discardableResult
    func qrequestLocation() -> Self {
        self.requestLocation()
        return self
    }
    @discardableResult
    func qstartUpdatingHeading() -> Self {
        self.startUpdatingHeading()
        return self
    }
    @discardableResult
    func qstopUpdatingHeading() -> Self {
        self.stopUpdatingHeading()
        return self
    }
    @discardableResult
    func qdismissHeadingCalibrationDisplay() -> Self {
        self.dismissHeadingCalibrationDisplay()
        return self
    }
    @discardableResult
    func qstartMonitoringSignificantLocationChanges() -> Self {
        self.startMonitoringSignificantLocationChanges()
        return self
    }
    @discardableResult
    func qstopMonitoringSignificantLocationChanges() -> Self {
        self.stopMonitoringSignificantLocationChanges()
        return self
    }
    @discardableResult
    func qstartMonitoringLocationPushesWithCompletion(_ complete: ((Data?, Error?) -> Void)?) -> Self {
        if #available(iOS 15.0, *) {
            self.startMonitoringLocationPushes(completion: complete)
        }
        return self
    }
    @discardableResult
    func qstopMonitoringLocationPushes() -> Self {
        if #available(iOS 15.0, *) {
            self.stopMonitoringLocationPushes()
        }
        return self
    }
}

open class QLocationManagerDelegateHelper: NSObject, CLLocationManagerDelegate {
    open var didvisit: ((_ manager: CLLocationManager, _ visit: CLVisit) -> Void)?
    open var didExitRegion: ((_ manager: CLLocationManager, _ region: CLRegion) -> Void)?
    open var didEnterRegion: ((_ manager: CLLocationManager, _ region: CLRegion) -> Void)?
    open var didUpdateHeading: ((_ manager: CLLocationManager, _ newHeading: CLHeading) -> Void)?
    open var didFailWithError: ((_ manager: CLLocationManager, _ error: Error) -> Void)?
    open var didUpdateLocations: ((_ manager: CLLocationManager, _ locations: [CLLocation]) -> Void)?
    open var didRangeBeaconsSatisfying: ((_ manager: CLLocationManager, _ beacons: [CLBeacon], _ beaconConstraint: Any) -> Void)?
    open var didStartMonitoringFor: ((_ manager: CLLocationManager, _ region: CLRegion) -> Void)?
    open var didDetermineStateFor: ((_ manager: CLLocationManager, _ state: CLRegionState, _ forRegion: CLRegion) -> Void)?
    open var didFailRangingFor: ((_ manager: CLLocationManager, _ beaconConstraint: Any, _ error: Error) -> Void)?
    open var monitoringDidFailFor: ((_ manager: CLLocationManager, _ region: CLRegion?, _ error: Error) -> Void)?
    open var didFinishDeferredUpdatesWithError: ((_ manager: CLLocationManager, _ error: Error?) -> Void)?
    open var locationDidChangeAuthorization: ((_ manager: CLLocationManager) -> Void)?
    open var locationDidPauseLocationUpdates: ((_ manager: CLLocationManager) -> Void)?
    open var locationDidResumeLocationUpdates: ((_ manager: CLLocationManager) -> Void)?
    open var locationShouldDisplayHeadingCalibration: ((_ manager: CLLocationManager) -> Bool)?
    
    open weak var location: CLLocationManager?
    public init(target: CLLocationManager) {
        super.init()
        self.location = target
        target.delegate = self
    }
    public func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        self.didvisit?(manager, visit)
    }
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.didExitRegion?(manager, region)
    }
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.didEnterRegion?(manager, region)
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.didUpdateHeading?(manager, newHeading)
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.didFailWithError?(manager, error)
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.didUpdateLocations?(manager, locations)
    }
    @available(iOS 13.0, *)
    public func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        self.didRangeBeaconsSatisfying?(manager, beacons, beaconConstraint)
    }
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        self.didStartMonitoringFor?(manager, region)
    }
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        self.didDetermineStateFor?(manager, state, region)
    }
    @available(iOS 13.0, *)
    public func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        self.didFailRangingFor?(manager, beaconConstraint, error)
    }
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        self.monitoringDidFailFor?(manager, region, error)
    }
    public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        self.didFinishDeferredUpdatesWithError?(manager, error)
    }
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationDidChangeAuthorization?(manager)
    }
    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        self.locationDidPauseLocationUpdates?(manager)
    }
    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        self.locationDidResumeLocationUpdates?(manager)
    }
    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        if let c = self.locationShouldDisplayHeadingCalibration {
            return c(manager)
        }
        return false
    }
}
#endif
