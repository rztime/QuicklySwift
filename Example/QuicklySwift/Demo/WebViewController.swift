//
//  WebViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2025/3/10.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import QuicklySwift

class WebViewController: UIViewController {
    let progressLabel = UILabel().qfont(.systemFont(ofSize: 20)).qtextColor(.red)
    let obj = NSObject()
    var webView = WKWebView.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.qbody([
            webView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }),
            progressLabel.qmakeConstraints({ make in
                make.center.equalToSuperview()
            })
        ])
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        webView
        .qdecidePolicyForNavigationActionDecisionHandler({ webView, navAction, completionHandler in
                completionHandler(.allow)
            })
            .qdidReceiveChallengeCompletionHandler({ webView, chanllenge, completionHandler in
                completionHandler(.performDefaultHandling, nil)
            })
            .qdidFinish { webView, nav in
                print("--- finish")
                webView.qgetOuterHtml { html, error in
                    print("----- 全文 outer html:\(html ?? "")")
                }
//                webView.qgetOuterHtml(elementSelector: "div") { html, error in
//                    print("----- div outer html:\(html ?? "")")
//                }
//                webView.qgetInnerText { text, error in
//                    print("----- 全文 text:\(text ?? "")")
//                }
//                webView.qgetInnerText(elementSelector: "div#divid") { text, error in
//                    print("----- div text:\(text ?? "")")
//                }
//                webView.qgetInnerText(elementSelector: "div.divclass") { text, error in
//                    print("----- div text:\(text ?? "")")
//                }
            }
            .qdidFailWithError { webView, nav, error in
                print("--- fail: \(error)")
            }
            .qdidFailProvisionalNavigationWithError { webView, nav, error in
                print("---- fail nav:\(error)")
            }
            // 加桥
            .qaddJSMessage("nativeBridge")
            // 加桥后，收到消息的回调
            .qdidReceiveJSMessage { controller, message in
                if message.name == "nativeBridge" {
                    print("js: \(message.body)")
                }
            }
            .qwebViewDidClose({ webView in
                print("---- did close")
            })
            .qrunJavaScriptAlertPanelWithMessageInitiatedByFrameCompletionHandler { webView, message, frame, complete in
                UIAlertController.qwith(title: webView.title, message, actions: ["确定"]) { index in
                    complete()
                }
            }
            .qrunJavaScriptConfirmPanelWithMessageInitiatedByFrameCompletionHandler { webView, message, frame, complete in
                UIAlertController.qwith(title: webView.title, message, actions: ["取消", "确定"]) { index in
                    if index == 1 {
                        complete(true)
                    } else {
                        complete(false)
                    }
                }
            }
            .qrunJavaScriptTextInputPanelWithPromptDefaultTextInitiatedByFrameCompletionHandler { webView, prompt, defaultText, frame, complete in
                var textField : UITextField?
                let vc = UIAlertController.qwith(title: webView.title, prompt, actions: ["取消", "确定"]) { index in
                    if index == 1 {
                        complete(textField?.text)
                    } else {
                        complete(nil)
                    }
                    textField = nil
                }
                vc.addTextField { t in
                    textField = t
                    t.placeholder = defaultText
                }
            }
        /// 进度监听
        webView.qestimatedProgressPublish?.subscribe({ [weak self] value in
            switch value {
            case .none:
                self?.progressLabel.text = "未加载"
            case .progress(let progress):
                self?.progressLabel.text = "加载中\(progress)"
            }
        }, disposebag: self.obj)
        /// 标题监听
        webView.qtitlePublish.subscribe({ [weak self] value in
            self?.title = value
        }, disposebag: self.obj)
        webView.loadHTMLString(JSHtml, baseURL: "https://www.baidu.com".qtoURL)
//        webView.qloadURL("http://www.baidu.com".qtoURL)
    }
}
let JSHtml = """
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="Content-Style-Type" content="text/css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>web 测试</title>
</head>
<body>
    <div id='divid'>文本测试<span style='color:red;'>测试文本</span>测试文本</div>
    <div id='divid1'>2文本测试<span style='color:red;'>2测试文本</span>2测试文本</div>
    <div class='divclass'>1文本测试<span style='color:red;'>1测试文本</span>1测试文本</div>

    <button style="font-size: 16px;" onclick="sendMessage()">发消息给原生</button>
    
    <button style="font-size: 16px;" onclick="alertAction()">alert()</button>

    <button style="font-size: 16px;" onclick="comfirmAction()">comfirm()</button>
    <button style="font-size: 16px;" onclick="promptAction()">prompt()</button>
    <button style="font-size: 16px;" onclick="closeAction()">close()</button>
 
  <button id="requestCameraButton">Request Camera</button>
  <button id="requestMicrophoneButton">Request Microphone</button>
    <button id="startCapture">Start Capture</button>
  <video id="cameraPreview" autoplay muted playsinline style="width: 320px; height: 240px; border: 1px solid black;">

    <script>
        function sendMessage() {
            // 发送消息给原生代码
            window.webkit.messageHandlers.nativeBridge.postMessage("Hello from JavaScript!");
        }
        function alertAction() {
            alert("alert action");
        }
        function comfirmAction() {
            var result = confirm("Are you sure?");
            if (result) {
                window.webkit.messageHandlers.nativeBridge.postMessage("select YES");
            } else {
                window.webkit.messageHandlers.nativeBridge.postMessage("select NO");
            }
        }
        function promptAction() {
            // 调用window.prompt()方法
            const userInput = prompt("Please enter your name:", "Default Name");
            if (userInput) {
                window.webkit.messageHandlers.nativeBridge.postMessage("User entered:" + userInput);
            } else {
                window.webkit.messageHandlers.nativeBridge.postMessage("User cancelled the prompt.");
            }
        }
        function closeAction() {
            window.close()
        }
    </script>
    <script>
    const cameraButton = document.getElementById('requestCameraButton');
    const microphoneButton = document.getElementById('requestMicrophoneButton');
    const cameraPreview = document.getElementById('cameraPreview');

    cameraButton.addEventListener('click', () => {
            window.webkit.messageHandlers.nativeBridge.postMessage("video click");
      navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
          cameraPreview.srcObject = stream;
        })
        .catch(error => {
          console.error('Error accessing camera:', error);
          alert('Error accessing camera: ' + error.message);
        });
    });

    microphoneButton.addEventListener('click', () => {
            window.webkit.messageHandlers.nativeBridge.postMessage("audio click");
      navigator.mediaDevices.getUserMedia({ audio: true })
        .then(stream => {
          console.log('Microphone access granted.');
          alert('Microphone access granted.'); // You could do something more useful with the stream here
        })
        .catch(error => {
            window.webkit.messageHandlers.nativeBridge.postMessage("audio error ");
          console.error('Error accessing microphone:', error);
          alert('Error accessing microphone: ' + error.message);
        });
    });
  document.getElementById('startCapture').addEventListener('click', async function() {
            try {
                const stream = await navigator.mediaDevices.getUserMedia({ video: true });
                const video = document.createElement('video');
                video.srcObject = stream;
                video.autoplay = true;
                document.body.appendChild(video);
            } catch (err) {
                console.error("Error accessing media devices.", err);
            }
        });
    </script>
</body>
</html>
"""
