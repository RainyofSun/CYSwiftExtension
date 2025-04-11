//
//  ForbidActionTextView.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

public class ForbidActionTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.inputAssistantItem.allowsHidingShortcuts = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

}
