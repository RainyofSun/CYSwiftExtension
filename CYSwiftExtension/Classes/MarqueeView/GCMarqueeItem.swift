//
//  GCMarqueeItem.swift
//  GCMarqueeViewDemo_Swift
//
//  Created by HenryCheng on 2019/8/2.
//  Copyright © 2019 igancao. All rights reserved.
//

import UIKit

public class GCMarqueeItem: UIView {
    
    private let padding: CGFloat = 18.0;
    private let icon_title_margin: CGFloat = 10.0;
    private let defaultHeight: CGFloat = 28.0;
    private let icon_width: CGFloat = 20.0;
    private let icon_height: CGFloat = 18.0;

    var model: GCMarqueeModel?
    private var imageV: UIImageView?
    private var titleLabel: UILabel?
    typealias tapBlock = (GCMarqueeModel?) -> ()
    var block: tapBlock = {_ in }

    public init(frame: CGRect, model: GCMarqueeModel) {
        self.model = model
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = model.itemHeight / 2
        self.backgroundColor = model.bulletBackgroundColor
        initUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        if let _img = imageV {
            _img.frame = CGRect(x: padding, y: ((model?.itemHeight ?? defaultHeight) - icon_height) / 2, width: icon_width, height: icon_height)
            titleLabel!.frame = CGRect(x: padding + icon_width + icon_title_margin, y: ((model?.itemHeight ?? defaultHeight) - 15) / 2, width: model?.itemWidth ?? defaultHeight - padding * 2 - icon_width - icon_title_margin, height: 15)
        } else {
            titleLabel!.frame = CGRect(x: padding, y: ((model?.itemHeight ?? defaultHeight) - 15) / 2, width: model?.itemWidth ?? defaultHeight - padding * 2, height: 15)
        }
    }
    
    func initUI() {
        if let _icon = model?.bulletIcon {
            imageV = UIImageView()
            imageV!.image = UIImage(named: _icon)
            addSubview(imageV!)
        }
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.systemFont(ofSize: model?.titleFont ?? 13.0)
        titleLabel?.text = model?.title
        titleLabel?.textColor = model?.titleColor
        addSubview(titleLabel!)
        
        let tapGuester = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGuester)
    }
    
    @objc func tap() {
        block(model)
    }
    

}
