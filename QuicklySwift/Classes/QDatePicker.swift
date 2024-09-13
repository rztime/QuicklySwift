//
//  QDatePicker.swift
//  QuicklySwift
//
//  Created by rztime on 2024/9/5.
//

import UIKit
open class QDataPickerOptions {
    public enum PickerConfige {
        case style1 //  style1:  yyyy/MM/dd
        case style2 //  style2:  HH:mm:ss
        case style3 //  style3 : yyyy/MM/dd HH:mm:ss
        case custm(_ types: [PickerType])
        case min(_ year: Int)
        case max(_ year: Int)
        case defaultDate(_ date: Date)
        case tintColor(_ color: UIColor)
        case title(_ text: String?)
        case star(_ text: String?)
        case end(_ text: String?)
    }
    
    public enum PickerType: Equatable {
        case separator(_ text: String)
        case year
        case month
        case day
        case hour
        case min
        case second
        
        var isseparator: Bool {
            if case .separator = self {
                return true
            }
            return false
        }
        var formatter_ymd: String? {
            switch self {
            case .separator, .hour, .min, .second:
                return nil
            case .year:
                return "yyyy"
            case .month:
                return "MM"
            case .day:
                return "dd"
            }
        }
        var formatter_hms: String? {
            switch self {
            case .separator, .year, .month, .day:
                return nil
            case .hour:
                return "HH"
            case .min:
                return "mm"
            case .second:
                return "ss"
            }
        }
    }
    open var type: [PickerType] = []
    open var minYear: Int = 2000
    open var maxYear: Int = 2030
    open var date: Date = Date()
    open var tintColor: UIColor = .qhex("#2B7BED")
    open var title: String? = "选择"
    open var star: String? = "开始"
    open var end: String? = "结束"
    public init(options: [PickerConfige]) {
        options.forEach { c in
            switch c {
            ///  style1:  yyyy/mm/dd
            case .style1:
                self.type = [.year, .separator("/"), .month, .separator("/"), .day]
            ///  style2:  hh:mm:ss
            case .style2:
                self.type = [.hour, .separator("："), .min, .separator("："), .second]
            ///  style3 : yyyy/mm/dd hh:mm:ss
            case .style3:
                self.type = [.year, .separator("/"), .month, .separator("/"), .day, .hour, .separator("："), .min, .separator("："), .second]
            case .custm(let types):
                self.type = types
            case .min(let year):
                self.minYear = year
            case .max(let year):
                self.maxYear = year
            case .defaultDate(let date):
                self.date = date
            case .tintColor(let color):
                self.tintColor = color
            case .title(let text):
                self.title = text
            case .star(let text):
                self.star = text
            case .end(let text):
                self.end = text
            }
        }
    }
    open class func _default() -> [PickerConfige] {
        return [.style2, .min(2000), .max(2030), .defaultDate(Date()), .tintColor(.qhex("#2B7BED")), .title("选择"), .star("开始"), .end("结束")]
    }
}
/// 通过vc，可以修改部分view的样式和文字、颜色等等
open class QDatePicker: UIViewController {
    public enum Style {
        /// 一个时间
        case style1
        /// 两个时间
        case style2
    }
    /// 通过vc，可以修改部分view的样式
    /// finish 数组为空时，表示取消，两个数组代表起、止时间
    @discardableResult
    open class func show(style: QDatePicker.Style, options: QDataPickerOptions? = nil, finish: (([Date]?) -> Void)?) -> QDatePicker {
        let vc = QDatePicker.init()
        vc.options = options ?? .init(options: QDataPickerOptions._default())
        vc.style = style
        vc.finish = finish
        vc.modalPresentationStyle = .overCurrentContext
        qAppFrame.present(vc, animated: true, completion: nil)
        return vc
    }
    open var finish: (([Date]?) -> Void)?
    open var style: QDatePicker.Style = .style1
    open var options = QDataPickerOptions.init(options: QDataPickerOptions._default())
    /// 标题
    open lazy var titleLabel = UILabel().qfont(.systemFont(ofSize: 15)).qtextAliginment(.center).qtext(self.options.title)
        .qisHidden(self.options.title.qisEmpty)
        .qadjustsFontSizeToFitWidth(true)
    public let contentView = UIView().qcornerRadiusCustom([.topLeft, .topRight], radii: 10).qbackgroundColor(.white)
    /// 居中遮罩view
    open lazy var markView = UIView().qbackgroundColor(self.options.tintColor.withAlphaComponent(0.1))
        .qisUserInteractionEnabled(false)
        .qcornerRadius(4, true)
    /// 取消
    open lazy var cancel: UILabel = .init().qtext("取消").qfont(.systemFont(ofSize: 15)).qtextAliginment(.center)
        .qborder(.qhex(0x666666), 1).qcornerRadius(4, true)
        .qtextColor(.qhex(0x666666)).qtap { [weak self] _ in
            self?.cancelAction()
        }
    /// 确定
    open lazy var comfirm: UILabel = .init().qtext("确定").qfont(.systemFont(ofSize: 15)).qtextAliginment(.center)
        .qbackgroundColor(self.options.tintColor).qcornerRadius(4, true)
        .qtextColor(.white).qtap { [weak self] _ in
            self?.comfirmAction()
        }
    open var tableViews : [UITableView] = []
    
