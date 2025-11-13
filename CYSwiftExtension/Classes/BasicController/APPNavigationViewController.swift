//
//  APPNavigationViewController.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/9/16.
//

import UIKit
import JKSwiftExtension

public protocol AutoHiddenNavigationBar where Self: UIViewController {
    
}

open class APPNavigationViewController: UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.buildNavigation()
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !self.children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            
        }
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        super.pushViewController(viewController, animated: animated)
    }
    
    ///  当前控制器是否可以 pop 返回 默认不可以
    open func viewControllerShouldPop() -> Bool {
        return false
    }
    
    open func navigationAppearanceSetting() {
//        let appearance = UINavigationBarAppearance()
//        let att = [NSAttributedString.Key.foregroundColor: UIColor.hexStringColor(hexString: "#27272E"),
//                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
//        let originalImage = UIImage(systemName: "chevron.backward")
//        let tintedImage = originalImage?.withTintColor(UIColor.hexStringColor(hexString: "#27272E"), renderingMode: .alwaysOriginal)
//        appearance.configureWithOpaqueBackground() // 关键：不透明背景
//        appearance.backgroundColor = .white        // 设置背景色
//        appearance.shadowColor = .clear
//        
//        self.navigationBar.standardAppearance = appearance
//        self.navigationBar.scrollEdgeAppearance = appearance
//        self.navigationBar.compactAppearance = appearance
//        self.navigationBar.tintColor = UIColor.hexStringColor(hexString: "#27272E")
//        self.navigationBar.backIndicatorImage = tintedImage
//        self.navigationBar.backIndicatorTransitionMaskImage = tintedImage
//        self.navigationBar.shadowImage = barShadowImage()
//        self.navigationBar.titleTextAttributes = att
        
        UINavigationBar.applyGlobalStyle(Style.opaque(backgroundColor: UIColor.white, titleColor: UIColor.hexStringColor(hexString: "#27272E"), font: UIFont.systemFont(ofSize: 18)))
    }
    
    open func buildNavigation() {
        
    }
}

extension APPNavigationViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is AutoHiddenNavigationBar {
            self.setNavigationBarHidden(true, animated: true)
        } else {
            self.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension APPNavigationViewController: UINavigationBarDelegate {
    open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return self.viewControllerShouldPop()
    }
}
