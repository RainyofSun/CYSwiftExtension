//
//  APPBasicViewController.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/9/16.
//

import UIKit
import JKSwiftExtension
import FDFullscreenPopGesture

open class APPBasicViewController: UIViewController {

    private(set) lazy var basicScrollContentView: UIScrollView = {
        let view = UIScrollView(frame: CGRectZero)
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private(set) lazy var gradientView: GradientColorView = {
        let view = GradientColorView()
        view.isHidden = true
        return view
    }()
    
    open var buryingStartTime: String?
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.buryingStartTime = Date().jk.dateToTimeStamp()
        
        self.fd_interactivePopDisabled = false
        self.fd_prefersNavigationBarHidden = false
        
        self.buildPageUI()
        self.layoutPageViews()
    }

    public func buildPageUI() {
        self.basicScrollContentView.showsVerticalScrollIndicator = false
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "#FFF2EF")
        self.view.addSubview(self.gradientView)
        self.view.addSubview(self.basicScrollContentView)
    }
    
    public func layoutPageViews() {
        self.gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let _childrenVC = self.navigationController?.children, _childrenVC.count > 1 {
            self.basicScrollContentView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(self.view).offset(jk_kNavFrameH + 4.0)
                make.bottom.equalToSuperview().offset(-jk_kTabbarBottom - 4.0)
            }
        } else {
            if self.presentingViewController != nil {
                self.basicScrollContentView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
                self.basicScrollContentView.snp.makeConstraints { make in
                    make.horizontalEdges.top.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-jk_kTabbarFrameH)
                }
            }
        }
    }
    
    public func refreshMineLocations() {
        
    }
    
    public func pageNetRequest() {
        
    }
}
