//
//  QActionSheetController.swift
//  QuicklySwift
//
//  Created by rztime on 2023/1/19.
//

import UIKit

/// 自定义ActionSheetController，支持图文混排
public class QActionSheetController: UIViewController {
    let contentView = UIView.init(frame: .init(x: 0, y: qscreenheight, width: qscreenwidth, height: 300))
    
    let stackView = QStackView.qbody(.vertical, 0, .fill, .equalSpacing, []).qframe(.init(x: 0, y: 0, width: qscreenwidth, height: 100))
    
    let tableView = UITableView.init(frame: .init(x: 0, y: 0, width: qscreenwidth, height: 300), style: .plain)
    let options: QAlertControllerOptions
    
    var selectedIndex: Int?
    
    /// 小于0时，为取消
    public var finishHandle: ((Int) -> Void)?
    
    public init(options: QAlertControllerOptions) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    /// 显示一个弹窗，finishHandle  < 0 表示取消
    @discardableResult
    public class func show(options: QAlertControllerOptions, finishHandle: ((_ index: Int) -> Void)?) -> QActionSheetController {
        let vc = QActionSheetController.init(options: options)
        vc.finishHandle = finishHandle
        vc.modalPresentationStyle = .overCurrentContext
        qAppFrame.present(vc, animated: false, completion: nil)
        return vc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        self.view.qbody([
            UIView().qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }).qtap({ [weak self] _ in
                if self?.options.dismissWhenTouchOut == true {
                    self?.contentShow(false)
                }
            }),
            contentView
                .qcornerRadiusCustom([.topLeft, .topRight], radii: 15)
                .qbackgroundColor(self.options.backgroundColor)
                .qbody([
                    stackView.qmakeConstraints({ make in
                        make.edges.equalToSuperview()
                    }).qalignment(self.options.aligment)
                ])
                .qmakeConstraints({ make in
                    make.top.equalTo(self.view.snp.bottom)
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview()
                })
        ])
        /// 标题
        if let t = self.options.title, t.length > 0 {
            addLabel(title: t)
        }
        /// 描述
        if let t = self.options.desc, t.length > 0 {
            addLabel(title: t).qbody([
                /// 加一个底部线
                UIView().qbackgroundColor(self.options.separatorColor)
                    .qmakeConstraints({ make in
                        make.left.bottom.right.equalToSuperview()
                        make.height.equalTo(1)
                    })
            ])
        }
        /// 选项
        let actions = self.options.actions
        if !actions.isEmpty {
            stackView.qbody([
                tableView.qmakeConstraints({ make in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(50)
                })
            ])
            tableView.qcontentSizeChanged { scrollView in
                var height: CGFloat
                if qisdeviceLandscape {
                    height = min(scrollView.contentSize.height, 175)
                } else {
                    height = min(scrollView.contentSize.height, 275)
                }
                scrollView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
                scrollView.isScrollEnabled = Int(scrollView.contentSize.height) > Int(height)
            }
            tableView
                .qbackgroundColor(.clear)
                .qsectionHeaderTopPadding(0)
                .qcontentInsetAdjustmentBehavior(.never)
                .qseparatorStyle(.none)
                .qnumberofRows({ section in
                    return actions.count
                })
                .qcell { [weak self] tableView, indexPath in
                    let cell: QAlertControllerAcitonItem = (tableView.dequeueReusableCell(withIdentifier: "cell") as? QAlertControllerAcitonItem) ?? QAlertControllerAcitonItem.init(style: .default, reuseIdentifier: "cell")
                    cell.titleLabel.attributedText = actions[qsafe: indexPath.row]
                    cell.line.isHidden = (indexPath.row == actions.count - 1)
                    cell.line.backgroundColor = self?.options.separatorColor
                    return cell
                }
                .qdidSelectRow { [weak self] tableView, indexPath in
                    tableView.deselectRow(at: indexPath, animated: false)
                    self?.selectedIndex = indexPath.row
                    self?.contentShow(false)
                }
        }
        /// 底部描述
        if let t = self.options.subDesc, t.length > 0 {
            addLabel(title: t).qbody([
                /// 加一个顶部线
                UIView().qbackgroundColor(self.options.separatorColor)
                    .qmakeConstraints({ make in
                        make.left.top.right.equalToSuperview()
                        make.height.equalTo(1)
                    })
            ])
        }
        /// 取消
        if let t = self.options.cancel, t.length > 0 {
            stackView.qbody([
                UIView().qbackgroundColor(self.options.separatorColor)
                    .qmakeConstraints({ make in
                        make.height.equalTo(10)
                        make.width.equalToSuperview()
                    })
            ])
            addLabel(title: t).qtap { [weak self] view in
                self?.contentShow(false)
            }
        }
        /// 底部安全区域
        stackView.qbody([
            UIView().qmakeConstraints({ make in
                make.height.equalTo(qbottomSafeHeight)
            })
        ])
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentShow(true)
    }
    public func contentShow(_ show: Bool) {
        self.contentView.layoutIfNeeded()
        self.contentView.snp.remakeConstraints { make in
            if show {
                make.bottom.equalToSuperview()
            } else {
                make.top.equalTo(self.view.snp.bottom)
            }
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        UIView.animate(withDuration: 0.38, delay: 0) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            if !show {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.38, execute: {
                    self.dismiss(animated: false) {
                        self.finishHandle?(self.selectedIndex ?? -1)
                    }
                })
            }
        }
    }
    @discardableResult
    func addLabel(title: NSAttributedString) -> UIView {
        let v = UIView()
        stackView.qbody([
            v.qbody([
                UILabel()
                    .qnumberOfLines(0)
                    .qattributedText(title)
                    .qmakeConstraints({ make in
                        make.left.right.equalToSuperview().inset(15)
                        make.top.bottom.equalToSuperview().inset(10)
                        make.height.greaterThanOrEqualTo(30)
                    })
            ])
        ])
        return v
    }
}

