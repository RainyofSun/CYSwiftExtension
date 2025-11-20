//
//  APPBasicTabBarViewController.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/11/13.
//

import UIKit
import JKSwiftExtension

open class APPBasicTabBarViewController: UITabBarController {

    open var custom_bar: APPBasicTabBar?
    open var barHeight: CGFloat = jk_kTabbarFrameH + 10
    private var custom_bar_style: APPBasicTabBarStyleConfig?
    
    open override var selectedIndex: Int {
        didSet {
            self.custom_bar?.selectedBarItem(selectedIndex)
        }
    }
    
    public init(barStyle: APPBasicTabBarStyleConfig) {
        super.init(nibName: nil, bundle: nil)
        self.custom_bar_style = barStyle
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
        guard let _style = self.custom_bar_style else {
            return
        }
        
        assert(!(_style.subControllerArray?.isEmpty ?? true) && !(_style.barSelectedImagesArray?.isEmpty ?? true), "⚠️⚠️ === 先设置 控制器集合 & 图片集合 ========")
        assert(self.custom_bar_style?.navClassName != nil, "⚠️⚠️ === 先设置 导航控制器类名 ========")
        
        APPInfomationCache.saveApplicationInstallMark()
        self.custom_bar = APPBasicTabBar(frame: CGRect(origin: CGPointZero, size: CGSize(width: jk_kScreenW, height: barHeight)), barConfig: self.custom_bar_style)
        self.setValue(self.custom_bar, forKey: "tabBar")
        self.custom_bar?.setTabBarImages(barSelectedImages: _style.barSelectedImagesArray ?? [], barNormalImages: _style.barNormalImagesArray ?? [], barTitles: _style.barTitlesArray, barSelectedColor: _style.barSelectedColor, barNormalColor: _style.barNormalColor)
        
        self.custom_bar?.barDelegate = self
        guard let className = self.custom_bar_style?.navClassName else {
            print("navClassName is nil")
            return
        }
        
        // 自动补全模块名（Pod/Framework 中非常重要）
        let moduleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        let fullName = "\(moduleName).\(className)"
        
        var listVC: [UIViewController] = []
        _style.subControllerArray?.forEach { (item: UIViewController.Type) in

            guard let cls = NSClassFromString(fullName) as? UINavigationController.Type else {
                print("❌ 无法根据类名创建 UINavigationController：\(fullName)")
                return
            }

            // 创建实例
            let nav = cls.init(rootViewController: item.init())
            listVC.append(nav)
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