    open var selectedDate: Date = .init()
    
    open lazy var starTime: QLabel = .init().qthen {
        $0.textLabel.qnumberOfLines(0).qtext("开始").qfont(.systemFont(ofSize: 16)).qtextAliginment(.center).qadjustsFontSizeToFitWidth(true)
        $0.edges = .init(top: 5, left: 5, bottom: 5, right: 5)
        $0.qborder(self.options.tintColor, 1).qcornerRadius(4, true).qtap { [weak self] view in
            self?.selectedIndex = 0
            self?.reload()
        }
    }
    open lazy var endTime: QLabel = .init().qthen {
        $0.textLabel.qnumberOfLines(0).qtext("结束").qfont(.systemFont(ofSize: 16)).qtextAliginment(.center).qadjustsFontSizeToFitWidth(true)
        $0.edges = .init(top: 5, left: 5, bottom: 5, right: 5)
        $0.qborder(self.options.tintColor, 1).qcornerRadius(4, true).qtap { [weak self] view in
            self?.selectedIndex = 1
            self?.reload()
        }
    }
    open var bgView = UIView().qbackgroundColor(.black.withAlphaComponent(0.25)).qalpha(0)
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
        }
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bgView.alpha = 0
    }
    open var selectedIndex: Int = 0
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.starTime.qtagObject(self.options.date)
        self.endTime.qtagObject(self.options.date)
        self.selectedDate = self.options.date
        let count0 = self.options.type.filter({!$0.isseparator}).count
        if count0 == 0 { return }
        let count1 = self.options.type.filter({$0.isseparator}).count
        let separawidth = 16
        var width = (Int(qscreenwidth - 30.0) - (count1 * separawidth)) / count0
        width = min(width, 80)
        let tbs = self.options.type.compactMap { type -> UITableView in
            let type = type
            return UITableView.init(frame: .zero, style: .plain)
                .qmakeConstraints({ make in
                    make.width.equalTo(type.isseparator ? separawidth : width)
                })
                .qcornerRadius(0, type.isseparator ? false : true)
                .qisScrollEnabled(!type.isseparator)
                .qbackgroundColor(.white)
                .qtagObject(type)
                .qseparatorStyle(.none)
                .qshowsVerticalScrollIndicator(false)
                .qregister(QDatePickerCell.self, identifier: "cell")
                .qnumberofRows { [weak self] section in
                    guard let self = self else { return 0 }
                    switch type {
                    case .separator:
                        return 5
                    case .year:
                        return self.options.maxYear  - self.options.minYear + 1 + 4
                    case .month:
                        return 12 + 4
                    case .day:
                        return self.selectedDate.qDayCount + 4
                    case .hour:
                        return 24 + 4
                    case .min:
                        return 60 + 4
                    case .second:
                        return 60 + 4
                    }
                }
                .qheightForRow { indexPath in
                    return 44
                }
                .qcell { [weak self] tableView, indexPath in
                    if let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? QDatePickerCell {
                        let count = tableView.numberOfRows(inSection: indexPath.section)
                        cell.label.isHidden = indexPath.row <= 1 || indexPath.row >= count - 2
                        cell.label.text = self.text(type: type, row: indexPath.row)
                        return cell
                    }
                    return QDatePickerCell.init(style: .default, reuseIdentifier: "cell")
                }
                .qwillEndDragging { scrollView, velocity, targetContentOffset in
                    let targetOffset = targetContentOffset.pointee
                    let offsety = Int(targetOffset.y) % 44
                    if abs(offsety) < 22 {
                        targetContentOffset.pointee.y -= CGFloat(offsety)
                    } else {
                        targetContentOffset.pointee.y += CGFloat(44 - offsety)
                    }
                }
                .qdidEndScroll { [weak self] scrollView in
                    self?.changeDate()
                }
        }
        tableViews = tbs
        let tableviews = tbs.qjoined(aixs: .horizontal, spacing: 0, align: .fill, distribution: .equalSpacing)
        self.view.qbody([
            bgView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }),
            contentView.qmakeConstraints({ make in
                make.left.bottom.right.equalToSuperview()
            })
            .qbody([
                [
                    /// 标题
                    titleLabel.qmakeConstraints({$0.width.equalToSuperview()}),
                    [starTime, endTime].qjoined(aixs: .horizontal, spacing: 20, align: .fill, distribution: .fillEqually)
                        .qmakeConstraints({$0.height.equalTo(60); $0.width.equalToSuperview()}).qisHidden(self.style != .style2),
                    /// 时间选择
                    tableviews.qmakeConstraints({ $0.height.equalTo(44 * 5) }),
                    /// 取消、确定
                    [cancel, comfirm].qjoined(aixs: .horizontal, spacing: 20, align: .fill, distribution: .fillEqually)
                    .qmakeConstraints({$0.height.equalTo(44); $0.width.equalToSuperview()})
                ].qjoined(aixs: .vertical, spacing: 10, align: .center, distribution: .equalSpacing)
                    .qmakeConstraints({ make in
                        make.left.right.equalToSuperview().inset(15)
                        make.top.equalToSuperview().inset(20)
                        make.bottom.equalToSuperview().inset(qbottomSafeHeight + 15)
                    }),
                markView.qmakeConstraints({ make in
                    make.center.equalTo(tableviews)
                    make.left.right.equalToSuperview().inset(15)
                    make.height.equalTo(44)
                })
            ])
        ])
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.reload()
        }
    }
    open func reload() {
        guard let date = (self.selectedIndex == 0 ? self.starTime : self.endTime).qtagObject() as? Date else { return }
        self.tableViews.forEach { tableView in
            if let type = tableView.qtagObject() as? QDataPickerOptions.PickerType {
                switch type {
                case .separator:
                    break
                case .year:
                    let row = date.qYear - (self.options.minYear - 2)
                    let count = tableView.numberOfRows(inSection: 0)
                    if row < count && row >= 0 {
                        tableView.scrollToRow(at: .init(row: row, section: 0), at: .middle, animated: false)
                    }
                case .month:
                    let row = date.qMonth - (1 - 2)
                    let count = tableView.numberOfRows(inSection: 0)
                    if row < count && row >= 0 {
                        tableView.scrollToRow(at: .init(row: row, section: 0), at: .middle, animated: false)
                    }
                case .day:
                    let row = date.qDay - (1 - 2)
                    let count = tableView.numberOfRows(inSection: 0)
                    if row < count && row >= 0 {
                        tableView.scrollToRow(at: .init(row: row, section: 0), at: .middle, animated: false)
                    }
                case .hour:
                    let row = date.qHour + (2)
                    let count = tableView.numberOfRows(inSection: 0)
                    if row < count && row >= 0 {
                        tableView.scrollToRow(at: .init(row: row, section: 0), at: .middle, animated: false)
                    }
                case .min:
                    let row = date.qMinute + (2)
                    let count = tableView.numberOfRows(inSection: 0)
                    if row < count && row >= 0 {
                        tableView.scrollToRow(at: .init(row: row, section: 0), at: .middle, animated: false)
                    }
                case .second:
                    let row = date.qSecond + (2)
                    let count = tableView.numberOfRows(inSection: 0)
                    if row < count && row >= 0 {
                        tableView.scrollToRow(at: .init(row: row, section: 0), at: .middle, animated: false)
                    }
                }
            }
        }
        guard let date1 = self.starTime.qtagObject() as? Date,
              let date2 = self.endTime.qtagObject() as? Date else { return }
        
        let color1 = self.selectedIndex == 0 ? self.options.tintColor : .qhex("#333333")
        let color2 = self.selectedIndex == 1 ? self.options.tintColor : .qhex("#333333")
        self.starTime.qborder(color1, 1).textLabel.qtextColor(color1)
        self.endTime.qborder(color2, 1).textLabel.qtextColor(color2)
        let ymd = self.options.type.compactMap({$0.formatter_ymd}).joined(separator: "/")
        let hms = self.options.type.compactMap({$0.formatter_hms}).joined(separator: ":")
        let time = [ymd, hms].joined(separator: " ")
        let starText = String.qassert(condition: self.options.star.qisEmpty, v1: "", v2: "\(self.options.star ?? "")\n")
        let endText = String.qassert(condition: self.options.end.qisEmpty, v1: "", v2: "\(self.options.end ?? "")\n")
        self.starTime.textLabel.text = "\(starText)\(date1.qtoString(time))"
        self.endTime.textLabel.text = "\(endText)\(date2.qtoString(time))"
        guard self.style == .style2,
              let time1 = date1.qtoString(time).qtoDate(time),
              let time2 = date2.qtoString(time).qtoDate(time) else { return }
        let can = time1.timeIntervalSince1970 < time2.timeIntervalSince1970
        self.comfirm.isUserInteractionEnabled = can
        self.comfirm.alpha = can ? 1 : 0.4
    }
    /// 将对应的row转换为显示的文本
    open func text(type: QDataPickerOptions.PickerType, row: Int) -> String {
        var text = ""
        switch type {
        case .separator(let t):
            text = t
        case .year:
            text = "\(self.options.minYear + row - 2)"
        case .month:
            text = "\(String(format: "%02d", row + 1 - 2))"
        case .day:
            text = "\(String(format: "%02d", row + 1 - 2))"
        case .hour:
            text = "\(String(format: "%02d", row - 2))"
        case .min:
            text = "\(String(format: "%02d", row - 2))"
        case .second:
            text = "\(String(format: "%02d", row - 2))"
        }
        return text
    }
    open func changeDate() {
        guard let date = Date.qdateBy(year: self.getValue(.year), month: self.getValue(.month), day: 1, hour: 8, minute: 0, second: 0) else { return }
        self.selectedDate = date
        tableViews.forEach({$0.reloadData(); $0.layoutIfNeeded()})
        var c = DateComponents()
        c.timeZone = .current
        c.year = self.getValue(.year)
        c.month = self.getValue(.month)
        c.day = self.getValue(.day)
        c.hour = self.getValue(.hour)
        c.minute = self.getValue(.min)
        c.second = self.getValue(.second)
        if let date = Calendar.qcurrent.date(from: c) {
            (self.selectedIndex == 0 ? self.starTime : self.endTime).qtagObject(date)
            self.reload()
        }
    }
    open func getValue(_ type: QDataPickerOptions.PickerType) -> Int? {
        var value: Int?
        if let tableView = tableViews.first(where: { tb in
            if let t = tb.qtagObject() as? QDataPickerOptions.PickerType {
                return type == t
            }
            return false
        }) {
            let y = tableView.contentOffset.y + 44 * 2 + 22
            if let row = tableView.indexPathForRow(at: .init(x: 3, y: y))?.row {
                switch type {
                case .separator:
                    break
                case .year:
                    value = row - 2 + self.options.minYear
                case .month:
                    value = row - 2 + 1
                case .day:
                    value = row - 2 + 1
                case .hour:
                    value = row - 2
                case .min:
                    value = row - 2
                case .second:
                    value = row - 2
                }
            }
        }
        return value
    }
    open func cancelAction() {
        self.dismiss(animated: true) {
            self.finish?(nil)
        }
    }
    open func comfirmAction() {
        guard let date1 = self.starTime.qtagObject() as? Date else { return }
        if self.style == .style1 {
            self.dismiss(animated: true) {
                self.finish?([date1])
            }
            return
        }
        guard let date2 = self.endTime.qtagObject() as? Date else { return }
        let ymd = self.options.type.compactMap({$0.formatter_ymd}).joined(separator: "/")
        let hms = self.options.type.compactMap({$0.formatter_hms}).joined(separator: ":")
        let time = [ymd, hms].joined(separator: " ")
        guard let time1 = date1.qtoString(time).qtoDate(time),
              let time2 = date2.qtoString(time).qtoDate(time) else { return }
        if time1.timeIntervalSince1970 >= time2.timeIntervalSince1970 {
            return
        }
        self.dismiss(animated: true) {
            self.finish?([time1, time2])
        }
    }
}
class QDatePickerCell: UITableViewCell {
    let label = UILabel().qnumberOfLines(0).qfont(.systemFont(ofSize: 15)).qtextAliginment(.center)
        .qadjustsFontSizeToFitWidth(true)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.qbody([
            label.qmakeConstraints({ make in
                make.center.equalToSuperview()
            })
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
