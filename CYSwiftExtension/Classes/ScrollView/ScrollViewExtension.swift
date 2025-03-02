//
//  ScrollViewExtension.swift
//  CYSwiftExtension
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import MJRefresh

extension UIScrollView {
    public func addMJRefresh(addFooter: Bool, refreshHandler: (@escaping (Bool) -> Void)) {
        if addFooter {
            self.addMJFooter {
                refreshHandler(false)
            }
        }
        
        self.addMJHeader {
            refreshHandler(true)
        }
    }
    
    public func reload(isEmpty: Bool) {
        if let _tab = self as? UITableView {
            _tab.reloadData()
        }
        
        if let _tab = self as? UICollectionView  {
            _tab.reloadData()
        }
        
        self.mj_header?.endRefreshing()
        
        if let _footer = self.mj_footer {
            if isEmpty {
                _footer.endRefreshingWithNoMoreData()
            } else {
                _footer.endRefreshing()
            }
            _footer.isHidden = isEmpty
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
