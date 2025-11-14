//
//  APPBasicTabBar.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/11/13.
//

import UIKit
import JKSwiftExtension

public protocol BasicTabbarProtocol: UITabBarController {
    // 是否可选中当前按钮
    func canSelectedCurrentBarItem(shouldSelectedIndex: Int) -> Bool
    // 选中当前按钮
    func selectedCurrentBarItem(_ tabbr: APPBasicTabBar, item: UIButton, index: Int)
}

open class APPBasicTabBar: UITabBar {

    weak open var barDelegate: BasicTabbarProtocol?
    
    private var original_size: CGSize?
    private let _top_y = 15
    private let _item_padding = 15
    
    private(set) var itemContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.hexStringColor(hexString: "#3D000A")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.backgroundColor = UIColor.white
        self.original_size = frame.size
        
        self.setItemContentViewUIStyle()
        self.addSubview(self.itemContentView)
        self.layoutItemContent()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let _s = original_size {
            return _s
        }
        
        return super.sizeThatFits(size)
    }
    
    open func setItemContentViewUIStyle(IPhoneNotchCornerRadius cornerRadius: CGFloat = -1) {
        
        if cornerRadius != -1 {
            if jk_isIPhoneNotch {
                self.itemContentView.corner(cornerRadius)
            } else {
                self.itemContentView.corner((frame.height - 4.0 * 2) * 0.5)
            }
        }
    }
    
    open func layoutItemContent() {
        self.itemContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(4.0 * 6)
            if jk_isIPhoneNotch {
                make.top.equalToSuperview().offset(4.0 * 1.5)
                make.height.equalTo(60)
            } else {
                make.verticalEdges.equalToSuperview().inset(4.0)
            }
        }
    }
    
    open func setTabBarImages(barImages:[[String]]) {
        guard !barImages.isEmpty && barImages.first?.count == barImages.last?.count else {
            return
        }
        
        let normalImgs = barImages.first
        let selImgs = barImages.last
        
        var _temp_btn: UIButton?
        normalImgs?.enumerated().forEach { (index: Int, img: String) in
            let button = UIButton(type: UIButton.ButtonType.custom)
            button.setImage(UIImage(named: img), for: UIControl.State.normal)
            button.setImage(UIImage(named: selImgs![index]), for: UIControl.State.selected)
            button.tag = 1000 + index
            button.addTarget(self, action: #selector(clickBarItem(sender: )), for: UIControl.Event.touchUpInside)
            self.itemContentView.addSubview(button)
            
            if let _t = _temp_btn {
                if (index + 1) == normalImgs?.count {
                    button.snp.makeConstraints { make in
                        make.left.equalTo(_t.snp.right).offset(60)
                        make.centerY.size.equalTo(_t)
                        make.right.equalToSuperview().offset(-50)
                    }
                } else {
                    button.snp.makeConstraints { make in
                        make.left.equalTo(_t.snp.right).offset(60)
                        make.centerY.size.equalTo(_t)
                    }
                }
            } else {
                button.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().offset(50)
                    make.height.equalTo(35)
                }
            }
            
            _temp_btn = button
        }
    }

    open func selectedBarItem(_ index: Int) {
        guard let _item = self.itemContentView.viewWithTag((1000 + index)) as? UIButton else {
            return
        }
        
        self.resetButtonStatus()
        _item.isSelected = !_item.isSelected
    }
}

private extension APPBasicTabBar {
    func resetButtonStatus() {
        for item in self.itemContentView.subviews {
            if let _btn = item as? UIButton, _btn.tag >= 1000 {
                if _btn.isSelected {
                    _btn.isSelected = false
                    break
                }
            }
        }
    }
}

@objc private extension APPBasicTabBar {
    func clickBarItem(sender: UIButton) {
        if !(self.barDelegate?.canSelectedCurrentBarItem(shouldSelectedIndex: (sender.tag - 1000)) ?? true) {
            return
        }
        
        self.resetButtonStatus()
        sender.isSelected = !sender.isSelected
        self.barDelegate?.selectedCurrentBarItem(self, item: sender, index: (sender.tag - 1000))
    }
}
