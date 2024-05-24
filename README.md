# QuicklySwift

本代码只为提高 Swift UI 层的开发效率，使写代码更简洁、更易读、易维护

[![CI Status](https://img.shields.io/travis/rztime/QuicklySwift.svg?style=flat)](https://travis-ci.org/rztime/QuicklySwift)
[![Version](https://img.shields.io/cocoapods/v/QuicklySwift.svg?style=flat)](https://cocoapods.org/pods/QuicklySwift)
[![License](https://img.shields.io/cocoapods/l/QuicklySwift.svg?style=flat)](https://cocoapods.org/pods/QuicklySwift)
[![Platform](https://img.shields.io/cocoapods/p/QuicklySwift.svg?style=flat)](https://cocoapods.org/pods/QuicklySwift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

QuicklySwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QuicklySwift'
```

如果无法下载最新版本，可以在podfile中使用
```ruby
pod 'QuicklySwift', :git => 'https://github.com/rztime/QuicklySwift.git'
```

## Author

rztime, rztime@vip.qq.com, qq交流群：580839749

## License

QuicklySwift is available under the MIT license. See the LICENSE file for more info.

## 最近更新日志

| 相关 | 说明 |
|:----|:----|
|v0.8.0|优化以及新增功能QSlider, QSwitch, 可通过options来配置大小和圆角，可以直接设置相关view的颜色、图片来自定义|
|v0.7.0|优化新增功能，文件管理，pcm音频转wav, 定位管理，AVPlayer封装等等|
|v0.6.0|添加脚本以解决：库里包含的相关的权限申请的代码，在info.plist里没有配置相关使用说明时，编译时隐藏代码，避免提审时被拒|
|v0.5.0|优化警告，新增QDispatch等|
|v0.4.0|优化新增一些功能，新增alertvc,新增文字渐变色|
|v0.3.0|新增通过url或者path获取文件属性，新增部分功能|
|v0.2.0|优化部分KVO监听的事件，添加弹窗支持图文混排，添加字符串的安全(表情)截取方法，对一些方法进行优化，添加动态规划方法|
|v0.1.8|添加view飘灰配置功能、对数字进行小数位转换等等|
|v0.1.7|添加虚线、一些监听、属性改变回调、定时器的用法等等|
|v0.1.5|添加权限判断方法<br> QuicklyAuthorization.result(with: QAuthorizationType.photoLibrary) { result in }|
|v0.1.4|添加push、pop的自定义转场动画方法和demo<br>添加预览相册的push、pop动画|
|v0.1.3|添加手势、气泡、气泡弹窗等等方法|
 
## 说明

如何提高 UI 的开发效率：

    1. 写UI时，能快速布局，层级清晰
    2. 代码写着顺手
    3. 代码简洁、少
    4. 代码功能封装完善

如何降低 UI 维护成本

    1. 代码少、出错的少、修改的时候更容易
    2. 代码简洁易读、view所属层级清晰、约束依赖清晰
    3. view相关配置、使用更集中，要查找更改更轻松

## 汇总

| 相关 | 说明 |
|:----|:----|
|QSlider, QSwitch|进度条、开关,和原生一样，还可以随意调整|
|QPlayer|对AVPlayer的封装，可监听播放状态、时间、加载中、加载进度、循环播放、倍数播放等等|
|QDispatch|串行、同步执行方法，可延迟触发方法等等|
|QPublish|可监听改变操作|
|QActionSheetController、QAlertViewController|自定义多种功能弹窗|
|QuicklyAuthorization|权限相关，当info.plist里没有相关权限申请说明时，隐藏相关权限申请代码，防止审核被拒|
|QGrayFloatManager|飘灰管理：给view在指定区域内添加一个黑白滤镜，并可一键控制滤镜开关|
|UIView| 常用属性的快速设置、扩展设置（高斯模糊、气泡、手势、圆角等等）、size改变之后的回调、deinit之后的回调、常用动画等等 |
|UIScrollView| contentSize和contentOffset改变回调、delegate的回调等等|
|UITableView、UICollectionView| dataSource, delegate的回调等等|
|UITextView、UItextField| 快速使用的方法、长度限制、占位符、delegate回调等等|
|UILabel、UIButton、UIImage、UIColor| 相关的方法的快速使用|
|UIViewController| 生命周期的回调、push、pop的自定义跳转动画，相册预览|
|UIAlertController| 快速使用|
|QuicklyPopmenu| 菜单view|
|Number, Int等等|根据配置转换成字符串，取整，保留几位小数，不足位补0等等|
等等

- UIView:

除了本身已有的属性，可通过添加q的方式使用，如
```
let  view = UIView().qbackgroundColor(.red).qisUserInteractionEnabled(true)
```

另外添加的扩展方法， 所有继承UIView的，都可以使用这些方法

| 方法 | 说明 |
|:----|:----|
|qbody| 添加子视图|
|qmakeConstraints| 视图添加约束，在父视图body添加view的方法中使用|
|qsizeChanged| size发生改变的回调|
|qshowToWindow| 在window上显示隐藏的回调|
|qdeinit| 释放之后的回调 |
|qcornerRadiusCustom| 设置四个角部分圆角|
|qgaussBlur | 设置高斯模糊|
|qgradientColors| 设置渐变色|
|qairbubble| 添加气泡背景|
|qtap| 单击手势回调|
|qtapNumberof| 单击手势|
|qpanNumberof| 拖拽手势|
|qdrag| 使view可以在父视图上随意拖拽，并可自动吸边|
|qlongpress| 长按手势|
|qswipe| 轻扫手势|
|qtoImage| 将view转换为图片|
|qshake| view抖动|
|qrotation| 旋转（转圈）|
|qtransform| 平移、旋转一定角度、缩放|
|QuikclyPopmenu| 在指定位置弹出菜单view|
|qgrayfloat| 页面添加飘灰区域 |

- UITextField、UITextView:

除了本身的属性可以通过q方法调用, delegate的方法直接使用block即可回调使用

```
let textField = UITextField.init(frame: .zero)
    .qplaceholder("输入文本")
    .qmaxCount(10) // 最多输入字数 区别在于一个表情长度=1
//        .qmaxLength(10) // 最多输入字数 区别在于一个表情长度=2（也有大于2）
    .qbackgroundColor(.lightGray.withAlphaComponent(0.3))
    .qleftView(UIView.init(frame: .init(x: 0, y: 0, width: 30, height: 30)), .always)
    .qclearButtonMode(.always)
    .qfont(.systemFont(ofSize: 16))
    .qtextColor(.red)
    .qtextChanged({ textField in
        print("text 改变")
    }).qshouldChangeText { textField, range, replaceText in
        return true
    }.qshouldBeginEditing { textField in
        return true
    }
```

|方法|说明|
|:---|:----|
|qmaxCount|最多输入字符个数（表情算做1个）|
|qmaxLength|最多输入字符长度（表情的长度有可能是2、4、7）|
|qplaceholder| textView设置空白站位|
|qattributedPlaceholder| 富文本站位|

- UIControl: 一样的，一些属性和方法可以通过q来调用

|方法|说明|
|:---|:----|
|qactionFor|使用block方式实现事件的回调|
|qisSelectedChanged| control isselected 设置改变之后的回调|
|qisEnabledChanged| control isEnabled 状态改变之后的回调|

```
let btn = UIButton.init(type: .custom).qactionFor(.touchUpInside, handler: { sender in
    print("按钮点击")
}).qisSelectedChanged { sender in
    // isSelected 状态改变
    sender.backgroundColor = sender.isSelected ? .red : .lightGray
}.qisEnabledChanged { sender in
    // isEnabled 状态改变
    sender.alpha = sender.isEnabled ? 1 : 0.3
}
```

- UIStackView:

使用了QStackView，当stackView内的子视图全部隐藏时，stackView也隐藏，这样当stackView作为其他stackView的子视图时，也可以收回去

|方法|说明|
|:---|:----|
|VStackView.qbody()|直接生成一个垂直排列的stackView|
|HStackView.qbody()|直接生成一个水平排列的stackView|
|UIStackView.qbody()|按需生成stackView|

- UIScrollView:

除了本身的方法，滚动的delegate的所有方法可以通过block回调来使用时, 如：

```
let scrollView = UIScrollView()
    .qdidScroll { scrollView in
        
    }.qdidEndScroll { scrollView in
        
    }.qdidZoom { scrollView in
        
    }
```
另外添加了扩展

|方法|说明|
|:---|:----|
|qcontentSizeChanged| scrollView的contentSize改变回调|
|qcontentOffsetChanged| scrollView的contentOffset改变回调|
|qdidEndScroll| scrollView滚动停止的回调|

- UITableView、UICollectionView：

除了继承UIScrollView，能使用ScrollView的q方法

他们本身也不需要在使用delegate、dataSource, 如下：（collectionView使用方法一样）

使用qnumberofRows、qcell、qdidSelectRow就可以完成tableView使用

```
tableView
    .qregister(TestTableViewCell.self, identifier: "cell")
    .qnumberofSections {
        return 1
    }.qnumberofRows { section in
        return 100
    }.qcell { tableView, indexPath in
        let cell: TestTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TestTableViewCell) ?? .init(style: .default, reuseIdentifier: "cell")
        let rad = indexPath.row
        cell.nameLabel.text = "阿斯加德发按理阿斯加德发按理"
        cell.timeLabel.text = "05:20"
        cell.cover.isHidden = rad % 3 == 0
        return cell
    }.qdidSelectRow { tableView, indexPath in
        tableView.deselectRow(at: indexPath, animated: false)
        print("---- selected:\(indexPath)")
    }
    .qcanEdit { indexPath in
        return true
    }.qcanMove { indexPath in
        return true
    }.qeditActions { indexPath in
        let aciton = UITableViewRowAction.init(style: .default, title: "删除") { _, indexPath in
            
        }
        return [aciton]
    } 
    .qcontentSizeChanged { scrollView in
        print("contentsize changed 改变")
    }.qcontentOffsetChanged { scrollView in
        print("contentoffset changed 改变")
    }.qdidScroll { scrollView in
        print("scrollView 滚动")
    }.qdidEndScroll { scrollView in
        print("scrollView 停止滚动")
    }

```

- UIViewController

|方法|说明|
|:---|:----|
|qtopViewController|获取当前显示的最顶层的vc|
|qdidpop| vc被pop出去之后的回调|
|qwillAppear| vc将要显示的回调|
|qdidAppear| vc已经显示的回调|
|qwillDisAppear|vc将要消失的回调 |
|qdidDisAppear| vc 已经消失的回调|
|qdeinit| vc被释放的回调 |


- QuicklyAppFrame.swift

app主框架qAppFrame

|方法|说明|
|:---|:----|
|qAppFrame.navigationController| 获取当前最顶层vc所在的navigationController|
|qAppFrame.viewControllers|获取当前最顶层vc所在的navigationController的所有vc|
|qAppFrame.pushViewController()|跳转vc，如果因为卡顿，导致重复跳转到这个vc，会过滤掉|
|qAppFrame.present()| 模态跳转|
|qAppFrame.popViewController()|  pop|
|qAppFrame.remove(vc)| 移除当前栈里的vc|

- QuicklyConstant.swift 

这里有一些常量，都是动态获取，根据当前屏幕、app的状态来获取

|方法|说明|
|:---|:----|
|qappKeyWindow| APP的keywindow|
|qappSafeAreaInsets| keywindow的上下左右安全区域|
|qisiPhoneNotch| 是否是刘海屏|
|qbottomSafeHeight| 底部安全区域（竖屏可能为34，横屏21）|
|qstatusbarHeight|状态栏高度，iOS13之后，高度不确定了|
|qnavigationbarHeight| 导航栏高度= 状态栏高度+44|
|qisdeviceLandscape|当前设备是否是横屏|


## QuicklySwift，主要是对现有部分常用的控件添加了一些扩展方法，为了方便使用，所有方法名属性名添加“q”为前缀

不使用命名空间，是为了使用链式语法，使用时更方便快捷，让开发效率更高
    
## 一: 快速布局 

主要对UIView、UIStackView的扩展，在添加子视图、以及给子视图添加约束的时候，代码更集中，以及层级清晰易读。

#### UIStackView

```
public extension UIStackView {
    /// 生成QStackView
    @discardableResult
    class func qbody(_ axis: NSLayoutConstraint.Axis, _ space: CGFloat, _ align: UIStackView.Alignment, _ distribution: UIStackView.Distribution, _ views: [UIView]?) -> QStackView {
        let stackView = QStackView.init(frame: .zero)
        stackView.qaxis(axis).qspacing(space).qalignment(align).qdistribution(distribution)
        if let views = views, views.count > 0 {
            stackView.qbody(views)
        }
        return stackView
    }
}
/// 垂直UIStackView
public struct VStackView {
    /// 垂直UIStackView
    @discardableResult
    static public func qbody(_ views: [UIView]) -> QStackView {
        return QStackView.qbody(.vertical, 5, .fill, .equalSpacing, views)
    }
}
/// 水平UIStackView
public struct HStackView {
    /// 水平UIStackView
    @discardableResult
    static public func qbody(_ views: [UIView]) -> QStackView {
        return QStackView.qbody(.horizontal, 5, .fill, .equalSpacing, views)
    }
}
```

#### 普通View

```
extentsion UIView {
    /// 添加子视图views, 如果是stackView，会添加addArrangedSubview
    func qbody(_ views: [UIView]) -> Self {}
        
    /// 设置约束。 注意，这个方法仅仅是方便qaddSubviews()  qbody() 方法里的view使用
    /// 需要调用qactiveConstraints() 激活,
    /// 方法里已经激活了，可以不需要调用
    func qmakeConstraints(_ closure: ((_ make: ConstraintMaker) -> Void)?) -> Self {}
}
```
#### 示例代码
```
class QuickLayoutViewController: UIViewController {
    let label1 = UILabel().qtext("文本框1文本框1文本框1文本框1")
    let label2 = UILabel().qtext("文本框2文本框2文本框2文本框2")
    let label3 = UILabel().qtext("文本框3文本框3文本框3文本框3")
    
    let btn1 = UIButton.init(type: .custom).qtitle("按钮1按钮1按钮1按钮1").qtitleColor(.black).qbackgroundColor(.lightGray)
    let btn2 = UIButton.init(type: .custom).qtitle("按钮2按钮2按钮2按钮2").qtitleColor(.black).qbackgroundColor(.lightGray)
    let btn3 = UIButton.init(type: .custom).qtitle("按钮3按钮3按钮3按钮3").qtitleColor(.black).qbackgroundColor(.lightGray)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.view.qbody([
            label1.qmakeConstraints({ make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalToSuperview().inset(qnavigationbarHeight)
            }),
            label2.qmakeConstraints({ make in
                make.left.right.equalTo(self.label1)
                make.top.equalTo(self.label1.snp.bottom).offset(30)
            }),
            label3.qmakeConstraints({ make in
                make.left.right.equalTo(self.label1)
                make.top.equalTo(self.label2.snp.bottom).offset(30)
            }),
            
            /// 垂直排列的UIStackView 
            VStackView.qbody([
                btn1,
                btn2,
                btn3
            ]).qmakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.top.equalTo(self.label3.snp.bottom).offset(50)
            }).qspacing(15),
            
            /// 也可以直接使用数组 :[UIView], qjoined()方法，将直接组合生成一个UIStackView
//            [btn1, btn2, btn3].qjoined(aixs: .vertical, spacing: 15, align: .fill, distribution: .equalSpacing)
//                .qmakeConstraints({ make in
//                    make.left.right.equalToSuperview()
//                    make.top.equalTo(self.label3.snp.bottom).offset(50)
//                })
        ])
    }
}
```
'view' 的 'body' 包含三个label、一个垂直VstackView，在qbody添加数组的时候，使用 'qmakeConstraints' 直接设置约束

'view' 子视图层级、依赖更清晰

优点：相较以前（以前需要把子视图添加到父视图之后，才能设置约束)，现在在数组里添加子视图，设置约束，代码更集中，约束作为一个属性，内部会延迟到添加子视图之后去激活约束

```
/// 添加子视图, 如果是stackView，会添加addArrangedSubview
@discardableResult
func qbody(_ views: [UIView]) -> Self {
    if let stackView = self as? UIStackView {
        views.forEach({stackView.addArrangedSubview($0)})
    } else {
        views.forEach({self.addSubview($0)})
    }
    /// 激活约束
    views.forEach({$0.qactiveConstraints()})
    return self
}
/// 激活snap的约束
@discardableResult
func qactiveConstraints() -> Self {
    if let constraintMake = qconstraintMake {
        self.snp.makeConstraints(constraintMake)
        self.qconstraintMake = nil
    }
    return self
}
```

#### 关于页面飘灰

飘灰配置

```
/// 一键开关
QGrayFloatManager.shared.isgrayActive = true // or false

/// 飘灰视图层级，默认为1， view.layer.zPosition默认为0，数值越大，图层越处于顶层
QGrayFloatManager.shared.zposition = 1 
```

view的飘灰两种方式，约束和frame

```swift
/// view 整个飘灰
view.qgrayfloat(edges: .zero)
/// view 部分区域可以多个飘灰
view.qgrayfloat(tag: 1, frame: .init(x: 0, y: 0, width: 100, height: 100))
view.qgrayfloat(tag: 2, frame: .init(x: 0, y: 400, width: 100, height: 100))

/// 如果不想让view里的imageView飘灰
view.addSubview(imageView)
imageView.layer.zposition = 2 // 
```

关于类似tableView飘灰前10行、scrollView飘灰首屏等等方法类似

```swift
/// tableView 只飘灰前10行
tableView.qcontentSizeChanged { [weak self] tb in
    guard let tableView = self?.tableView, let self = self else { return }
    /// 只飘灰前10列，后边的正常显示
    var maxRow = min(10, self.rowCount - 1)
    maxRow = max(0, maxRow)
    let y = tableView.rectForRow(at: IndexPath.init(row: maxRow, section: 0)).maxY
    tableView.qgrayfloat(frame: .init(x: 0, y: 0, width: qscreenwidth, height: y))
} 

/// scrollView 首屏飘灰，之后正常显示
scrollView.qframeChanged { view in
    view.qgrayfloat(frame: .init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
}
```


## 二: UITableView、UICollectionView 的快速使用

不需要使用delegate、dataSource 全部使用q方法来使用，更简单

示例代码： UICollectionView 相同

```
tableView
    .qregister(TestTableViewCell.self, identifier: "cell")
    .qnumberofSections {
        return 1
    }.qnumberofRows { section in
        return 100
    }.qcell { tableView, indexPath in
        let cell: TestTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TestTableViewCell) ?? .init(style: .default, reuseIdentifier: "cell")
        let rad = indexPath.row
        cell.nameLabel.text = "阿斯加德发按理阿斯加德发按理"
        cell.timeLabel.text = "05:20"
        cell.cover.isHidden = rad % 3 == 0
        return cell
    }.qdidSelectRow { tableView, indexPath in
        tableView.deselectRow(at: indexPath, animated: false)
        print("---- selected:\(indexPath)")
    }
```

当然也有其他的关于tableView的方法, 比如编辑、移动、删除、willDisplayCell、EndDisplayCell等等
```
tableView
    .qcanEdit { indexPath in
        return true
    }.qcanMove { indexPath in
        return true
    }.qeditActions { indexPath in
        let aciton = UITableViewRowAction.init(style: .default, title: "删除") { _, indexPath in
            
        }
        return [aciton]
    }
```

## 三: UIScrollView的快速使用

UIScrollView的相关的delegate回调，全部可以通过q方法来获取，并另外添加了contentsize改变、contentoffset改变、didEndScroll结束滚动的回调监听

示例代码: 以下不需要设置delegate，直接使用，示例代码用tableView展示，collectionView等等继承scrollView的，都是同样的方法
```
tableView
    .qcontentSizeChanged { scrollView in
        print("contentsize changed 改变")
    }.qcontentOffsetChanged { scrollView in
        print("contentoffset changed 改变")
    }.qdidScroll { scrollView in
        print("scrollView 滚动")
    }.qdidEndScroll { scrollView in
        print("scrollView 停止滚动")
    }
```

## 四: UIView的方法

这里举例部分代码，基本上所有的属性都有q方法快速使用

view 添加size改变之后的回调，

添加了单击手势（如果是UIControl，有touchup响应事件，两者只用qtap）

添加了拖拽方法qdrag(style)（可自动吸边、或保持手势释放位置）

```
/// 拖拽时，style
public enum QDragPanStyle {
    /// 普通模式，手势停止则view停止, 如果view太靠近边界，需要修正的位置edge
    case normal(edge: UIEdgeInsets)
    /// 吸边，停止之后，自动吸附到水平（左右）靠近的一边
    case nearHorizontal(edge: UIEdgeInsets)
    /// 吸边，停止之后，自动吸附到垂直（上下）靠近的一边
    case nearVertical(edge: UIEdgeInsets)
    /// 吸边，停止之后，自动吸附到靠的最近的一边
    case nearBorder(edge: UIEdgeInsets)
}
```

添加了旋转、平移、缩放、抖动、循环旋转等等

添加了设置部分圆角

```
let testView = UIView()
    .qsizeChanged { view in
        print("view size 改变")
    }.qtap { view in
        print("view 单击手势 响应")
    }.qdeinit {
        // 被释放
    }.qshowToWindow { view, show in
        // 显示在window
    }
    .qdrag(style)  // 拖拽  可自动吸边
    ///.qborder(.black, 1)
    /// 设置左上、右下圆角
    ///.qcornerRadiuscustom([.topLeft, .bottomRight], radii: 50)
    .qcornerRadius(50, false)
    .qbackgroundColor(.lightGray)
    .qshadow(.red, .init(width: 5, height: 5), radius: 20)
    
    等等等等
```

```
let label = UILabel()
    .qfont(.systemFont(ofSize: 15))
    .qtextColor(.red)
    .qnumberOfLines(0)
    .qtap { view in
        print("点击了label")
    }
    等等等等
```

```
let btn = UIButton.init(type: .custom)
    .qtitle("按钮")
    .qtitleColor(.red)
    .qactionFor(.touchUpInside) { sender in
        print("点击了按钮 事件响应")
    }.qtap { view in
        print("点击了按钮 tap响应 如果设置了tap， qactionFor touchUpInside方法无效 将被覆盖")
    }.qisSelectedChanged { sender in
        // isSelected 状态改变
        sender.backgroundColor = sender.isSelected ? .red : .lightGray
    }.qisEnabledChanged { sender in
        // isEnabled 状态改变
        sender.alpha = sender.isEnabled ? 1 : 0.3
    }
```

qactionFor 是所有继承自 UIControl 都可以使用的

```
public extension UIControl {
    /// control的事件回调
    @discardableResult
    func qactionFor(_ event: UIControl.Event, handler:((_ sender: UIControl) -> Void)?) -> Self { }
}

``` 

UITextField、UITextView 方法都类似

添加了最多输入字数限制

UITextView 添加了占位字符串

```    
let textField = UITextField.init(frame: .zero)
    .qplaceholder("输入文本")
    .qmaxCount(10) // 最多输入字数 区别在于一个表情长度=1
//        .qmaxLength(10) // 最多输入字数 区别在于一个表情长度=2（也有大于2）
    .qbackgroundColor(.lightGray.withAlphaComponent(0.3))
    .qleftView(UIView.init(frame: .init(x: 0, y: 0, width: 30, height: 30)), .always)
    .qclearButtonMode(.always)
    .qfont(.systemFont(ofSize: 16))
    .qtextColor(.red)
    .qtextChanged({ textField in
        print("text 改变")
    }).qshouldChangeText { textField, range, replaceText in
        return true
    }.qshouldBeginEditing { textField in
        return true
    }
```

```
let textView = UITextView.init(frame: .zero)
    .qplaceholder("请输入文本")
    .qmaxCount(10) // 最多输入字数 区别在于一个表情长度=1
//        .qmaxLength(10) // 最多输入字数 区别在于一个表情长度=2（也有大于2）
    .qfont(.systemFont(ofSize: 17))
    .qtextColor(.qhex(0xff0000))
    .qbackgroundColor(.lightGray.withAlphaComponent(0.3))
    .qtextChanged({ textView in
        print("text 改变")
    })
```

## 五: UIViewController的方法

给Controller添加了生命周期的回调

```
// let vc = UIViewController()
vc.qdidpop {
    print("self 从navigationController 中 pop 出去了")
}.qdidAppear {
    
}.qdidDisAppear {
    
}.qwillAppear {
    
}.qwillDisAppear {
    
}.qdeinit {

}
```

UIAlertController

```
let actions = ["按钮1", "按钮2", "按钮3"]
UIAlertController.qwith(title: "标题", "提示内容", actions: actions, cancelTitle: "取消", style: .alert) { index in
    print("点击了\(actions[index])， index是取自数组下标")
} cancel: {
    print("点击了取消")
}
```

## 六: 一些常量

app 的 keywindow

```
/// app 的 keywindow
public var qappKeyWindow: UIWindow {
    if let window = UIApplication.shared.delegate?.window, let window = window {
        return window
    }
    if #available(iOS 13.0, *) {
        let arraySet: Set = UIApplication.shared.connectedScenes
        let windowScene: UIWindowScene? = arraySet.first(where: { sce in
            if let _ = sce as? UIWindowScene {
                return true
            }
            return false
        }) as? UIWindowScene
        if let window = windowScene?.windows.first(where: {$0.isKeyWindow}) {
            return window
        }
    }
    if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) {
        return window
    }
    return UIApplication.shared.keyWindow ?? .init()
}
```

app 上下左右安全距离，没有刘海屏，则顶部为状态栏高度，其余为0

```
/// app 上下左右安全距离，没有刘海屏，则顶部为状态栏高度，其余为0
public var qappSafeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return qappKeyWindow.safeAreaInsets
    } else {
        return .init(top: qstatusbarHeight, left: 0, bottom: 0, right: 0)
    }
}
```

是否是刘海屏

```
/// 是否是刘海屏
public var qisiPhoneNotch: Bool {
    if #available(iOS 11.0, *) {
        return qappKeyWindow.safeAreaInsets.bottom > 0
    } else {
        return false
    }
}
```

底部安全区域 刘海屏是34， 也有21（横屏时21） 实时获取

```
/// 底部安全区域 刘海屏是34， 也有21
public var qbottomSafeHeight: CGFloat {
    return qappSafeAreaInsets.bottom
}
```

```
/// 导航栏高度
/// iOS13之后，导航栏高度不固定
public var qstatusbarHeight: CGFloat {
    if #available(iOS 13.0, *),
        let height = qappKeyWindow.windowScene?.statusBarManager?.statusBarFrame.size.height {
        return height
    }
    return UIApplication.shared.statusBarFrame.size.height
}
```

```
/// 导航栏高度 44 + 状态栏高度
public var qnavigationbarHeight: CGFloat {
    return qstatusbarHeight + 44
}
```


```
/// 设备是否横屏
public var qisdeviceLandscape: Bool {
    var type: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    if #available(iOS 13.0, *), let t = qappKeyWindow.windowScene?.interfaceOrientation {
        type = t
    }
    switch type {
    case .landscapeLeft, .landscapeRight:
        return true
    case.portrait, .portraitUpsideDown, .unknown:
        return false
    }
}

