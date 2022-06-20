//
//  QuicklyArray.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/8.
//

import UIKit

public extension Array where Element: UIView {
    /// 将views组装成一个stackView
    func qjoined(aixs: NSLayoutConstraint.Axis, spacing: CGFloat, align: UIStackView.Alignment, distribution: UIStackView.Distribution) -> QStackView {
        return UIView.qjoined(self, aixs: aixs, spacing: spacing, align: align, distribution: distribution)
    }
}
public extension Array {
    ///  object at index
    ///  大于0，return index，否则取count+index 如（-2）倒数第二个
    subscript(qsafe index: Index) -> Element? {
        get {
            let t = index >= 0 ? index : count + index
            return (t < count && t >= 0) ? self[t] : nil
        }
        set {
            guard let v = newValue else {
                return
            }
            let t = index >= 0 ? index : count + index
            guard 0 <= t && t < count else {
                return
            }
            self[t] = v
        }
    }
    
    /// 数组分组切片 [1,2,3,4,5,6,7] step = 3  return [[1,2,3], [4,5,6], [7]]
    /// - Parameter step: 切片数量
    /// - Returns: [1,2,3,4,5,6,7] step = 3  return [[1,2,3], [4,5,6], [7]]
    func qgroup(step: Index) -> Array<Array<Element>> {
        var result: [Array<Element>] = []
        let temp = self
        
        let indexs = stride(from: 0, to: temp.endIndex - temp.endIndex % step, by: step).map({$0})
        indexs.forEach { index in
            let array = Array(temp[index..<(index + step)])
            result.append(array)
            if index == temp.endIndex - temp.endIndex % step - step, temp.count > index + step {
                let star = index + step
                result.append(Array(temp[(star)..<(temp.count)]))
            }
        }
        if indexs.count == 0, temp.count > 0 {
            result.append(temp)
        }
        return result
    }
}
