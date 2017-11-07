//
//  UIView+MBExtension.swift
//  MBProgressHUD-Swift
//
//  Created by 邹时新 on 2017/10/25.
//  Copyright © 2017年 zoushixin. All rights reserved.
//

import UIKit

extension UIView{
    func showMBProgressHUD(){
        self.showMBProgressHUD(frame: self.frame,animated:true)
    }
    
    func showMBProgressHUD(frame:CGRect) {
        self.showMBProgressHUD(frame: frame,animated:true)
    }
    
    func showMBProgressHUD(animated:Bool) {
        self.showMBProgressHUD(frame: self.frame,animated:animated)
    }
    
    func showMBProgressHUD(frame:CGRect,animated:Bool) {
        let hud = MBProgressHUD.sharedMBProgressHUD
        hud.frame = self.frame
        self.addSubview(hud)
        hud.showAnimated(animated: animated)
    }
    
}


