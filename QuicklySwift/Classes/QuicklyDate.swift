//
//  QuicklyDate.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/17.
//

import UIKit

public extension Date {
    /// date是否是今天
    var qisToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    /// date 是否是昨天
    var qisYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    /// date是否是明天
    var qisTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    /// 是否是本周内
    var qisInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    /// 是否是今年内
    var qisInThisYear: Bool {
        let year = Calendar.current.dateComponents([.year], from: self)
        let nowYear = Calendar.current.dateComponents([.year], from: Date())
        return nowYear.year == year.year
    }
    /// 是否是本月内
    var qisInThisMonth: Bool {
        let year = Calendar.current.dateComponents([.year, .month], from: self)
        let nowYear = Calendar.current.dateComponents([.year, .month], from: Date())
        return year.year == nowYear.year && year.month == nowYear.month
    }
}

public extension Date {
    /// 转换成字符串，在iOS 15.4之后，如果不设置locale，12小时制时，会有中文
    func qtoString(_ format: String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        formatter.locale = .init(identifier: "en_US")
        return formatter.string(from: self)
    }
    /// 常规显示
    /// 1分钟内显示刚刚，1小时内显示多少分钟前，今天内显示多少小时前 ，今年内显示 月-日 时:分  其他的显示全部
    var qnoraml: String {
        if self.qisToday {
            let inter = abs(self.timeIntervalSinceNow)
            if inter < 60 {
                return "刚刚"
            } else if inter < 3600 {
                return "\(Int(inter / 60))分钟前"
            } else {
                return "\(Int(inter / 3600))小时前"
            }
        }
        if self.qisInThisYear {
            return self.qtoString("MM-dd HH:mm")
        }
        return self.qtoString("yyyy-MM-dd HH:mm")
    }
}
