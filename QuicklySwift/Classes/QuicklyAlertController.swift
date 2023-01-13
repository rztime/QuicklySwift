//
//  QuicklyAlertController.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/6.
//

import UIKit

public extension UIAlertController {
    /// 快速弹窗方法
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 提示信息
    ///   - actions: 按钮标题
    ///   - cancelTitle: 取消按钮的标题
    ///   - style: 弹窗样式
    ///   - complete: 按钮点击之后的回调，从actions数组取的index
    ///   - cancel: 取消按钮的回调
    @discardableResult
    class func qwith(title: String?, _ message: String?, actions: [String]?, cancelTitle: String? = nil, style: UIAlertController.Style = .alert, complete: ((_ index: Int) -> Void)? = nil, cancel:(() -> Void)? = nil) -> UIAlertController {
        let vc = UIAlertController.init(title: title, message: message, preferredStyle: style)
        if let title = cancelTitle {
            let c = UIAlertAction.init(title: title, style: .cancel) { _ in
                cancel?()
            }
            vc.addAction(c)
        }
        actions?.enumerated().forEach({ action in
            let c = UIAlertAction.init(title: action.element, style: .default) { _ in
                complete?(action.offset)
            }
            vc.addAction(c)
        })
        qAppFrame.present(vc, animated: true, completion: nil)
        return vc
    }
}
/// 自定义
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
    
    @discardableResult
    public class func show(options: QAlertControllerOptions, finishHandle: ((Int) -> Void)?) -> QActionSheetController {
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
                self?.contentShow(false)
            }),
            
            contentView.qmakeConstraints({ make in
                make.top.equalTo(self.view.snp.bottom)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
            })
        ])
        contentView.qbody([
            stackView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        stackView.qalignment(self.options.aligment)
        
        contentView.qcornerRadiusCustom([.topLeft, .topRight], radii: 10).qbackgroundColor(.white)
        /// 标题
        if let t = self.options.title, t.length > 0 {
            let label = UILabel().qnumberOfLines(0)
            label.attributedText = t
            let v = UIView().qbody([
                label.qmakeConstraints({ make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(10)
                    make.height.greaterThanOrEqualTo(30)
                })
            ])
            stackView.qaddArrangedSubview(v)
        }
        /// 描述
        if let t = self.options.desc, t.length > 0 {
            let label = UILabel().qnumberOfLines(0)
            label.attributedText = t
            let v = UIView().qbody([
                label.qmakeConstraints({ make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(10)
                    make.height.greaterThanOrEqualTo(20)
                })
            ])
            stackView.qaddArrangedSubview(v)
        }
        /// 选项
        let actions = self.options.actions
        if !actions.isEmpty {
            let line = min(actions.count, 5)
            stackView.qbody([
                tableView.qmakeConstraints({ make in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(line * 50)
                })
            ])
            tableView.qcontentSizeChanged { scrollView in
                scrollView.isScrollEnabled = Int(scrollView.contentSize.height) > Int(scrollView.frame.size.height + 3)
            }
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            }
            let hadSubDesc = (self.options.subDesc?.length != 0)
            tableView
                .qseparatorStyle(.none)
                .qnumberofRows({ section in
                    return actions.count
                })
                .qcell { tableView, indexPath in
                    let cell: QAlertControllerAcitonItem = (tableView.dequeueReusableCell(withIdentifier: "cell") as? QAlertControllerAcitonItem) ?? QAlertControllerAcitonItem.init(style: .default, reuseIdentifier: "cell")
                    cell.titleLabel.attributedText = actions[qsafe: indexPath.row]
                    cell.line.isHidden = ((indexPath.row == actions.count - 1) && !hadSubDesc)
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
            let label = UILabel().qnumberOfLines(0)
            label.attributedText = t
            let v = UIView().qbody([
                label.qmakeConstraints({ make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(10)
                    make.height.greaterThanOrEqualTo(20)
                })
            ])
            stackView.qaddArrangedSubview(v)
        }
        /// 取消
        if let t = self.options.cancel, t.length > 0 {
            let label = UILabel().qnumberOfLines(0)
            label.attributedText = t
            let v = UIView().qbody([
                label.qmakeConstraints({ make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(10)
                    make.height.greaterThanOrEqualTo(30)
                })
            ]).qtap { [weak self] _ in
                self?.contentShow(false)
            }
            let line = UIView().qbackgroundColor(.init(white: 0.8, alpha: 0.3))
            line.snp.makeConstraints { make in
                make.height.equalTo(10)
                make.width.equalTo(qscreenwidth)
            }
            stackView.qbody([line, v])
        }
        let v = UIView()
        v.snp.makeConstraints { make in
            make.height.equalTo(qbottomSafeHeight)
        }
        stackView.qaddArrangedSubview(v)
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
}

class QAlertControllerAcitonItem: UITableViewCell {
    let titleLabel = UILabel().qnumberOfLines(0)
    let line = UIView().qbackgroundColor(.init(white: 0.8, alpha: 0.3))
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    }
    
    var title: NSAttributedString?
    var desc: NSAttributedString?
    var subDesc: NSAttributedString?
    var actions: [NSAttributedString] = []
    var cancel: NSAttributedString?
    var aligment: UIStackView.Alignment = .fill
    
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
                if let text = text, text.length == 0 {
                    self.title = text
                }
            case .description(let text):
                if let text = text, !text.isEmpty {
                    self.desc = NSAttributedString.init(string: text, attributes: descDict)
                }
            case .descriptionAttributeText(let text):
                if let text = text, text.length == 0 {
                    self.desc = text
                }
            case .subDescription(let text):
                if let text = text, !text.isEmpty {
                    self.subDesc = NSAttributedString.init(string: text, attributes: descDict)
                }
            case .subDescriptionAttributeText(let text):
                if let text = text, text.length == 0 {
                    self.subDesc = text
                }
            case .action(let text):
                if let text = text, !text.isEmpty {
                    self.actions.append(NSAttributedString.init(string: text, attributes: dict))
                }
            case .actionAttributeText(let text):
                if let text = text, text.length == 0 {
                    self.actions.append(text)
                }
            case .cancel(let text):
                if let text = text, !text.isEmpty {
                    self.cancel = NSAttributedString.init(string: text, attributes: dict)
                }
            case .cancelAttributeText(let text):
                if let text = text, text.length == 0 {
                    self.cancel = text
                }
            case .alignment(let alignment):
                self.aligment = alignment
            }
        }
    }
}
