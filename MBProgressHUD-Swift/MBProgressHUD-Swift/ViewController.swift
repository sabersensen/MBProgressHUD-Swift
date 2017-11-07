//
//  ViewController.swift
//  MBProgressHUD-Swift
//
//  Created by 邹时新 on 2017/10/25.
//  Copyright © 2017年 zoushixin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    lazy var array: [[Example]] = {
        let array = [
            [Example.init(text: "Indeterminate mode", selector: #selector(ViewController.indeterminateExample)),
             Example.init(text: "With label", selector: #selector(ViewController.labelExample)),
             Example.init(text: "With details label", selector: #selector(ViewController.detailsLabelExample))],
            [Example.init(text: "Determinate mode", selector: #selector(ViewController.determinateExample)),
             Example.init(text: "Annular determinate mode", selector: #selector(ViewController.annularDeterminateExample)),
             Example.init(text: "Bar determinate mode", selector: #selector(ViewController.barDeterminateExample))],
            [Example.init(text: "Text only", selector: #selector(ViewController.textExample)),
             Example.init(text: "Custom view", selector: #selector(ViewController.customViewExample)),
             Example.init(text: "With action button", selector: #selector(ViewController.cancelationExample)),
             Example.init(text: "Mode switching", selector: #selector(ViewController.modeSwitchingExample))],
            [Example.init(text: "On window", selector: #selector(ViewController.indeterminateExample)),
             Example.init(text: "NSURLSession", selector: #selector(ViewController.networkingExample)),
             Example.init(text: "Determinate with NSProgress", selector: #selector(ViewController.determinateNSProgressExample)),
             Example.init(text: "Dim background", selector: #selector(ViewController.dimBackgroundExample)),
             Example.init(text: "Colored", selector: #selector(ViewController.colorExample))
            ]
                   ]
        return array
    }()
    
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: self.view.frame, style: UITableViewStyle.grouped)
        
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "zsdsbCell")
        cell.textLabel?.text = array[indexPath.section][indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = array[indexPath.section][indexPath.row]
        self.perform(example.selector)
    }
    
    @objc func indeterminateExample()  {
        self.view.showMBProgressHUD()
        DispatchQueue.init(label: "com.zoushixin.www").async {
            self.doSomething()
            DispatchQueue.main.async {
                MBProgressHUD.sharedMBProgressHUD.hideAnimated(animated: true)
            }
        }
    }
    
    @objc func labelExample() {
        MBProgressHUD.sharedMBProgressHUD.label.text = "Loading..."
        self.view.showMBProgressHUD()
        DispatchQueue.init(label: "com.zoushixin.www").async {
            self.doSomething()
            DispatchQueue.main.async {
                MBProgressHUD.sharedMBProgressHUD.hideAnimated(animated: true)
            }
        }
    }
    
    @objc func detailsLabelExample() {
        MBProgressHUD.sharedMBProgressHUD.label.text = "Loading..."
        MBProgressHUD.sharedMBProgressHUD.detailsLabel.text = "Parsing data\n(1/1)"
        self.view.showMBProgressHUD()
        DispatchQueue.init(label: "com.zoushixin.www").async {
            self.doSomething()
            DispatchQueue.main.async {
                MBProgressHUD.sharedMBProgressHUD.hideAnimated(animated: true)
            }
        }
    }
    
    @objc func determinateExample(){
        MBProgressHUD.sharedMBProgressHUD.label.text = "Loading..."
        MBProgressHUD.sharedMBProgressHUD.mode = MBProgressHUDMode.Determinate
        self.view.showMBProgressHUD()
        DispatchQueue.init(label: "com.zoushixin.www").async {
            self.doProgressSomething(complete: {
                DispatchQueue.main.async {
                    MBProgressHUD.sharedMBProgressHUD.hideAnimated(animated: true)
                }
            })
        }
    }
    
    @objc func annularDeterminateExample() {
        MBProgressHUD.sharedMBProgressHUD.label.text = "Loading..."
        MBProgressHUD.sharedMBProgressHUD.mode = MBProgressHUDMode.AnnularDeterminate
        self.view.showMBProgressHUD()
        DispatchQueue.init(label: "com.zoushixin.www").async {
            self.doProgressSomething(complete: {
                DispatchQueue.main.async {
                    MBProgressHUD.sharedMBProgressHUD.hideAnimated(animated: true)
                }
            })
        }
    }
    
    @objc func barDeterminateExample() {
        MBProgressHUD.sharedMBProgressHUD.label.text = "Loading..."
        MBProgressHUD.sharedMBProgressHUD.mode = MBProgressHUDMode.DeterminateHorizontalBar
        self.view.showMBProgressHUD()
        DispatchQueue.init(label: "com.zoushixin.www").async {
            self.doProgressSomething(complete: {
                DispatchQueue.main.async {
                    MBProgressHUD.sharedMBProgressHUD.hideAnimated(animated: true)
                }
            })
        }
    }
    
    @objc func textExample() {
        MBProgressHUD.sharedMBProgressHUD.mode = MBProgressHUDMode.Text
        MBProgressHUD.sharedMBProgressHUD.label.text = "Message here!"
        MBProgressHUD.sharedMBProgressHUD.offset = CGPoint.init(x: 0.0, y: 1000000)
        self.view.addSubview(MBProgressHUD.sharedMBProgressHUD)
        DispatchQueue.init(label: "com.zoushixin.www").async {
            self.doSomething()
            DispatchQueue.main.async {
                MBProgressHUD.sharedMBProgressHUD.hideAnimated(animated: true)
            }
        }
    }
    
    @objc func customViewExample() {
        MBProgressHUD.sharedMBProgressHUD.mode = MBProgressHUDMode.CustomView
        MBProgressHUD.sharedMBProgressHUD.customView = UIImageView.init(image: UIImage.init(named: "Checkmark")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        MBProgressHUD.sharedMBProgressHUD.label.text = "Done"
        self.view.showMBProgressHUD()
        DispatchQueue.init(label: "com.zoushixin.www").async {
            self.doSomething()
            DispatchQueue.main.async {
                MBProgressHUD.sharedMBProgressHUD.hideAnimated(animated: true)
            }
        }
    }
    
    @objc func cancelationExample() {
        
    }
    
    @objc func modeSwitchingExample()  {
        
    }
    
    @objc func networkingExample() {
        
    }
    
    @objc func determinateNSProgressExample() {
        
    }
    
    @objc func dimBackgroundExample()  {
        
    }
    
    @objc func colorExample() {
        
    }
    
    
    func doSomething()  {
        sleep(UInt32(3.0))
    }
    
    func doProgressSomething(complete:@escaping ()->Void) {
        var i:CGFloat = 0.0
        let timer = DispatchSource.makeTimerSource()
        timer.setEventHandler {
            i += 0.01
            print("----------\(i)")
            DispatchQueue.main.async {
                MBProgressHUD.sharedMBProgressHUD.progress = i
            }
        }
        timer.setCancelHandler {
            complete()
            print("Timer canceled at \(NSDate())" )
        }
        timer.schedule(deadline: .now() , repeating: 0.03, leeway: .microseconds(3))
        print("Timer resume at \(NSDate())")
        timer.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute:{
            timer.cancel()
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class Example {
    var text:String
    var selector:Selector
    
    init(text:String,selector:Selector) {
        self.text = text
        self.selector = selector
    }
}

