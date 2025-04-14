//
//  APPGradientColorButton.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

public class APPGradientColorButton: UIButton {

    private(set) lazy var bgGradientView: GradientColorView = {
        let view = GradientColorView(frame: CGRectZero)
        view.buildGradientWithColors()
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.bgGradientView)
        self.bgGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
