//
//  JCAPPCodeTimerButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

class JCAPPCodeTimerButton: UIControl {

    private lazy var titleLab: UILabel = UILabel.buildJoyCashLabel(font: UIFont.systemFont(ofSize: 14), labelColor: .white, labelText: "Get code")
    private var system_timer: Timer?
    
    private var time_count: Int = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initData()
        
        self.backgroundColor = BLUE_COLOR_4169F6
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
        self.layer.cornerRadius = self.height * 0.5
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let viwe = super.hitTest(point, with: event)
        
        return viwe
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
        dispatch_async_on_main_queue {
            if self.time_count <= .zero {
                self.stop()
                self.titleLab.text = "Get code"
                self.initData()
            } else {
                self.titleLab.text = "\(self.time_count)s"
                self.time_count -= 1
            }
        }
    }
}
