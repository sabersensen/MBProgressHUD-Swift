//
//  MBBarProgressView.swift
//  MBProgressHUD-Swift
//
//  Created by 邹时新 on 2017/10/30.
//  Copyright © 2017年 zoushixin. All rights reserved.
//

import UIKit


class MBBarProgressView: UIView {
    var progress:CGFloat = 0.0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    var lineColor:UIColor = UIColor.white
    
    var progressColor:UIColor = UIColor.white{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var progressRemainingColor:UIColor = UIColor.clear{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    convenience init(){
        self.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 120.0, height: 20.0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize.init(width: 120.0, height: kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0 ? 20 : 10)
    }
    
    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2)
        context.setStrokeColor(lineColor.cgColor)
        context.setFillColor(progressRemainingColor.cgColor)
        
        /// Draw background
        var radius:CGFloat = (rect.size.height/2)-2.0
        context.move(to: CGPoint(x: 2.0, y: rect.size.height/2))
        context.addArc(tangent1End: CGPoint(x: 2.0, y: 2.0), tangent2End: CGPoint(x: radius+2, y: 2.0), radius: radius)
        context.addLine(to: CGPoint(x:rect.size.width - radius - 2.0,y:2.0))
        context.addArc(tangent1End:  CGPoint(x: rect.size.width - 2.0, y: 2.0), tangent2End: CGPoint(x:rect.size.width - 2, y: rect.size.height / 2), radius: radius)
        context.addArc(tangent1End:  CGPoint(x: rect.size.width - 2.0, y: rect.size.height - 2), tangent2End: CGPoint(x:rect.size.width - radius - 2, y: rect.size.height - 2), radius: radius)
        context.addLine(to: CGPoint(x:radius + 2,y:rect.size.height - 2))
        context.addArc(tangent1End:  CGPoint(x: 2, y: rect.size.height - 2), tangent2End: CGPoint(x:2, y: rect.size.height/2), radius: radius)
        context.fillPath()
        
        /// Draw border
        context.move(to: CGPoint(x: 2.0, y: rect.size.height/2))
        context.addArc(tangent1End: CGPoint(x: 2.0, y: 2.0), tangent2End: CGPoint(x: radius+2, y: 2.0), radius: radius)
        context.addLine(to: CGPoint(x:rect.size.width - radius - 2.0,y:2.0))
        context.addArc(tangent1End:  CGPoint(x: rect.size.width - 2.0, y: 2.0), tangent2End: CGPoint(x:rect.size.width - 2, y: rect.size.height / 2), radius: radius)
        context.addArc(tangent1End:  CGPoint(x: rect.size.width - 2.0, y: rect.size.height - 2), tangent2End: CGPoint(x:rect.size.width - radius - 2, y: rect.size.height - 2), radius: radius)
        context.addLine(to: CGPoint(x:radius + 2,y:rect.size.height - 2))
        context.addArc(tangent1End:  CGPoint(x: 2, y: rect.size.height - 2), tangent2End: CGPoint(x:2, y: rect.size.height/2), radius: radius)
        context.strokePath()
        
        context.setFillColor(progressColor.cgColor)
        radius = radius - 2
        
        let amount:CGFloat = (rect.size.width) * (progress)
        
        /// Progress in the middle area
        if amount >= radius + 4 , amount <= (rect.size.width - radius - 4) {
            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context.addArc(tangent1End: CGPoint(x: 4.0, y: 4.0), tangent2End: CGPoint(x: radius+4, y: 4.0), radius: radius)
            context.addLine(to: CGPoint(x:amount,y:4.0))
            context.addLine(to: CGPoint(x:amount,y:radius + 4))

            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context.addArc(tangent1End: CGPoint(x: 4.0, y: rect.size.height - 4), tangent2End: CGPoint(x: radius+4, y: rect.size.height - 4), radius: radius)
            context.addLine(to: CGPoint(x:amount,y:rect.size.height - 4))
            context.addLine(to: CGPoint(x:amount,y:radius + 4))
            context.fillPath()
        }
        ///Progress in the right arc
        else if amount > radius + 4{
            let x = amount - (rect.size.width - radius - 4)
            
            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context.addArc(tangent1End: CGPoint(x: 4.0, y: 4.0), tangent2End: CGPoint(x: radius+4, y: 4.0), radius: radius)
            context.addLine(to: CGPoint(x:rect.size.width - radius - 4,y:4.0))
            var angle = -acos(x/radius)
            if angle.isNaN {
                angle = 0
            }
            context.addArc(center: CGPoint(x: rect.size.width - radius - 4, y: rect.size.height/2), radius: radius, startAngle: CGFloat(Double.pi), endAngle: angle, clockwise: false)
            context.addLine(to: CGPoint(x:amount,y:rect.size.height/2))
            
            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context.addArc(tangent1End: CGPoint(x: 4.0, y: rect.size.height - 4), tangent2End: CGPoint(x: radius+4, y: rect.size.height - 4), radius: radius)
            context.addLine(to: CGPoint(x:rect.size.width - radius - 4,y:rect.size.height - 4))
            angle = acos(x/radius);
            if angle.isNaN {
                angle = 0
            }
            context.addArc(center: CGPoint(x: rect.size.width - radius - 4, y: rect.size.height/2), radius: radius, startAngle: -CGFloat(Double.pi), endAngle: angle, clockwise: true)
            context.addLine(to: CGPoint(x:amount,y:rect.size.height/2))
            context.fillPath()
        }
            ///Progress is in the left arc
        else if amount < radius + 4 , amount > 0 {
            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context.addArc(tangent1End: CGPoint(x: 4.0, y: 4.0), tangent2End: CGPoint(x: radius+4, y: 4.0), radius: radius)
            context.addLine(to: CGPoint(x:radius + 4,y:rect.size.height/2))
            
            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
            context.addArc(tangent1End: CGPoint(x: 4.0, y: rect.size.height - 4), tangent2End: CGPoint(x: radius+4, y: rect.size.height - 4), radius: radius)
            context.addLine(to: CGPoint(x:radius + 4,y:rect.size.height/2))
            context.fillPath()
        }
        
        
    }
}
