//
//  MBProgressHUD.swift
//  MBProgressHUD-Swift
//
//  Created by 邹时新 on 2017/10/25.
//  Copyright © 2017年 zoushixin. All rights reserved.
//  

import UIKit

enum MBProgressHUDMode {
    case Indeterminate
    case Determinate
    case DeterminateHorizontalBar
    case AnnularDeterminate
    case CustomView
    case Text
}

enum MBProgressHUDAnimation {
    case Fade
    case Zoom
    case ZoomOut
    case ZoomIn
}

enum MBProgressHUDBackgroundStyle {
    case SolidColor
    case Blur
}

protocol UIViewLayoutConstraintProtocol {
    func mb_setContentCompressionResistancePriority();
}

extension UIView:UIViewLayoutConstraintProtocol{
    func mb_setContentCompressionResistancePriority() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: UILayoutConstraintAxis.horizontal)
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: UILayoutConstraintAxis.vertical)
    }
}

class MBProgressHUD: UIView {
    
    public var animationType:MBProgressHUDAnimation = MBProgressHUDAnimation.Fade
    
    public var mode:MBProgressHUDMode = MBProgressHUDMode.Indeterminate
    
    public var margin:Float = 20.0
    
    public var opacity:Float = 1.0
    
    public var defaultMotionEffectsEnabled:Bool = true
    
    public var contentColor:UIColor = (kCFCoreFoundationVersionNumber<kCFCoreFoundationVersionNumber_iOS_7_0) ?UIColor.white:UIColor.init(white: 0.0, alpha: 0.7)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    deinit{
        self.unregisterFromNotifications()
    }
    
    private func commonInit() {
        // Transparent background
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        // Make it invisible for now
        self.alpha = 0.0
        self.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue)|UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        self.layer.allowsGroupOpacity = false
        
        self.setupViews()
        self.updateIndicators()
        self.registerForNotifications()
    }
    
    
    /// 背景透明
    lazy private var backgroundView: MBBackgroundView = {
        let backgroundView = MBBackgroundView.init(frame: self.bounds)
        backgroundView.style = MBProgressHUDBackgroundStyle.SolidColor
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue)|UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        backgroundView.alpha = 0.0
        return backgroundView
    }()
    
    //小背景
    lazy private var bezelView: MBBackgroundView = {
        let bezelView = MBBackgroundView.init()
        bezelView.translatesAutoresizingMaskIntoConstraints = false
        bezelView.layer.cornerRadius = 5.0
        bezelView.alpha = 0.0
        return bezelView
    }()
    
    lazy private var label: UILabel = {
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = NSTextAlignment.center
        label.textColor = self.contentColor
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.isOpaque = false
        label.backgroundColor = UIColor.clear
        label.mb_setContentCompressionResistancePriority()
        return label
    }()
    
    lazy private var detailsLabel: UILabel = {
        let detailsLabel = UILabel.init()
        detailsLabel.adjustsFontSizeToFitWidth = false
        detailsLabel.textAlignment = NSTextAlignment.center
        detailsLabel.textColor = self.contentColor
        detailsLabel.numberOfLines = 0
        detailsLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        detailsLabel.isOpaque = false
        detailsLabel.backgroundColor = UIColor.clear
        detailsLabel.mb_setContentCompressionResistancePriority()
        return detailsLabel
    }()
    
    lazy private var button: MBProgressHUDRoundedButton = {
        let button = MBProgressHUDRoundedButton.init(type : UIButtonType.custom)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        button.setTitleColor(self.contentColor, for: UIControlState.normal)
        button.mb_setContentCompressionResistancePriority()
        return button
    }()
    
    lazy private var topSpacer: UIView = {
        let topSpacer = UIView.init()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        topSpacer.isHidden = true
        return topSpacer
    }()
    
    lazy private var bottomSpacer: UIView = {
        let bottomSpacer = UIView.init()
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.isHidden = true
        return bottomSpacer
    }()
    
    
    private func setupViews() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.bezelView)
        self.updateBezelMotionEffects()
        self.bezelView.addSubview(self.label)
        self.bezelView.addSubview(self.detailsLabel)
        self.bezelView.addSubview(self.button)
        self.bezelView.addSubview(self.topSpacer)
        self.bezelView.addSubview(self.bottomSpacer)
    }
    
    /// 设置约束
    private func updateBezelMotionEffects(){
        if kCFCoreFoundationVersionNumber>=kCFCoreFoundationVersionNumber_iOS_7_0 {
            if self.bezelView.responds(to: #selector(UIView.addMotionEffect(_:))){
                if self.defaultMotionEffectsEnabled {
                    let effectOffset = 10.0
                    let effectX = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
                    effectX.maximumRelativeValue = effectOffset
                    effectX.minimumRelativeValue = -effectOffset
                    
                    let effectY = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
                    effectY.maximumRelativeValue = effectOffset
                    effectY.minimumRelativeValue = -effectOffset
                    
                    let group = UIMotionEffectGroup.init()
                    group.motionEffects = [effectX,effectY]
                    
                    self.bezelView.addMotionEffect(group)
                    
                }else{
                    let effects = self.bezelView.motionEffects
                    for effect in effects {
                        self.bezelView.removeMotionEffect(effect)
                    }
                }
            }
            
        }
    }
    
    /*
     关于加载小控件的UI
    */
    
    var indicator:UIView!
    
    private func updateIndicators() {
        
        var indicatorView = self.indicator
        let isActivityIndicator:Bool = indicatorView?.isKind(of: UIActivityIndicatorView.self) == true
        
        switch self.mode {
        case .Indeterminate:
            if (isActivityIndicator != true){
                indicatorView?.removeFromSuperview()
                indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                let indicatorAct = indicatorView as! UIActivityIndicatorView
                indicatorAct.startAnimating()
                self.bezelView.addSubview(indicatorAct)
            }
        case .Determinate:
            break
        case .DeterminateHorizontalBar:
            break
        case .AnnularDeterminate:
            break
        case .CustomView:
            break
        case .Text:
            break
        }
        indicatorView?.translatesAutoresizingMaskIntoConstraints = false
        self.indicator = indicatorView
        
        /*
         if ([indicator respondsToSelector:@selector(setProgress:)]) {
         [(id)indicator setValue:@(self.progress) forKey:@"progress"];
         }
        */
        
        indicatorView?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: UILayoutConstraintAxis.horizontal)
        indicatorView?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: UILayoutConstraintAxis.vertical)
        
        
        self.updateViewsForColor(color: self.contentColor)
        self.setNeedsLayout()
        
    }
    
    /*
     更新UI颜色
    */
    func updateViewsForColor(color:UIColor) {
        
        self.label.textColor = color
        self.detailsLabel.textColor = color
        self.button.setTitleColor(color, for: UIControlState.normal)
        if self.indicator?.isKind(of: UIActivityIndicatorView.self) == true{
            let appearance:UIActivityIndicatorView!
            
            if kCFCoreFoundationVersionNumber<kCFCoreFoundationVersionNumber_iOS_9_0{
                appearance = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self])
            }else{
                appearance = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self])
            }
        }
    }
    
    private func registerForNotifications() {
        
    }
    
    private func unregisterFromNotifications() {
        
    }
}

class MBBackgroundView: UIView {
    
    var style:MBProgressHUDBackgroundStyle!
    
    var color:UIColor!
    
}

class MBProgressHUDRoundedButton: UIButton {
    
}
