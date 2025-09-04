//
//  APPCodeTimerButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import SnapKit

public class APPCodeTimerButton: UIControl {

    private lazy var titleLab: UILabel = {
        let view = UIKit.UILabel(frame: CGRectZero)
        view.numberOfLines = .zero
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "Get Code"
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    private var system_timer: Timer?
    
    private var time_count: Int = .zero
    private let APP_PADDING_UNIT: CGFloat = 4
    private var _title_text: String?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initData()
        
        self.addSubview(self.titleLab)
        
        self.titleLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 2.5)
            make.width.greaterThanOrEqualTo(120)
            make.height.equalTo(18)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.height * 0.5
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("------ deinit -------")
    }
    
    public func setTimerButtonTitle(_ title: String? = "Get Code", titleColor: UIColor = .white) {
        self.titleLab.text = title
        self._title_text = title
        self.titleLab.textColor = titleColor
    }
    
    public func start() {
        if self.system_timer == nil {
            self.system_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCall(sender: )), userInfo: nil, repeats: true)
        }
        
        self.isEnabled = false
    }
    
    public func stop() {
        if let _timer = self.system_timer {
            _timer.invalidate()
            self.system_timer = nil
        }
        

        self.isEnabled = true
    }
    
    public func initCodeTimerStatus() {
        self.stop()
        self.titleLab.text = self._title_text
        self.initData()
    }
}

private extension APPCodeTimerButton {
    func initData() {
#if DEBUG
        time_count = 5
#else
        time_count = 60
#endif
    }
}

@objc private extension APPCodeTimerButton {
    func timerCall(sender: Timer) {
        DispatchQueue.main.async {
            if self.time_count <= .zero {
                self.initCodeTimerStatus()
            } else {
                self.titleLab.text = "\(self.time_count)s"
                self.time_count -= 1
            }
        }
    }
}
