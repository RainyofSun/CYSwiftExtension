//
//  APPWebController.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/4/16.
//

import UIKit
import WebKit
import JKSwiftExtension
import SnapKit

open class APPWebController: UIViewController {

    private var linkURL: String?
    private var gotoRoot: Bool = true
    private var webFuncName: [String] = []
    
    private lazy var webView: WKWebView = {
        let view = WKWebView(frame: CGRect.zero, configuration: self.setWebViewConfig())
        view.navigationDelegate = self // 导航代理
        view.allowsBackForwardNavigationGestures = true // 允许左滑返回
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var processBarView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.isHidden = true
        return view
    }()
    
    public init(withWebLinkURL url: String, backToRoot root: Bool = true, webFuncScriptHandler handlers: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.webFuncName.append(contentsOf: handlers)
        self.linkURL = url
        self.gotoRoot = root
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // 钩子方法
        self.hookMethodUI()
        self.hookMethodLayout()
        
        if let _url = self.linkURL, let _webURL = URL.init(string: _url) {
            self.webView.load(URLRequest.init(url: _webURL))
        }
    }
    
    /// 钩子方法 --- 子类覆写
    open func hookMethodUI() {
        self.view.backgroundColor = .white
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.processBarView)
    }
    
    open func hookMethodLayout() {
        self.processBarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(jk_kNavFrameH)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(2)
        }
        
        self.webView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.processBarView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    open func hookMethodWebFuncCallback(_ funcName: String, funcParams: [String]) {
        
    }
    
    open func setProcessBarTrackColor(_ trackColor: UIColor, tintColor: UIColor) {
        self.processBarView.trackTintColor = trackColor
        self.processBarView.tintColor = tintColor
    }
    
    public func webControllerCanPop() -> Bool {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.removeWebFuncObserver()
            if let _nav = self.navigationController {
                if _nav.children.count > 1 {
                    if self.gotoRoot {
                        _nav.popToRootViewController(animated: true)
                    } else {
                        _nav.popViewController(animated: true)
                    }
                } else {
                    if self.presentingViewController != nil {
                        self.navigationController?.dismiss(animated: true)
                    }
                }
            } else {
                self.dismiss(animated: true)
            }
        }
        
        return false
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("网页加载进度---\(webView.estimatedProgress)")
        if keyPath == "estimatedProgress" {
            DispatchQueue.main.async {
                let viewProgress = Float(self.webView.estimatedProgress)
                self.processBarView.setProgress(viewProgress, animated: true)
                if viewProgress >= 1.0 {
                    self.processBarView.progress = 0
                }
            }
        } else if keyPath == "title" {
            self.title = self.webView.title
        }
    }
}

extension APPWebController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.processBarView.isHidden = false
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.processBarView.isHidden = true
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.processBarView.isHidden = true
    }
}

// MARK: WKScriptMessageHandler
extension APPWebController: WKScriptMessageHandler {
    // 处理js传递的消息
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("接受到JS传递的消息：\(message.name) body = \(message.body)")
        self.hookMethodWebFuncCallback(message.name, funcParams: message.body as? [String] ?? [])
    }
}

private extension APPWebController {
    func setWebViewConfig() -> WKWebViewConfiguration {
        let preferences: WKPreferences = WKPreferences()
        preferences.minimumFontSize = 15
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let webConfig: WKWebViewConfiguration = WKWebViewConfiguration()
        webConfig.preferences = preferences
        webConfig.allowsInlineMediaPlayback = true
        webConfig.allowsPictureInPictureMediaPlayback = true
        webConfig.userContentController = self.buildUserContentController()
        
        return webConfig
    }
    
    func buildUserContentController() -> WKUserContentController {
        let _scriptHandler: APPWebControllerScriptHandler = APPWebControllerScriptHandler.init(weakScriptHandler: self)
        let _user_content: WKUserContentController = WKUserContentController()
        if !self.webFuncName.isEmpty {
            self.webFuncName.forEach { (funcName: String) in
                _user_content.add(_scriptHandler, name: funcName)
            }
        }
        return _user_content
    }
    
    func removeWebFuncObserver() {
        self.webView.configuration.userContentController.removeAllUserScripts()
        self.webView.configuration.userContentController.removeAllScriptMessageHandlers()
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "title")
    }
}
