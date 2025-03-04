//
//  JCAPPCodeTimerButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import SnapKit

class JCAPPCodeTimerButton: UIControl {

    private lazy var titleLab: UILabel = {
        let view = UIKit.UILabel(frame: CGRectZero)
        view.numberOfLines = .zero
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "Get Code"
        view.textColor = .white
        return view
    }()
    
    private var system_timer: Timer?
    
    private var time_count: Int = .zero
    private let APP_PADDING_UNIT: CGFloat = 4
    private var _title_text: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initData()
        
        self.addSubview(self.titleLab)
        
        self.titleLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 6)
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT * 2.5)
            make.width.greaterThanOrEqualTo(66)
            make.height.equalTo(18)
        }
    }
    
    override func layoutSubviews() {
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
    
    public func setTimerButtonTitle(_ title: String? = "Get Code") {
        self.titleLab.text = title
        self._title_text = title
    }
    
    public func start() {
        if self.system_timer == nil {
            self.system_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCall(sender: )), userInfo: nil, repeats: true)
        }
    }
    
    public func stop() {
        if let _timer = self.system_timer {
            _timer.invalidate()
            self.system_timer = nil
        }
    }
}

private extension JCAPPCodeTimerButton {
    func initData() {
#if DEBUG
        time_count = 5
#else
        time_count = 60
#endif
    }
}

@objc private extension JCAPPCodeTimerButton {
    func timerCall(sender: Timer) {
        DispatchQueue.main.async {
            if self.time_count <= .zero {
                self.stop()
                self.titleLab.text = self._title_text
                self.initData()
            } else {
                self.titleLab.text = "\(self.time_count)s"
                self.time_count -= 1
            }
        }
    }
}
