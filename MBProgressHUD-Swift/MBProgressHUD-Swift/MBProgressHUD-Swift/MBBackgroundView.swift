//
//  MBBackgroundView.swift
//  MBProgressHUD-Swift
//
//  Created by 邹时新 on 2017/10/30.
//  Copyright © 2017年 zoushixin. All rights reserved.
//  背景和小背景的基类

import UIKit

class MBBackgroundView: UIView {

    var effectView:UIVisualEffectView!
    
    var style:MBProgressHUDBackgroundStyle!
    
    var color:UIColor!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        if kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 {
            self.style = MBProgressHUDBackgroundStyle.Blur
            if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0){
                self.color = UIColor.init(white: 0.8, alpha: 0.6)
            }else{
                self.color = UIColor.init(white: 0.95, alpha: 0.6)
            }
        }else{
            self.style = MBProgressHUDBackgroundStyle.SolidColor
            self.color = UIColor.black.withAlphaComponent(0.8)
        }
        self.clipsToBounds = true
        self.updateForBackgroundStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    private func updateForBackgroundStyle() {
        switch self.style! {
        case .Blur:
            if kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0 {
                let effect:UIBlurEffect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
                let effectView:UIVisualEffectView = UIVisualEffectView.init(effect: effect)
                self.addSubview(effectView)
                
                effectView.frame = self.bounds
                effectView.autoresizingMask = [UIViewAutoresizing.flexibleHeight,UIViewAutoresizing.flexibleWidth]
                self.backgroundColor = self.color
                self.layer.allowsGroupOpacity = false
            }else{
                
            }
            break
        case .SolidColor:
            if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) {
                self.effectView?.removeFromSuperview()
                self.effectView = nil;
            }else{
                
            }
            self.backgroundColor = self.color;
            break
        }
    }

}
