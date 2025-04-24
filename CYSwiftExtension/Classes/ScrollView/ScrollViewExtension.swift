//
//  ScrollViewExtension.swift
//  CYSwiftExtension
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import MJRefresh
import SnapKit

// 空白页配置结构体
public struct EmptyViewConfig {
    public var image: UIImage?
    public var title: String?
    public var titleColor: UIColor = .gray
    public var titleFont: UIFont = .systemFont(ofSize: 15)
    public var buttonTitle: String?
    public var buttonTitleColor: UIColor = .white
    public var buttonBackgroundColor: UIColor = .blue
    public var buttonFont: UIFont = .systemFont(ofSize: 15)
    public var buttonSize: CGSize = CGSize(width: 120, height: 40)
    public var buttonCornerRadius: CGFloat = 20
    public var verticalOffset: CGFloat = 0
    public var buttonAction: (() -> Void)?
    
    public init() {}
}

extension UIScrollView {
    public func addMJRefresh(addFooter: Bool = false, emptyViewConfig: EmptyViewConfig? = nil, refreshHandler: (@escaping (Bool) -> Void)) {
        if addFooter {
            self.addMJFooter {
                refreshHandler(false)
            }
        }
        
        self.addMJHeader {
            refreshHandler(true)
        }

        self.emptyViewConfig = emptyViewConfig
    }
    
    public func reload(isNoMoreData: Bool) {
        if let _tab = self as? UITableView {
            _tab.reloadData()

            if _tab.numberOfRows(inSection: 0) == .zero {
                self.showEmptyView(config: self.emptyViewConfig ?? EmptyViewConfig())
            } else {
                self.hideEmptyView()
            }
        }
        
        if let _tab = self as? UICollectionView  {
            _tab.reloadData()

            if _tab.numberOfItems(inSection: 0) == .zero {
                self.showEmptyView(config: self.emptyViewConfig ?? EmptyViewConfig())
            } else {
                self.hideEmptyView()
            }
        }
        
        self.mj_header?.endRefreshing()
        
        if let _footer = self.mj_footer {
            if isNoMoreData {
                _footer.endRefreshingWithNoMoreData()
            } else {
                _footer.endRefreshing()
            }
            _footer.isHidden = isNoMoreData
        }
    }
    
    public func refresh(begin: Bool) {
        if begin {
            self.mj_header?.beginRefreshing()
        } else {
            if let _header = self.mj_header, _header.isRefreshing {
                _header.endRefreshing()
            }
        }
    }
    
    public func loadMore(begin: Bool, noData: Bool = false) {
        if begin {
            self.mj_footer?.beginRefreshing()
        } else {
            if let _footer = self.mj_footer, _footer.isRefreshing {
                noData ? _footer.endRefreshingWithNoMoreData() : _footer.endRefreshing()
            }
        }
    }
    
    public func resetNoMoreData() {
        if let _footer = self.mj_footer {
            _footer.resetNoMoreData()
        }
    }
    
    public func refreshHeaderStateText(_ idleText: String? = nil, pullingText: String? = nil, refreshingText: String? = nil) {
        guard let _header = self.mj_header as? MJRefreshNormalHeader else {
            return
        }
        
        if let _idle = idleText {
            _header.setTitle(_idle, for: MJRefreshState.idle)
        }
        
        if let _pulling = pullingText {
            _header.setTitle(_pulling, for: MJRefreshState.pulling)
        }
        
        if let _refreshing = refreshingText {
            _header.setTitle(_refreshing, for: MJRefreshState.refreshing)
        }
    }
    
    public func loadMoreFooterStateText(_ idleText: String? = nil, refreshText: String? = nil, noMoreText: String? = nil) {
        guard let _footer = self.mj_footer as? MJRefreshAutoNormalFooter else {
            return
        }
        
        if let _idle = idleText {
            _footer.setTitle(_idle, for: MJRefreshState.idle)
        }
        
        if let _refresh = refreshText {
            _footer.setTitle(_refresh, for: MJRefreshState.refreshing)
        }
        
        if let _noMore = noMoreText {
            _footer.setTitle(_noMore, for: MJRefreshState.noMoreData)
        }
    }
    
    // 空白页视图
    private struct AssociatedKeys {
        static var emptyView = "emptyView"
        static var emptyViewConfig = "emptyViewConfig"
    }
    
    private var emptyView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 空白页配置
    private var emptyViewConfig: EmptyViewConfig? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyViewConfig) as? EmptyViewConfig
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyViewConfig, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 显示空白页
    public func showEmptyView(config: EmptyViewConfig) {
        if self.emptyView != nil && self.emptyView?.superview != nil {
            self.emptyView?.isHidden = false
            return
        }
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.height.centerX.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        var lastView: UIView?
        
        // 添加图片
        if let image = config.image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(config.verticalOffset)
                make.size.equalTo(image.size)
            }
            
            lastView = imageView
        }
        
        // 添加标题
        if let title = config.title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = config.titleColor
            titleLabel.font = config.titleFont
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                if let _temp = lastView {
                    make.top.equalTo(_temp.snp.bottom).offset(8)
                } else {
                    make.centerY.equalToSuperview().offset(config.verticalOffset)
                }
                make.width.equalToSuperview().multipliedBy(0.8)
            }
            
            lastView = titleLabel
        }
        
        // 添加按钮
        if let buttonTitle = config.buttonTitle {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(config.buttonTitleColor, for: .normal)
            button.backgroundColor = config.buttonBackgroundColor
            button.titleLabel?.font = config.buttonFont
            button.layer.cornerRadius = config.buttonCornerRadius
            button.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                if let _temp = lastView {
                    make.top.equalTo(_temp.snp.bottom).offset(8)
                } else {
                    make.centerY.equalToSuperview().offset(config.verticalOffset)
                }
                
                make.size.equalTo(config.buttonSize)
            }
            
            if let action = config.buttonAction {
                button.addAction(UIAction { _ in action() }, for: .touchUpInside)
            }
        }
        
        self.emptyView = containerView
    }
    
    /// 隐藏空白页
    public func hideEmptyView() {
        self.emptyView?.isHidden = true
    }
}

private extension UIScrollView {

    func addMJHeader(handler: @escaping (() -> Void)) {
        let header: MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: handler)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle("Pull down to refresh", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading...", for: .refreshing)
        
        self.mj_header = header;
    }
    
    func addMJFooter(handler: @escaping (() -> Void)) {
        let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: handler)
        footer.setTitle("Tap or pull up to load more", for: .idle)
        footer.setTitle("Loading...", for: .refreshing)
        footer.setTitle("No more data", for: .noMoreData)
        
        self.mj_footer = footer
    }
}