```

## 七、APP整体功能 “qAppFrame”

```
QuicklyAppFrame.swift
```

```
qAppFrame.navigationController?  // 获取当前最顶层vc所在的navigationController

qAppFrame.viewControllers   // 获取当前最顶层vc所在的navigationController 的所有的栈viewControllers

qAppFrame.pushViewController(vc, animated:) // 跳转到vc，忽略重复的跳转vc （如果因为卡顿或者其他原因，重复跳转到这一个vc时）

qAppFrame.present(vc, animated: complete)  // 模态打开vc

/// 从当前navigationController栈里移除vc
qAppFrame.remove(viewController: UIViewController, animate: Bool)
qAppFrame.remove(viewControllerClass: AnyClass, animate: Bool)

```



# 题外一

原本只想写 qbody、qmakeConstraints、以及stackView的方法，只想把添加子视图以及约束整合起来，

因为在实际使用中，添加的子视图太多，以及加了自动布局约束之后，

越到后边要理清子视图之间的依赖以及所属的父视图和层级，就越麻烦

```
self.view.qbody([
    label1.qmakeConstraints({ make in
        make.left.right.equalToSuperview().inset(20)
        make.top.equalToSuperview().inset(qnavigationbarHeight)
    }),
    label2.qmakeConstraints({ make in
        make.left.right.equalTo(self.label1)
        make.top.equalTo(self.label1.snp.bottom).offset(30)
    }),
    label3.qmakeConstraints({ make in
        make.left.right.equalTo(self.label1)
        make.top.equalTo(self.label2.snp.bottom).offset(30)
    }),
    
    /// 垂直排列的UIStackView 
    VStackView.qbody([
        btn1,
        btn2,
        btn3
    ]).qmakeConstraints({ make in
        make.left.right.equalToSuperview()
        make.top.equalTo(self.label3.snp.bottom).offset(50)
    }).qspacing(15),
   
    /// 也可以直接使用数组 :[UIView], qjoined()方法，将直接组合生成一个UIStackView
//            [btn1, btn2, btn3].qjoined(aixs: .vertical, spacing: 15, align: .fill, distribution: .equalSpacing)
//                .qmakeConstraints({ make in
//                    make.left.right.equalToSuperview()
//                    make.top.equalTo(self.label3.snp.bottom).offset(50)
//                })
])
```
而像这样之后，一眼就知道label1、label2、label3 属于self.view，以及清楚他们的约束情况

也知道btn1、btn2、btn3组成了一个垂直排列的stackView，放在self.view

这样在后期维护的时候，如果要调整UI，就不用花太多时间去理清原本的UI的逻辑


# 题外二

之后就想着把tableview cocllectionView scrollView的一些delegate dataSource方法，通过block的方式能快速写出来

在然后就一些动画、拖拽手势、额外的size、contentsize、contentoffset、deinit、vc的pop、高斯模糊、view的渐变色等等就慢慢也搞出来 



