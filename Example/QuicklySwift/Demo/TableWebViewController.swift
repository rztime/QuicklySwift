//
//  TableWebViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2025/8/12.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import WebKit

class TableWebViewController: UIViewController {
    let tableView = UITableView(frame: .qfull, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var html = html
        self.view.qbody([
            tableView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        let btn = UIButton(type: .system).qtitle("测试")
            .qtap { [weak self] view in
                let y = self?.tableView.contentOffset.y ?? 0
                self?.tableView.setContentOffset(.init(x: 0, y: y + 100), animated: true)
            }
        self.navigationItem.rightBarButtonItem = .init(customView: btn)
        tableView
            .qregister(UITableViewCell.self, identifier: "cell")
            .qregister(WebCell.self, identifier: "web")
            .qnumberofRows { section in
                return 10
            }
            .qcell { [weak self] tableView, indexPath in
                if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "web") as! WebCell
                    cell.targetView = self?.view
                    cell.tableView = tableView
                    cell.html = html
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = """
.qregister(UITableViewCell.self, identifier: "cell")
.qregister(WebCell.self, identifier: "web")
.qnumberofRows { section in
    return 3
}
"""
                cell.textLabel?.numberOfLines = 0
                return cell
            }
            .qwillDisplayCell { cell, indexPath in
                print("---- disp:\(indexPath.row)")
            }
            .qdidEndDisplayCell { cell, indexPath in
                print("---end disp: \(indexPath.row)")
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class WebCell: UITableViewCell {
    let webView = WKWebView.init(frame: .qfull)
    weak var targetView: UIView? {
        didSet {
            if let t = targetView {
                webView.frame = t.frame
            }
        }
    }
    let obj = NSObject()
    weak var tableView: UITableView?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.qbody([webView])
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.layer.masksToBounds = false
        var pre: CGFloat = 100
        self.contentView.snp.makeConstraints { make in
            make.height.equalTo(pre)
        }
        webView.scrollView.qcontentSizeChanged { [weak self] v in
            let height = max(v.contentSize.height, 100)
            if pre == height { return }
            pre = height
            self?.contentView.snp.updateConstraints({ make in
                make.height.equalTo(height)
            })
            self?.tableView?.beginUpdates()
            self?.tableView?.endUpdates()
        }
        webView.qshowToWindow { webView, show in
            print("---- show:\(show)")
        }
        obj.qdeinit {
            print("--- obj deinit")
        }
        var x = 0
        CADisplayLink.qinit(target: obj, runloop: .main, mode: .tracking, timesForSecond: 10) { [weak self] _ in
            x += 1
            print("-------x \(x)")
            self?.update()
        }
        var y = 0
        CADisplayLink.qinit(target: obj, runloop: .main, mode: .default, timesForSecond: 3) { [weak self] _ in
            y += 1
            print("-------y \(y)")
            self?.update()
        }
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print("--------didMoveToWindow")
    }
    deinit {
        print("----- web cell deinit")
    }
    func update() {
        guard let v = self.targetView else { return }
        let frame = self.contentView.convert(self.contentView.bounds, to: v)
        var y = -frame.origin.y
        if y < 0 { y = 0 }
        if y + self.webView.frame.size.height > self.contentView.frame.height {
            y = self.contentView.frame.height - self.webView.frame.size.height
        }
        if y != self.webView.frame.origin.y {
            self.webView.qy(y)
            self.webView.scrollView.contentOffset.y = y
        }
    }
    var html: String? {
        willSet {
            if newValue == html {
                return
            }
            webView.loadHTMLString(newValue ?? "", baseURL: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let html = """
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">新华社成都8月11日电 “‘划水’？平时咱工作的时候‘划水’不够多吗，还要专门去看别人‘划水’？”当成都市民陶楷被朋友邀请一起去看世运会滑水比赛时，他打趣道。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">而当他来到赛场的观众席坐下，开始观看比赛后，眼前的景象让他震撼。摩托艇风驰电掣掠过水面，激起层层浪花，运动员脚踏滑水板在浪尖闪转腾挪，做出各种炫酷的转体动作，引得阵阵欢呼。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956849978050413.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，日本选手手塚翔太在2025年成都世运会男子尾波滑水自由式比赛中。新华社记者 陈振海 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“第一次看滑水，真是不虚此行。感觉就像冲浪和滑板的结合，太刺激太有趣了！”陶楷对记者说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">随着成都世运会的进行，很多原本鲜为人知的小众运动项目，逐渐走入中国民众的视野。“新鲜感”“第一次”成为记者走访过程中，观众提及最多的关键词。这些小众项目为观众带来刺激感和乐趣的同时，也成为大家了解体育运动多样性和世界各地不同文化的窗口。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">天府公园的浮士德球比赛现场，成都浮士德球队队员金冬俨然成为“形象大使”，他一直在跟周围观众介绍这项自带“文艺范”的运动。“浮士德球又叫拳球或草地排球，名称源自德国作家歌德的作品《浮士德》。这个项目在德国、奥地利、瑞士等德语地区较为流行。现在我们所在的场地，就是中国大陆的第一块标准的浮士德球赛场。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">看到不少观众流露出好奇和认可，成都浮士德球队主教练冯诚感慨道：“世运会让更多中国民众知道浮士德球。多样性本就是体育文化的特征之一，中国民众乐于拥抱新事物，对新鲜运动的接受力很强。更多项目意味着更多种健身选择和更丰富的生活方式。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">采访过程中，不少业内人士对记者说，世运会的小众项目中，部分受自身特点所限，着重于观赏和展示。而有些项目源自公众认可度较高的大众项目，同时兼具易上手、有趣、社交性强等特征，有望大范围推广，成为推进全民健身的重要载体。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850343014412.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，中国队球员张志恒（前）在比赛中带球进攻。当日，在2025年成都世运会软式曲棍球男子B组预赛中，中国队不敌加拿大队。新华社记者 梁旭 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“张志恒加油，张志恒加油！”在软式曲棍球比赛的观众席，一群小朋友打着横幅，为中国软式曲棍球队队员张志恒呐喊助威。“张志恒是这群小朋友的教练，我们专门从上海赶来，为张志恒、为中国队加油。”上海奥斯俱乐部教练陈小佳说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">中国软式曲棍球队助理教练商亮宇说：“这项运动结合了速度与技巧。而其独特的魅力在于，不同于传统曲棍球运动对场地和装备要求较高，软式曲棍球只需一球、一杆，任何空地都能成为球场，立即就能展开一场紧张刺激的比赛。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">陈小佳说，软式曲棍球可锻炼身体协调性和协作意识，越来越多孩子开始接触这个项目。“软式曲棍球还带有很强的社交属性。孩子们不仅可以打球，还能交到一群朋友，这对他们身心健康成长颇有助益。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">不只是滑水、浮士德球和软式曲棍球，“好看”“好玩”的小众项目通过世运会举行的契机进行展示和推广的过程中，也在潜移默化间影响着中国民众对体育的认识。民众在观看、了解和尝试这些小众运动项目的同时，对体育有了更广维度和更深层次了解，也对项目的未来发展抱有新期待，体育的多元价值持续释放。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">沙滩手球比赛期间，观众席上的小学生杨彦池神情激动。她一边观看运动员的精彩表现，一边对自己的教练、成都市新都区石犀小学校体育老师李锋说：“将来我能跟场上的大哥哥大姐姐一样，为国争光吗？”</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850558071514.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月11日，中国队球员任健豪（上）在比赛中进攻。当日，在2025年成都世运会沙滩手球男子第5-8名安慰赛半决赛中，中国队0比2不敌丹麦队。新华社记者 刘坤 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">据李锋介绍，学校自2021年开始将手球作为推广项目以来，成效颇丰。“学校设有手球特色课程，有手球运动社团。校队在全国手球U系列比赛中也取得良好成绩。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">2024年，李锋和孩子们开始接触沙滩手球。“沙滩手球的场地松软，运动过程中不易受伤，而且规则相对宽松，孩子们自由发挥的空间大，他们对沙滩手球兴趣浓厚。”李锋说，他还带孩子们参加了成都世运会项目推广组沙滩手球比赛，学校的球队分别获得U9组和U12组的亚军和季军。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">李锋对沙滩手球的未来发展有更多期待：“现在制约沙滩手球发展的主要因素是场地较少。孩子们之前只能在个别沙滩排球场地进行沙滩手球训练。希望借世运会的契机，各方共同努力，建设更多沙滩场地，将沙滩手球运动介绍给更多民众。”</p>
<p class="formatted" style="text-align: justify; line-height: 1.875rem; margin-bottom: 1.875rem; font-size: 1.1875rem;">业内专家指出，随着社会、经济的发展，中国大众对于不同类型的体育项目接受程度越来越高，十几二十年前的一些小众项目如骑行、马拉松、高尔夫、霹雳舞、攀岩等，已经为大众所接受，这就是现在世运会一些项目发展的前景，而这也是一个必然的过程。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">新华社成都8月11日电 “‘划水’？平时咱工作的时候‘划水’不够多吗，还要专门去看别人‘划水’？”当成都市民陶楷被朋友邀请一起去看世运会滑水比赛时，他打趣道。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">而当他来到赛场的观众席坐下，开始观看比赛后，眼前的景象让他震撼。摩托艇风驰电掣掠过水面，激起层层浪花，运动员脚踏滑水板在浪尖闪转腾挪，做出各种炫酷的转体动作，引得阵阵欢呼。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956849978050413.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，日本选手手塚翔太在2025年成都世运会男子尾波滑水自由式比赛中。新华社记者 陈振海 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“第一次看滑水，真是不虚此行。感觉就像冲浪和滑板的结合，太刺激太有趣了！”陶楷对记者说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">随着成都世运会的进行，很多原本鲜为人知的小众运动项目，逐渐走入中国民众的视野。“新鲜感”“第一次”成为记者走访过程中，观众提及最多的关键词。这些小众项目为观众带来刺激感和乐趣的同时，也成为大家了解体育运动多样性和世界各地不同文化的窗口。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">天府公园的浮士德球比赛现场，成都浮士德球队队员金冬俨然成为“形象大使”，他一直在跟周围观众介绍这项自带“文艺范”的运动。“浮士德球又叫拳球或草地排球，名称源自德国作家歌德的作品《浮士德》。这个项目在德国、奥地利、瑞士等德语地区较为流行。现在我们所在的场地，就是中国大陆的第一块标准的浮士德球赛场。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">看到不少观众流露出好奇和认可，成都浮士德球队主教练冯诚感慨道：“世运会让更多中国民众知道浮士德球。多样性本就是体育文化的特征之一，中国民众乐于拥抱新事物，对新鲜运动的接受力很强。更多项目意味着更多种健身选择和更丰富的生活方式。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">采访过程中，不少业内人士对记者说，世运会的小众项目中，部分受自身特点所限，着重于观赏和展示。而有些项目源自公众认可度较高的大众项目，同时兼具易上手、有趣、社交性强等特征，有望大范围推广，成为推进全民健身的重要载体。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850343014412.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，中国队球员张志恒（前）在比赛中带球进攻。当日，在2025年成都世运会软式曲棍球男子B组预赛中，中国队不敌加拿大队。新华社记者 梁旭 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“张志恒加油，张志恒加油！”在软式曲棍球比赛的观众席，一群小朋友打着横幅，为中国软式曲棍球队队员张志恒呐喊助威。“张志恒是这群小朋友的教练，我们专门从上海赶来，为张志恒、为中国队加油。”上海奥斯俱乐部教练陈小佳说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">中国软式曲棍球队助理教练商亮宇说：“这项运动结合了速度与技巧。而其独特的魅力在于，不同于传统曲棍球运动对场地和装备要求较高，软式曲棍球只需一球、一杆，任何空地都能成为球场，立即就能展开一场紧张刺激的比赛。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">陈小佳说，软式曲棍球可锻炼身体协调性和协作意识，越来越多孩子开始接触这个项目。“软式曲棍球还带有很强的社交属性。孩子们不仅可以打球，还能交到一群朋友，这对他们身心健康成长颇有助益。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">不只是滑水、浮士德球和软式曲棍球，“好看”“好玩”的小众项目通过世运会举行的契机进行展示和推广的过程中，也在潜移默化间影响着中国民众对体育的认识。民众在观看、了解和尝试这些小众运动项目的同时，对体育有了更广维度和更深层次了解，也对项目的未来发展抱有新期待，体育的多元价值持续释放。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">沙滩手球比赛期间，观众席上的小学生杨彦池神情激动。她一边观看运动员的精彩表现，一边对自己的教练、成都市新都区石犀小学校体育老师李锋说：“将来我能跟场上的大哥哥大姐姐一样，为国争光吗？”</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850558071514.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月11日，中国队球员任健豪（上）在比赛中进攻。当日，在2025年成都世运会沙滩手球男子第5-8名安慰赛半决赛中，中国队0比2不敌丹麦队。新华社记者 刘坤 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">据李锋介绍，学校自2021年开始将手球作为推广项目以来，成效颇丰。“学校设有手球特色课程，有手球运动社团。校队在全国手球U系列比赛中也取得良好成绩。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">2024年，李锋和孩子们开始接触沙滩手球。“沙滩手球的场地松软，运动过程中不易受伤，而且规则相对宽松，孩子们自由发挥的空间大，他们对沙滩手球兴趣浓厚。”李锋说，他还带孩子们参加了成都世运会项目推广组沙滩手球比赛，学校的球队分别获得U9组和U12组的亚军和季军。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">李锋对沙滩手球的未来发展有更多期待：“现在制约沙滩手球发展的主要因素是场地较少。孩子们之前只能在个别沙滩排球场地进行沙滩手球训练。希望借世运会的契机，各方共同努力，建设更多沙滩场地，将沙滩手球运动介绍给更多民众。”</p>
<p class="formatted" style="text-align: justify; line-height: 1.875rem; margin-bottom: 1.875rem; font-size: 1.1875rem;">业内专家指出，随着社会、经济的发展，中国大众对于不同类型的体育项目接受程度越来越高，十几二十年前的一些小众项目如骑行、马拉松、高尔夫、霹雳舞、攀岩等，已经为大众所接受，这就是现在世运会一些项目发展的前景，而这也是一个必然的过程。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">新华社成都8月11日电 “‘划水’？平时咱工作的时候‘划水’不够多吗，还要专门去看别人‘划水’？”当成都市民陶楷被朋友邀请一起去看世运会滑水比赛时，他打趣道。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">而当他来到赛场的观众席坐下，开始观看比赛后，眼前的景象让他震撼。摩托艇风驰电掣掠过水面，激起层层浪花，运动员脚踏滑水板在浪尖闪转腾挪，做出各种炫酷的转体动作，引得阵阵欢呼。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956849978050413.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，日本选手手塚翔太在2025年成都世运会男子尾波滑水自由式比赛中。新华社记者 陈振海 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“第一次看滑水，真是不虚此行。感觉就像冲浪和滑板的结合，太刺激太有趣了！”陶楷对记者说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">随着成都世运会的进行，很多原本鲜为人知的小众运动项目，逐渐走入中国民众的视野。“新鲜感”“第一次”成为记者走访过程中，观众提及最多的关键词。这些小众项目为观众带来刺激感和乐趣的同时，也成为大家了解体育运动多样性和世界各地不同文化的窗口。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">天府公园的浮士德球比赛现场，成都浮士德球队队员金冬俨然成为“形象大使”，他一直在跟周围观众介绍这项自带“文艺范”的运动。“浮士德球又叫拳球或草地排球，名称源自德国作家歌德的作品《浮士德》。这个项目在德国、奥地利、瑞士等德语地区较为流行。现在我们所在的场地，就是中国大陆的第一块标准的浮士德球赛场。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">看到不少观众流露出好奇和认可，成都浮士德球队主教练冯诚感慨道：“世运会让更多中国民众知道浮士德球。多样性本就是体育文化的特征之一，中国民众乐于拥抱新事物，对新鲜运动的接受力很强。更多项目意味着更多种健身选择和更丰富的生活方式。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">采访过程中，不少业内人士对记者说，世运会的小众项目中，部分受自身特点所限，着重于观赏和展示。而有些项目源自公众认可度较高的大众项目，同时兼具易上手、有趣、社交性强等特征，有望大范围推广，成为推进全民健身的重要载体。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850343014412.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，中国队球员张志恒（前）在比赛中带球进攻。当日，在2025年成都世运会软式曲棍球男子B组预赛中，中国队不敌加拿大队。新华社记者 梁旭 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“张志恒加油，张志恒加油！”在软式曲棍球比赛的观众席，一群小朋友打着横幅，为中国软式曲棍球队队员张志恒呐喊助威。“张志恒是这群小朋友的教练，我们专门从上海赶来，为张志恒、为中国队加油。”上海奥斯俱乐部教练陈小佳说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">中国软式曲棍球队助理教练商亮宇说：“这项运动结合了速度与技巧。而其独特的魅力在于，不同于传统曲棍球运动对场地和装备要求较高，软式曲棍球只需一球、一杆，任何空地都能成为球场，立即就能展开一场紧张刺激的比赛。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">陈小佳说，软式曲棍球可锻炼身体协调性和协作意识，越来越多孩子开始接触这个项目。“软式曲棍球还带有很强的社交属性。孩子们不仅可以打球，还能交到一群朋友，这对他们身心健康成长颇有助益。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">不只是滑水、浮士德球和软式曲棍球，“好看”“好玩”的小众项目通过世运会举行的契机进行展示和推广的过程中，也在潜移默化间影响着中国民众对体育的认识。民众在观看、了解和尝试这些小众运动项目的同时，对体育有了更广维度和更深层次了解，也对项目的未来发展抱有新期待，体育的多元价值持续释放。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">沙滩手球比赛期间，观众席上的小学生杨彦池神情激动。她一边观看运动员的精彩表现，一边对自己的教练、成都市新都区石犀小学校体育老师李锋说：“将来我能跟场上的大哥哥大姐姐一样，为国争光吗？”</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850558071514.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月11日，中国队球员任健豪（上）在比赛中进攻。当日，在2025年成都世运会沙滩手球男子第5-8名安慰赛半决赛中，中国队0比2不敌丹麦队。新华社记者 刘坤 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">据李锋介绍，学校自2021年开始将手球作为推广项目以来，成效颇丰。“学校设有手球特色课程，有手球运动社团。校队在全国手球U系列比赛中也取得良好成绩。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">2024年，李锋和孩子们开始接触沙滩手球。“沙滩手球的场地松软，运动过程中不易受伤，而且规则相对宽松，孩子们自由发挥的空间大，他们对沙滩手球兴趣浓厚。”李锋说，他还带孩子们参加了成都世运会项目推广组沙滩手球比赛，学校的球队分别获得U9组和U12组的亚军和季军。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">李锋对沙滩手球的未来发展有更多期待：“现在制约沙滩手球发展的主要因素是场地较少。孩子们之前只能在个别沙滩排球场地进行沙滩手球训练。希望借世运会的契机，各方共同努力，建设更多沙滩场地，将沙滩手球运动介绍给更多民众。”</p>
<p class="formatted" style="text-align: justify; line-height: 1.875rem; margin-bottom: 1.875rem; font-size: 1.1875rem;">业内专家指出，随着社会、经济的发展，中国大众对于不同类型的体育项目接受程度越来越高，十几二十年前的一些小众项目如骑行、马拉松、高尔夫、霹雳舞、攀岩等，已经为大众所接受，这就是现在世运会一些项目发展的前景，而这也是一个必然的过程。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">新华社成都8月11日电 “‘划水’？平时咱工作的时候‘划水’不够多吗，还要专门去看别人‘划水’？”当成都市民陶楷被朋友邀请一起去看世运会滑水比赛时，他打趣道。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">而当他来到赛场的观众席坐下，开始观看比赛后，眼前的景象让他震撼。摩托艇风驰电掣掠过水面，激起层层浪花，运动员脚踏滑水板在浪尖闪转腾挪，做出各种炫酷的转体动作，引得阵阵欢呼。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956849978050413.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，日本选手手塚翔太在2025年成都世运会男子尾波滑水自由式比赛中。新华社记者 陈振海 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“第一次看滑水，真是不虚此行。感觉就像冲浪和滑板的结合，太刺激太有趣了！”陶楷对记者说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">随着成都世运会的进行，很多原本鲜为人知的小众运动项目，逐渐走入中国民众的视野。“新鲜感”“第一次”成为记者走访过程中，观众提及最多的关键词。这些小众项目为观众带来刺激感和乐趣的同时，也成为大家了解体育运动多样性和世界各地不同文化的窗口。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">天府公园的浮士德球比赛现场，成都浮士德球队队员金冬俨然成为“形象大使”，他一直在跟周围观众介绍这项自带“文艺范”的运动。“浮士德球又叫拳球或草地排球，名称源自德国作家歌德的作品《浮士德》。这个项目在德国、奥地利、瑞士等德语地区较为流行。现在我们所在的场地，就是中国大陆的第一块标准的浮士德球赛场。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">看到不少观众流露出好奇和认可，成都浮士德球队主教练冯诚感慨道：“世运会让更多中国民众知道浮士德球。多样性本就是体育文化的特征之一，中国民众乐于拥抱新事物，对新鲜运动的接受力很强。更多项目意味着更多种健身选择和更丰富的生活方式。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">采访过程中，不少业内人士对记者说，世运会的小众项目中，部分受自身特点所限，着重于观赏和展示。而有些项目源自公众认可度较高的大众项目，同时兼具易上手、有趣、社交性强等特征，有望大范围推广，成为推进全民健身的重要载体。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850343014412.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，中国队球员张志恒（前）在比赛中带球进攻。当日，在2025年成都世运会软式曲棍球男子B组预赛中，中国队不敌加拿大队。新华社记者 梁旭 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“张志恒加油，张志恒加油！”在软式曲棍球比赛的观众席，一群小朋友打着横幅，为中国软式曲棍球队队员张志恒呐喊助威。“张志恒是这群小朋友的教练，我们专门从上海赶来，为张志恒、为中国队加油。”上海奥斯俱乐部教练陈小佳说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">中国软式曲棍球队助理教练商亮宇说：“这项运动结合了速度与技巧。而其独特的魅力在于，不同于传统曲棍球运动对场地和装备要求较高，软式曲棍球只需一球、一杆，任何空地都能成为球场，立即就能展开一场紧张刺激的比赛。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">陈小佳说，软式曲棍球可锻炼身体协调性和协作意识，越来越多孩子开始接触这个项目。“软式曲棍球还带有很强的社交属性。孩子们不仅可以打球，还能交到一群朋友，这对他们身心健康成长颇有助益。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">不只是滑水、浮士德球和软式曲棍球，“好看”“好玩”的小众项目通过世运会举行的契机进行展示和推广的过程中，也在潜移默化间影响着中国民众对体育的认识。民众在观看、了解和尝试这些小众运动项目的同时，对体育有了更广维度和更深层次了解，也对项目的未来发展抱有新期待，体育的多元价值持续释放。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">沙滩手球比赛期间，观众席上的小学生杨彦池神情激动。她一边观看运动员的精彩表现，一边对自己的教练、成都市新都区石犀小学校体育老师李锋说：“将来我能跟场上的大哥哥大姐姐一样，为国争光吗？”</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850558071514.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月11日，中国队球员任健豪（上）在比赛中进攻。当日，在2025年成都世运会沙滩手球男子第5-8名安慰赛半决赛中，中国队0比2不敌丹麦队。新华社记者 刘坤 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">据李锋介绍，学校自2021年开始将手球作为推广项目以来，成效颇丰。“学校设有手球特色课程，有手球运动社团。校队在全国手球U系列比赛中也取得良好成绩。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">2024年，李锋和孩子们开始接触沙滩手球。“沙滩手球的场地松软，运动过程中不易受伤，而且规则相对宽松，孩子们自由发挥的空间大，他们对沙滩手球兴趣浓厚。”李锋说，他还带孩子们参加了成都世运会项目推广组沙滩手球比赛，学校的球队分别获得U9组和U12组的亚军和季军。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">李锋对沙滩手球的未来发展有更多期待：“现在制约沙滩手球发展的主要因素是场地较少。孩子们之前只能在个别沙滩排球场地进行沙滩手球训练。希望借世运会的契机，各方共同努力，建设更多沙滩场地，将沙滩手球运动介绍给更多民众。”</p>
<p class="formatted" style="text-align: justify; line-height: 1.875rem; margin-bottom: 1.875rem; font-size: 1.1875rem;">业内专家指出，随着社会、经济的发展，中国大众对于不同类型的体育项目接受程度越来越高，十几二十年前的一些小众项目如骑行、马拉松、高尔夫、霹雳舞、攀岩等，已经为大众所接受，这就是现在世运会一些项目发展的前景，而这也是一个必然的过程。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">新华社成都8月11日电 “‘划水’？平时咱工作的时候‘划水’不够多吗，还要专门去看别人‘划水’？”当成都市民陶楷被朋友邀请一起去看世运会滑水比赛时，他打趣道。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">而当他来到赛场的观众席坐下，开始观看比赛后，眼前的景象让他震撼。摩托艇风驰电掣掠过水面，激起层层浪花，运动员脚踏滑水板在浪尖闪转腾挪，做出各种炫酷的转体动作，引得阵阵欢呼。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956849978050413.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，日本选手手塚翔太在2025年成都世运会男子尾波滑水自由式比赛中。新华社记者 陈振海 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“第一次看滑水，真是不虚此行。感觉就像冲浪和滑板的结合，太刺激太有趣了！”陶楷对记者说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">随着成都世运会的进行，很多原本鲜为人知的小众运动项目，逐渐走入中国民众的视野。“新鲜感”“第一次”成为记者走访过程中，观众提及最多的关键词。这些小众项目为观众带来刺激感和乐趣的同时，也成为大家了解体育运动多样性和世界各地不同文化的窗口。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">天府公园的浮士德球比赛现场，成都浮士德球队队员金冬俨然成为“形象大使”，他一直在跟周围观众介绍这项自带“文艺范”的运动。“浮士德球又叫拳球或草地排球，名称源自德国作家歌德的作品《浮士德》。这个项目在德国、奥地利、瑞士等德语地区较为流行。现在我们所在的场地，就是中国大陆的第一块标准的浮士德球赛场。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">看到不少观众流露出好奇和认可，成都浮士德球队主教练冯诚感慨道：“世运会让更多中国民众知道浮士德球。多样性本就是体育文化的特征之一，中国民众乐于拥抱新事物，对新鲜运动的接受力很强。更多项目意味着更多种健身选择和更丰富的生活方式。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">采访过程中，不少业内人士对记者说，世运会的小众项目中，部分受自身特点所限，着重于观赏和展示。而有些项目源自公众认可度较高的大众项目，同时兼具易上手、有趣、社交性强等特征，有望大范围推广，成为推进全民健身的重要载体。</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850343014412.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月10日，中国队球员张志恒（前）在比赛中带球进攻。当日，在2025年成都世运会软式曲棍球男子B组预赛中，中国队不敌加拿大队。新华社记者 梁旭 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">“张志恒加油，张志恒加油！”在软式曲棍球比赛的观众席，一群小朋友打着横幅，为中国软式曲棍球队队员张志恒呐喊助威。“张志恒是这群小朋友的教练，我们专门从上海赶来，为张志恒、为中国队加油。”上海奥斯俱乐部教练陈小佳说。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">中国软式曲棍球队助理教练商亮宇说：“这项运动结合了速度与技巧。而其独特的魅力在于，不同于传统曲棍球运动对场地和装备要求较高，软式曲棍球只需一球、一杆，任何空地都能成为球场，立即就能展开一场紧张刺激的比赛。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">陈小佳说，软式曲棍球可锻炼身体协调性和协作意识，越来越多孩子开始接触这个项目。“软式曲棍球还带有很强的社交属性。孩子们不仅可以打球，还能交到一群朋友，这对他们身心健康成长颇有助益。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">不只是滑水、浮士德球和软式曲棍球，“好看”“好玩”的小众项目通过世运会举行的契机进行展示和推广的过程中，也在潜移默化间影响着中国民众对体育的认识。民众在观看、了解和尝试这些小众运动项目的同时，对体育有了更广维度和更深层次了解，也对项目的未来发展抱有新期待，体育的多元价值持续释放。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">沙滩手球比赛期间，观众席上的小学生杨彦池神情激动。她一边观看运动员的精彩表现，一边对自己的教练、成都市新都区石犀小学校体育老师李锋说：“将来我能跟场上的大哥哥大姐姐一样，为国争光吗？”</p>
<p class="formatted" style="text-align:center;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem"><img src="https://imgcdn.thecover.cn/@/catchimages/20250812/1754956850558071514.jpg?imageMogr2/auto-orient/thumbnail/1080x>/strip/quality/95/ignore-error/1|imageslim"/></p>
<p class="formatted" style="text-align: left; line-height: 1.875rem; margin-bottom: 1rem; font-size: 1.1875rem; margin-top: -1.875rem;"><span style="font-size: 0.9375rem; color: rgb(127, 127, 127);" class="img-desc fm-img-desc">8月11日，中国队球员任健豪（上）在比赛中进攻。当日，在2025年成都世运会沙滩手球男子第5-8名安慰赛半决赛中，中国队0比2不敌丹麦队。新华社记者 刘坤 摄</span></p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">据李锋介绍，学校自2021年开始将手球作为推广项目以来，成效颇丰。“学校设有手球特色课程，有手球运动社团。校队在全国手球U系列比赛中也取得良好成绩。”</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">2024年，李锋和孩子们开始接触沙滩手球。“沙滩手球的场地松软，运动过程中不易受伤，而且规则相对宽松，孩子们自由发挥的空间大，他们对沙滩手球兴趣浓厚。”李锋说，他还带孩子们参加了成都世运会项目推广组沙滩手球比赛，学校的球队分别获得U9组和U12组的亚军和季军。</p>
<p class="formatted" style="text-align:justify;line-height:1.875rem;margin-bottom:1.875rem;font-size:1.1875rem">李锋对沙滩手球的未来发展有更多期待：“现在制约沙滩手球发展的主要因素是场地较少。孩子们之前只能在个别沙滩排球场地进行沙滩手球训练。希望借世运会的契机，各方共同努力，建设更多沙滩场地，将沙滩手球运动介绍给更多民众。”</p>
<p class="formatted" style="text-align: justify; line-height: 1.875rem; margin-bottom: 1.875rem; font-size: 1.1875rem;">业内专家指出，随着社会、经济的发展，中国大众对于不同类型的体育项目接受程度越来越高，十几二十年前的一些小众项目如骑行、马拉松、高尔夫、霹雳舞、攀岩等，已经为大众所接受，这就是现在世运会一些项目发展的前景，而这也是一个必然的过程。</p>
"""
