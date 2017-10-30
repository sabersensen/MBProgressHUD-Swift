//
//  MBProgressHUDRoundedButton.swift
//  MBProgressHUD-Swift
//
//  Created by 邹时新 on 2017/10/30.
//  Copyright © 2017年 zoushixin. All rights reserved.
//  按钮的基类

import UIKit

class MBProgressHUDRoundedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = ceil(self.bounds.height/2.0)
    }
    
    override var intrinsicContentSize: CGSize{
        if Int(self.allControlEvents.rawValue) == 0 {
            return CGSize.zero
        }
        
        var size:CGSize = super.intrinsicContentSize
        size.width += 20.0
        return size
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        super.setTitleColor(color, for: state)
        self.layer.borderColor = color?.cgColor
    }
    
    override var isHighlighted: Bool{
        willSet{
            super.isHighlighted = newValue
            let baseColor:UIColor = self.titleColor(for: UIControlState.selected)!
            self.backgroundColor = newValue ? baseColor.withAlphaComponent(0.1) : UIColor.clear
        }
        
    }

}
