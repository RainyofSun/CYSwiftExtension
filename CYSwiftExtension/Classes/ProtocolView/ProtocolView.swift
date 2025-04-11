//
//  ProtocolView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/21.
//

import UIKit
import SnapKit

public protocol APPProtocolDelegate: AnyObject {
    func gotoProtocol()
}

public class ProtocolView: UIView {

    weak open var protocolDelegate: APPProtocolDelegate?
    open var hasSelected: Bool {
        return self.agreeBtn.isSelected
    }
    
    private lazy var agreeBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
    
    private lazy var protocolBtn: UIButton = {
        let view = UIButton(type: UIButton.ButtonType.custom)
        view.titleLabel?.numberOfLines = .zero
        return view
    }()
    
    private let APP_PADDING_UNIT: CGFloat = 4
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.agreeBtn.addTarget(self, action: #selector(clickAgreeButton(sender: )), for: UIControl.Event.touchUpInside)
        self.protocolBtn.addTarget(self, action: #selector(clickProtocolButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.addSubview(self.agreeBtn)
        self.addSubview(self.protocolBtn)
        
        self.protocolBtn.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(APP_PADDING_UNIT)
            make.height.greaterThanOrEqualTo(APP_PADDING_UNIT * 6)
            make.left.equalTo(self.agreeBtn.snp.right).offset(APP_PADDING_UNIT)
        }
        
        self.agreeBtn.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.centerY.equalTo(self.protocolBtn)
            make.left.equalToSuperview().offset(APP_PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setAgreeButton(_ image: UIImage, selectedImg: UIImage) {
        self.agreeBtn.setImage(image, for: .normal)
        self.agreeBtn.setImage(selectedImg, for: .selected)
    }
    
    public func setProtocol(_ protocolName: NSAttributedString, protocolPrefix: NSAttributedString, defaultSelected: Bool = true) {
        let string: NSMutableAttributedString = NSMutableAttributedString(attributedString: protocolPrefix)
        string.append(protocolName)
        self.protocolBtn.setAttributedTitle(string, for: UIControl.State.normal)
        self.agreeBtn.isSelected = defaultSelected
    }
}

@objc private extension ProtocolView {
    func clickAgreeButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func clickProtocolButton(sender: UIButton) {
        self.protocolDelegate?.gotoProtocol()
    }
}
