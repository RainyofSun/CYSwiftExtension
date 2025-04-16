//
//  APPWebControllerScriptHandler.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/4/16.
//

import UIKit
import WebKit

public class APPWebControllerScriptHandler: NSObject {
    //MARK:- 属性设置 之前这个属性没有用weak修饰,所以一直持有,无法释放
    private weak var scriptHandler: WKScriptMessageHandler!
    
    //MARK:- 初始化
    convenience public init(weakScriptHandler handler: WKScriptMessageHandler) {
        self.init()
        self.scriptHandler = handler
    }
    
    deinit {
        print("DELLOC --- APPWebControllerScriptHandler")
    }
}

extension APPWebControllerScriptHandler: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptHandler.userContentController(userContentController, didReceive: message)
    }
}
