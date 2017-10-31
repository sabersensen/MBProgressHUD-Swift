//
//  MBRoundProgressView.swift
//  MBProgressHUD-Swift
//
//  Created by 邹时新 on 2017/10/31.
//  Copyright © 2017年 zoushixin. All rights reserved.
//

import UIKit

class MBRoundProgressView: UIView {

    var progress:CGFloat = 0.0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var annular:Bool = false
    
    var progressTintColor:UIColor = UIColor.init(white: 1.0, alpha: 1.0){
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var backgroundTintColor:UIColor = UIColor.init(white: 1.0, alpha: 0.1){
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    convenience init(){
        self.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 37.0, height: 37.0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize.init(width: 37.0, height: 37.0)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let isPreiOS7:Bool = kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0
        
        if self.annular {
            /// Draw background
            let lineWidth:CGFloat = isPreiOS7 ? 5.0 :2.0
            let processBackgroundPath:UIBezierPath = UIBezierPath.init()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = CGLineCap.butt
            let center:CGPoint = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
            let radius:CGFloat = (self.bounds.size.width - lineWidth)/2
            let startAngle:CGFloat = CGFloat(-(Double.pi/2))
            var endAngle:CGFloat = 2*CGFloat(Double.pi/2)+startAngle
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundTintColor.set()
            processBackgroundPath.stroke()
            /// Draw progress
            let processPath:UIBezierPath = UIBezierPath.init()
            processPath.lineCapStyle = isPreiOS7 ? CGLineCap.round : CGLineCap.square;
            processPath.lineWidth = lineWidth
            endAngle = self.progress*2*CGFloat(Double.pi/2)+startAngle
            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.progressTintColor.set()
            processPath.stroke()
        }else{
            // Draw background
            let lineWidth:CGFloat = 2.0
            let allRect:CGRect = self.bounds
            let circleRect:CGRect = allRect.insetBy(dx: lineWidth/2, dy: lineWidth/2)
            let center:CGPoint = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
            self.progressTintColor.setStroke()
            self.backgroundTintColor.setFill()
            context?.setLineWidth(lineWidth)
            if isPreiOS7{
                context?.fillEllipse(in: circleRect)
            }
            context?.strokeEllipse(in: circleRect)
            /// 90 degrees
            let startAngle = -CGFloat(Double.pi/2)
            /// Draw progress
            if isPreiOS7{
                let radius:CGFloat = (self.bounds.width/2) - lineWidth
                let endAngle:CGFloat = self.progress*2*CGFloat(Double.pi)+startAngle
                self.progressTintColor.setFill()
                context?.move(to: CGPoint(x:center.x,y:center.y))
                context?.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                context?.closePath()
                context?.fillPath()
            }else{
                let processPath:UIBezierPath = UIBezierPath.init()
                processPath.lineCapStyle = CGLineCap.butt
                processPath.lineWidth = lineWidth*2
                let radius:CGFloat = self.bounds.width/2.0 - processPath.lineWidth/2.0
                let endAngle:CGFloat = (self.progress * 2 * CGFloat(Double.pi)) + startAngle
                processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                context?.setBlendMode(CGBlendMode.copy)
                self.progressTintColor.set()
                processPath.stroke()
            }
            
        }

    }
    
}
