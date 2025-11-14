//
//  APPBasicTabBarViewController.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/11/13.
//

import UIKit
import JKSwiftExtension

open class APPBasicTabBarViewController: UITabBarController {

    private(set) var custom_bar: APPBasicTabBar?
    private var vc_array: [UIViewController.Type] = []
    private var img_array: [[String]] = []
    private(set) var barHeight: CGFloat = jk_kTabbarFrameH + 10
    
    open override var selectedIndex: Int {
        didSet {
            self.custom_bar?.selectedBarItem(selectedIndex)
        }
    }
    
    public init(controllers vcArray: [UIViewController.Type], barImages images: [[String]]) {
        super.init(nibName: nil, bundle: nil)
        self.vc_array.append(contentsOf: vcArray)
        self.img_array.append(contentsOf: images)
        self.buildTabbarUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func changeBarColor(color: UIColor) {
        self.custom_bar?.backgroundColor = color
    }
    
    open func setTabControllerElements() {
        
        
    }
    
    open func currentBarItemCanSelected() -> Bool {
        return true
    }
    
    open func tabbarHookMethod() {
        
    }
}

private extension APPBasicTabBarViewController {
    func buildTabbarUI (){
        assert(!vc_array.isEmpty && !img_array.isEmpty, "⚠️⚠️ === 先设置 控制器集合 & 图片集合 ========")
        APPInfomationCache.saveApplicationInstallMark()
        self.custom_bar = APPBasicTabBar(frame: CGRect(origin: CGPointZero, size: CGSize(width: jk_kScreenW, height: barHeight)))
        self.setValue(self.custom_bar, forKey: "tabBar")
        self.custom_bar?.setTabBarImages(barImages: self.img_array)
        self.custom_bar?.barDelegate = self
        
        var listVC: [UIViewController] = []
        vc_array.forEach { (item: UIViewController.Type) in
            listVC.append(APPNavigationViewController(rootViewController: item.init()))
        }
        
        self.viewControllers = listVC
        
        self.selectedIndex = .zero
        
        self.tabbarHookMethod()
    }
}

extension APPBasicTabBarViewController: BasicTabbarProtocol {
    public func canSelectedCurrentBarItem(shouldSelectedIndex: Int) -> Bool {
        return currentBarItemCanSelected()
    }
    
    public func selectedCurrentBarItem(_ tabbr: APPBasicTabBar, item: UIButton, index: Int) {
        self.selectedIndex = index
    }
}
