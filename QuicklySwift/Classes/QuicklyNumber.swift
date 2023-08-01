//
//  QuicklyNumber.swift
//  QuicklySwift
//
//  Created by rztime on 2022/12/21.
//

import UIKit

public enum QDecimalPlace {
    /// 保留几位小数， 小于0，不做处理
    case place(_ count: Int)
    /// 保留几小数时，不足位填充0 (如保留两位，1.00)
    case decimal0
    /// 4舍五入
    case up5down4
    /// 向上取整  (x> 3 && x <=4） x = 4
    case ceil
    /// 向下取整（x>= 3 && x <4） x = 3
    case floor
}
open class QNumberDecimalOption {
    /// 保留几位小数
    open var placeCount: Int = -1
    /// 保留几小数时，不足位填充0 (如保留两位，1.00)
    open var decimal0 = false
    /// 4舍五入
    open var up5down4 = false
    /// 向上取整  (x> 3 && x <=4） x = 4
    open var ceil = false
    /// 向下取整（x>= 3 && x <4） x = 3
    open var floor = false
    /// 空数组时，不对数据做处理
    public init(configure: [QDecimalPlace]) {
        configure.forEach { dp in
            switch dp {
            case .place(let count):
                self.placeCount = count
            case .up5down4:
                self.up5down4 = true
            case .ceil:
                self.ceil = true
            case .floor:
                self.floor = true
            case .decimal0:
                self.decimal0 = true
            }
        }
    }
}

public protocol QuicklyNumberProtoal {}
public extension QuicklyNumberProtoal where Self: Any {
    /// 转换为String， 按照配置对数据进行处理，
    /// option=nil 时，不做任何处理
    func qtoString(_ option: QNumberDecimalOption? = nil) -> String {
        guard let option = option else {
            return "\(self)"
        }
        let number = NSDecimalNumber.init(string: "\(self)")
        if option.ceil {
            return "\(Int(ceil(number.doubleValue)))"
        }
        if option.floor {
            return "\(Int(floor(number.doubleValue)))"
        }
        if option.placeCount >= 0 {
            var mode = NSDecimalNumber.RoundingMode.up
            if option.up5down4 { // 4舍5入
                mode = .plain
            }
            let hand = NSDecimalNumberHandler.init(roundingMode: mode, scale: Int16(option.placeCount), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let dec = NSDecimalNumber(decimal: pow(1, 1))
            let res = number.multiplying(by: dec, withBehavior: hand)
            if !option.decimal0 {
                return "\(res)"
            }
            var formatter: String = option.placeCount > 0 ? "0." : ""
            for _ in 0 ..< option.placeCount {
                formatter.append("0")
            }
            let format: NumberFormatter = .init()
            format.positiveFormat = formatter
            let result = format.string(from: res) ?? ""
            return "\(result)"
        }
        return "\(self)"
    }
    /// 如果是时间，将其转换为时分秒, number单位为秒，输出01:44:11
    var qtohms: String {
        let number = NSDecimalNumber.init(string: "\(self)")
        let value = number.intValue
        let hours = value / 3600
        let min = (value % 3600) / 60
        let s = value % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, min, s)
        }
        return String(format: "%02d:%02d", min, s)
    }
}

extension NSNumber: QuicklyNumberProtoal {}
extension CChar: QuicklyNumberProtoal {}
extension UInt8: QuicklyNumberProtoal {}
extension Int16: QuicklyNumberProtoal {}
extension UInt16: QuicklyNumberProtoal {}
extension Int32: QuicklyNumberProtoal {}
extension UInt32: QuicklyNumberProtoal {}
extension Int64: QuicklyNumberProtoal {}
extension UInt64: QuicklyNumberProtoal {}
extension Float: QuicklyNumberProtoal {}
extension Double: QuicklyNumberProtoal {}
extension Int: QuicklyNumberProtoal {}
extension UInt: QuicklyNumberProtoal {}
extension CGFloat: QuicklyNumberProtoal {}
