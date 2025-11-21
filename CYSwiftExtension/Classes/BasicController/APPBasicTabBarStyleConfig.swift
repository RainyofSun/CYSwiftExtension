//
//  APPBasicTabBarStyleConfig.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/11/17.
//

import UIKit

open class APPBasicTabBarStyleConfig: NSObject {
    /// 背景色
    public var barBackgroubColor = UIColor.white
    /// 水平间距
    public var horizationSpacing = 0
    /// 垂直间距
    public var verticalSpacing = 0
    /// 是否全圆角
    public var setCorner = false
    /// item 左边距 默认 50
    public var leftSpace = 50
    /// item 右边距 默认 50
    public var rightSpace = 50
    /// item 间距 默认 50
    public var itemSpace = 50
    /// item 高度比例 默认是 Tabbar 高度的 0.8
    public var itemHeightScale = 0.8
    /// 导航类
    public var navClassName: String?
    /// 控制器类集合
    public var subControllerArray: [UIViewController.Type]?
    /// 控制器对应的 Tabbar 图片集合
    public var barSelectedImagesArray: [UIImage]?
    /// 控制器对应的 Tabbar 图片集合
    public var barNormalImagesArray: [UIImage]?
    /// 控制器对应的 Tabbar 文字集合
    public var barTitlesArray: [String]?
    /// 当前选中的 Tabbar 选中颜色
    public var barSelectedColor: UIColor?
    /// 未选中的 Tabbar 颜色
    public var barNormalColor: UIColor?
}
