//
//  ForbidActionTextFiled.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

public class ForbidActionTextFiled: UITextField {

    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 5
        return rect
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 5
        return rect
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 8, .zero)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 8, .zero)
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

}
