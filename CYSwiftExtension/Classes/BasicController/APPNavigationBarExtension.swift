//
//  APPNavigationBarExtension.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/9/16.
//

import UIKit
import JKSwiftExtension

public enum Style {
    case opaque(backgroundColor: UIColor, titleColor: UIColor, font: UIFont)
    case transparent(titleColor: UIColor, font: UIFont)
    case `default`(titleColor: UIColor, font: UIFont)
}

public extension UINavigationBar {
    
    /// 设置全局默认样式
    static func applyGlobalStyle(_ style: Style) {
        let appearance = makeAppearance(for: style)
        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = appearance.titleTextAttributes[.font] as? UIColor
        navBar.shadowImage = barShadowImage()
    }
    
    /// 单页面设置（仅对当前 UINavigationController 有效）
    func applyPageStyle(_ style: Style) {
        let appearance = UINavigationBar.makeAppearance(for: style)
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        self.compactAppearance = appearance
        self.tintColor = appearance.titleTextAttributes[.font] as? UIColor
        self.shadowImage = UINavigationBar.barShadowImage()
    }
    
    // MARK: - 内部工具
    
    private static func makeAppearance(for style: Style) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        var backColor: UIColor = UIColor.black
        
        switch style {
        case .opaque(let backgroundColor, let titleColor, let font):
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
            appearance.titleTextAttributes = [.foregroundColor: titleColor, .font: font]
            backColor = titleColor
        case .transparent(let titleColor, let font):
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [.foregroundColor: titleColor, .font: font]
            backColor = titleColor
        case .default(let titleColor, let font):
            appearance.configureWithDefaultBackground()
            appearance.titleTextAttributes = [.foregroundColor: titleColor, .font: font]
            backColor = titleColor
        }
        
        let originalImage = UIImage(systemName: "chevron.backward")
        let tintedImage: UIImage = originalImage?.withTintColor(backColor, renderingMode: .alwaysOriginal) ?? UIImage()
        appearance.setBackIndicatorImage(tintedImage, transitionMaskImage: tintedImage)
        appearance.shadowColor = .clear
        
        return appearance
    }
    
    private static func barShadowImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: jk_kScreenW, height: 0.5), false, 0)
        let path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: jk_kScreenW, height: 0.5))
        UIColor.clear.setFill()// 自定义NavigationBar分割线颜色
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
