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
    /// 当数组数量不足count时，可以配置填充至足够数量
    func qmapTo(count: Int, elementCreat: ((_ index: Int) -> Element)) -> Array<Element> {
        if self.count >= count {
            return self
        }
        var temp = self
        for i in self.count ... (count - 1) {
            let e = elementCreat(i)
            temp.append(e)
        }
        return temp
    }
    /// 将数组按固定的格子进行重新排序(适应collectioViewFlowLayout，横向滚动)
    /// - Parameters:
    ///   - columns: 多少行
    ///   - rows: 一行有几个
    /// collectioViewFlowLayout 横向滚动时，columns:3,  rows:4 如数据源[0,1,2,3,4,5,6,7,8,9,10,11,12],显示后顺序为
    /// [0, 3 ,6, 9,         12,15](第二页)
    /// [1, 4, 7, 10,        13,]
    /// [2, 5, 8, 11,        14,]
    /// 排序后，数据源变成[0,4,8,1,5,9,2,6,10,3,7,11,12,p,p,13,p,p,14,p,p,15,p,p],即显示后为
    /// [0,1,2, 3,          12,13,14,15](第二页)
    /// [4,5,6,7,             p , p, p, p]
    /// [8,9,10,11,          p, p, p, p]
    ///  为了正确显示最后一页的数据，最后一页不足位以placeholder作为占位，UI可按需处理
    func qreorderDataForGridLayout(columns: Int, rows: Int, placeholder: Element) -> [Element] {
        let data = self
        var result: [Element] = []
        let itemsPerPage = columns * rows
        let totalPages = (data.count + itemsPerPage - 1) / itemsPerPage
        
        for page in 0..<totalPages {
            let pageStartIndex = page * itemsPerPage
            let pageEndIndex = Swift.min(pageStartIndex + itemsPerPage, data.count)
            
            // 获取当前页的数据
            let pageData = Array(data[pageStartIndex..<pageEndIndex])
            
            // 按列优先顺序重新排列当前页
            for row in 0..<rows {
                for column in 0..<columns {
                    let originalIndex = column * rows + row
                    if originalIndex < pageData.count {
                        result.append(pageData[originalIndex])
                    } else {
                        result.append(placeholder)
                    }
                }
            }
        }
        return result
    }
}

/// 【动态规划】 如[1,2,3,4,5,6,7,8,9] 分成3份，每份总数尽量接近 ，最后为[[6,9] [7, 8],[1,2,3,4, 5] ]
public protocol QGroupEqualPartitionProtocol: NSObjectProtocol {
    /// 原数组元素的index索引
    var index: Int { get set }
    /// 用于排序比较值
    func compareValue() -> Int
}

public extension Array where Element: QGroupEqualPartitionProtocol {
    /// 【动态规划】将一个包含m个整数的数组分成n个数组，每个数组的和尽量接近
    /// 内部以compareValue做排序，排完之后，按原index每一行在重排序一次
    /// 参考 https://cloud.tencent.com/developer/article/1659134
    /// bigtosmall： 从大到小排序
    func qgroupEqualPartition(row: Int) -> [[Element]] {
        if self.isEmpty {
            return []
        }
        var result: [[Element]] = []
        /// 总和
        var sum: Int = 0
        var tempList = self
        tempList.enumerated().forEach { model in
            model.element.index = model.offset
            sum += model.element.compareValue()
        }
        /// 求的平均值
        var mean = sum / row
        /// 倒序排列，从小到大计算时，会有很大误差
        tempList = tempList.sorted { a, b in
            return a.compareValue() >= b.compareValue()
        }
        for i in 0 ..< row {
            var arr: [Element] = []
            if i == row - 1 {
                // 最后一组，返回数组剩余所有数
                result.append(tempList)
                break
            }
            // 如果最大的数max>=mean，这个数单独一个组 （因为是从大到小排列，所以第一个最大）
            if let first = tempList.first, first.compareValue() >= mean {
                arr = [first]
                result.append(arr)
                // 总和重新计算剩余的
                sum -= first.compareValue()
                // 重新计算剩下的平均值
                mean = sum / (row - result.count)
            } else {
                // 否则寻找一组数据
                let (temp, _): ([Element], Int) = self.getList(arr: tempList, delta: mean, distance: Int(pow(Double(mean), 2)))
                arr = temp
                result.append(temp)
            }
            // 将已经形成一组的数据从原数组中移除，准备寻找下一组数据
            tempList.removeAll { a in
                return arr.contains(where: { b in
                    return a.index == b.index
                })
            }
        }
        /// 对每一个分好的组，里边的数据按原index排序
        var res: [[Element]] = []
        result.forEach { rows in
            let r = rows.sorted { a, b in
                return a.index < b.index
            }
            res.append(r)
        }
        return res
    }
    private func getList(arr: [Element], delta: Int, distance: Int) -> ([Element], Int) {
        var res: [Element] = []
        if arr.count == 0 {
            return ([], -1)
        }
        var delta = delta
        var distance = distance
        for (i, model) in arr.enumerated() {
            if delta == model.compareValue() {
                res.append(model)
                return (res, 0)
            } else if  delta < model.compareValue() {
                
            } else if  delta > model.compareValue() {
                if i == 0 {
                    res.append(model)
                    delta -= model.compareValue()
                    distance = Int(pow(Double(delta), 2))
                    let ts: [Element] = Array(arr.suffix(from: i + 1))
                    let (temp, d): ([Element], Int) = getList(arr: ts, delta: delta, distance: distance)
                    res.append(contentsOf: temp)
                    return (res, d)
                } else {
                    let dis1 = pow(Double(arr[i - 1].compareValue() - delta), 2)
                    let dis2 = pow(Double(delta - arr[i].compareValue()), 2)
                    if dis1 > dis2 {
                        res.append(model)
                        delta -= model.compareValue()
                        let ts: [Element] = Array(arr.suffix(from: i + 1))
                        let (temp, d): ([Element], Int) = getList(arr: ts, delta: delta, distance: Int(dis2))
                        res.append(contentsOf: temp)
                        return (res, d)
                    } else {
                        let ts: [Element] = Array(arr.suffix(from: i))
                        let (temp, d): ([Element], Int) = getList(arr: ts, delta: delta, distance: Int(dis2))
                        if Int(dis1) > d {
                            res.append(contentsOf: temp)
                            return (res, d)
                        }
                        res.append(arr[i - 1])
                        return (res, Int(dis1))
                    }
                }
            }
        }
        let dis = pow(Double(delta - arr[arr.count - 1].compareValue()), 2)
        if Int(dis) < distance {
            return (Array(arr.suffix(from: arr.count - 1)), Int(dis))
        }
        return ([], -1)
    }
}