class QAlertControllerAcitonItem: UITableViewCell {
    let titleLabel = UILabel().qnumberOfLines(0)
    let line = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.qbody([
            titleLabel.qmakeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.top.bottom.equalToSuperview().inset(10)
                make.height.greaterThanOrEqualTo(30)
            }),
            line.qmakeConstraints({ make in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(1)
            })
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class QAlertControllerOptions {
    public enum Options {
        /// 标题
        case title(String?)
        case titleAttributeText(NSAttributedString?)
        /// 标题下的描述
        case description(String?)
        case descriptionAttributeText(NSAttributedString?)
        /// 最后一个选项之后的描述
        case subDescription(String?)
        case subDescriptionAttributeText(NSAttributedString?)
        /// 选项
        case action(String?)
        case actionAttributeText(NSAttributedString?)
        /// 取消
        case cancel(String?)
        case cancelAttributeText(NSAttributedString?)
        /// 对齐方式
        case alignment(UIStackView.Alignment)
        /// 背景色
        case backgroundColor(UIColor)
        /// 点击界面外，关闭 // 默认true
        case dismissWhenTouchOut(Bool)
        /// 分割线颜色
        case separatorColor(UIColor)
    }
    
    var title: NSAttributedString?
    var desc: NSAttributedString?
    var subDesc: NSAttributedString?
    var actions: [NSAttributedString] = []
    var cancel: NSAttributedString?
    var aligment: UIStackView.Alignment = .fill
    var backgroundColor: UIColor = .white
    var dismissWhenTouchOut: Bool = true
    var separatorColor: UIColor = .init(white: 0.8, alpha: 0.3)
    public init(options: [QAlertControllerOptions.Options]) {
        let p = NSMutableParagraphStyle.init()
        p.alignment = .center
        p.lineSpacing = 5
        let descDict: [NSAttributedString.Key: Any] = [.paragraphStyle: p,
                                                   .foregroundColor: UIColor.init(white: 0.5, alpha: 1),
                                                   .font: UIFont.systemFont(ofSize: 11)
                                                ]
        let dict: [NSAttributedString.Key: Any] = [.paragraphStyle: p,
                                                   .foregroundColor: UIColor.init(white: 0.3, alpha: 1),
                                                   .font: UIFont.systemFont(ofSize: 16)
                                                ]
        options.forEach { opt in
            switch opt {
            case .title(let text):
                if let text = text, !text.isEmpty {
                    self.title = NSAttributedString.init(string: text, attributes: dict)
                }
            case .titleAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.title = text
                }
            case .description(let text):
                if let text = text, !text.isEmpty {
                    self.desc = NSAttributedString.init(string: text, attributes: descDict)
                }
            case .descriptionAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.desc = text
                }
            case .subDescription(let text):
                if let text = text, !text.isEmpty {
                    self.subDesc = NSAttributedString.init(string: text, attributes: descDict)
                }
            case .subDescriptionAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.subDesc = text
                }
            case .action(let text):
                if let text = text, !text.isEmpty {
                    self.actions.append(NSAttributedString.init(string: text, attributes: dict))
                }
            case .actionAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.actions.append(text)
                }
            case .cancel(let text):
                if let text = text, !text.isEmpty {
                    self.cancel = NSAttributedString.init(string: text, attributes: dict)
                }
            case .cancelAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.cancel = text
                }
            case .alignment(let alignment):
                self.aligment = alignment
            case .backgroundColor(let color):
                self.backgroundColor = color
            case .dismissWhenTouchOut(let diss):
                self.dismissWhenTouchOut = diss
            case .separatorColor(let color):
                self.separatorColor = color
            }
        }
    }
}

