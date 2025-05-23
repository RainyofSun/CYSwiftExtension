//
//  GCMarqueeView.swift
//  GCMarqueeViewDemo_Swift
//
//  Created by HenryCheng on 2019/8/2.
//  Copyright © 2019 igancao. All rights reserved.
//

import UIKit

/// Marquee run direction.
///
/// - rtl: right -> left
/// - ltr: left -> right
/// - ttb: top -> bottom
/// - btt: bottom -> top
/// - reverse: right -> left -> right ...
public enum GCMarqueeDirectionType: Int {
   case rtl
   case ltr
   case ttb
   case btt
   case reverse
}

public struct GCMarqueeModel {
    
    public var titleFont: CGFloat = 13.0;
    public var titleColor: UIColor = .black
    public var bulletBackgroundColor: UIColor = UIColor.orange
    public var bulletIcon: String?
    public var itemHeight: CGFloat
    
    // 左右边距
    fileprivate static let padding: CGFloat = 16.0;
    fileprivate static let icon_title_margin: CGFloat = 10.0;
    private let defaultHeight: CGFloat = 28.0;
    private let icon_width: CGFloat = 20.0;

    
    let title: String
    var itemWidth: CGFloat {
        get {
            let strWidth = self.title.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleFont)], context: nil).size.width
            if let _ = bulletIcon {
                return GCMarqueeModel.padding * 2 + GCMarqueeModel.icon_title_margin + strWidth + icon_width
            } else {
                return GCMarqueeModel.padding * 2 + strWidth
            }
        }
    }
    
    public init(title: String) {
        self.title = title
        itemHeight = defaultHeight
    }
    
}

public class GCMarqueeView: UIView {
    
    public typealias tapBlock = (GCMarqueeModel?) -> ()
    public var block: tapBlock = {_ in }
    public var pointsPerFrame: CGFloat = 1//default is 1, you can set it what you want.
    public var type: GCMarqueeDirectionType
    public var items: Array<GCMarqueeModel> = [] {
        didSet {
            configScrollView()
        }
    }
    
    private let framesPerSecond = 30
    private var isReverse = false
    private var scrollView: UIScrollView!
    private var dispalyLink: CADisplayLink?
    
    public init(frame: CGRect , type: GCMarqueeDirectionType) {
        self.type = type
        super.init(frame: frame)
        self.clipsToBounds = true
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        
        scrollView = UIScrollView.init(frame: bounds)
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
    }
    
    func configScrollView() {
        scrollView.layer.removeAllAnimations()
        scrollView.subviews.forEach { (item: UIView) in
            if item is GCMarqueeItem {
                item.removeFromSuperview()
            }
        }
        
        var tmpItem = GCMarqueeItem()
        for i in 0..<items.count {
            var tmpFrame: CGRect = CGRect.zero
            if type == .rtl || type == .ltr || type == .reverse {
                
                tmpFrame = CGRect(x: tmpItem.frame.origin.x + tmpItem.frame.size.width + GCMarqueeModel.icon_title_margin, y: 0, width: items[i].itemWidth, height: items[i].itemHeight)
            } else if type == .btt || type == .ttb {

                tmpFrame = CGRect(x: 0, y: tmpItem.frame.origin.y + tmpItem.frame.size.height + GCMarqueeModel.padding, width: items[i].itemWidth, height: items[i].itemHeight)
            } else {
                tmpFrame = CGRect.zero
            }
            
            let item = GCMarqueeItem(frame: tmpFrame, model: items[i])
            item.block = { model in
                self.block(model)
            }
            scrollView.addSubview(item)
            tmpItem = item
        }
        
        let Y = (self.bounds.size.height - tmpItem.bounds.size.height) * 0.5
        if type == .rtl || type == .ltr || type == .reverse {
            scrollView.contentSize = CGSize(width: tmpItem.frame.origin.x + tmpItem.frame.size.width, height: 0);
            if type == .ltr {
                scrollView.frame = CGRect(x: -scrollView.contentSize.width, y: Y, width: scrollView.contentSize.width, height: tmpItem.bounds.size.height)
            } else {
                scrollView.frame = CGRect(x: self.bounds.size.width, y: Y, width: self.bounds.size.width + scrollView.contentSize.width, height: tmpItem.bounds.size.height)
            }
        } else if type == .btt || type == .ttb {
            scrollView.contentSize = CGSize(width: 0, height: tmpItem.frame.origin.y + tmpItem.frame.size.height);
            if type == .ttb {
                scrollView.frame = CGRect(x: 0, y: -scrollView.contentSize.height, width: self.bounds.size.width, height: scrollView.contentSize.height)
            } else {
                scrollView.frame = CGRect(x: 0, y: self.bounds.size.height, width: self.bounds.size.width, height: scrollView.contentSize.height)
            }
        }
        startRunning()
    }
    
    public func startRunning() {
        stopRunning()
        dispalyLink = CADisplayLink.init(target: self, selector: #selector(marqueeRunning))
        if #available(iOS 10.0, *) {
            dispalyLink?.preferredFramesPerSecond = framesPerSecond
        } else {
            dispalyLink?.frameInterval = framesPerSecond
        }
        dispalyLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    public func stopRunning() {
        dispalyLink?.invalidate()
        dispalyLink = nil
    }
    
    @objc func marqueeRunning() {
        let self_width = self.bounds.self.width
        let self_height = self.bounds.self.height
        var rect = scrollView.frame;
        if type == .rtl {
            rect.origin.x -= pointsPerFrame;
            if rect.origin.x <= -scrollView.contentSize.width {
                rect.origin.x = self_width;
            }
        } else if type == .ltr {
            rect.origin.x += pointsPerFrame;
            if rect.origin.x >= self_width {
                rect.origin.x = -scrollView.contentSize.width;
            }
        } else if type == .ttb {
            rect.origin.y += pointsPerFrame;
            if rect.origin.y >= self_height {
                rect.origin.y = -scrollView.contentSize.height;
            }
        } else if type == .btt {
            rect.origin.y -= pointsPerFrame;
            if rect.origin.y <= -scrollView.contentSize.height {
                rect.origin.y = self_height;
            }
        } else if type == .reverse {
            if isReverse {
                rect.origin.x += pointsPerFrame;
                if rect.origin.x >= 0 {
                    isReverse = false;
                }
            } else {
                rect.origin.x -= pointsPerFrame;
                if rect.origin.x <= self_width - scrollView.contentSize.width {
                    isReverse = true;
                }
            }
        }
        scrollView.frame = rect;
    }

}
