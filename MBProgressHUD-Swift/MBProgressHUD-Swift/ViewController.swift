//
//  ViewController.swift
//  MBProgressHUD-Swift
//
//  Created by 邹时新 on 2017/10/25.
//  Copyright © 2017年 zoushixin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton.init(type: UIButtonType.contactAdd)
        btn.frame = CGRect.init(x: 0, y: 200, width: 30, height: 40)
        btn.addTarget(self, action: #selector(ViewController.onClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
        self.view.backgroundColor = UIColor .white

        
    }
    
    @objc func onClick() {
        let hud = MBProgressHUD.init(frame: self.view.frame)
        hud.showAnimated(animated: false)
        self.view .addSubview(hud)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

