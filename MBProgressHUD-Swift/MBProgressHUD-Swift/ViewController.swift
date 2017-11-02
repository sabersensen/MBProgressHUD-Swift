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
        hud.mode = MBProgressHUDMode.Determinate
//        hud.label.text = "Loading..."
//        hud.detailsLabel.text = "Parsing data\n(1/1)"
        hud.animationType = .ZoomIn
        self.view.addSubview(hud)
        hud.showAnimated(animated: true)

        var i:CGFloat = 0.0
        let timer = DispatchSource.makeTimerSource()
        timer.setEventHandler {
            i += 0.01
            print("----------\(i)")
            DispatchQueue.main.async {
                hud.progress = i
            }
        }
        timer.setCancelHandler {
            DispatchQueue.main.async {

            hud.hideAnimated(animated: true)
            }
            print("Timer canceled at \(NSDate())" )
        }
        timer.schedule(deadline: .now() , repeating: 0.1, leeway: .microseconds(10))
        print("Timer resume at \(NSDate())")
        timer.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute:{
            timer.cancel()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

