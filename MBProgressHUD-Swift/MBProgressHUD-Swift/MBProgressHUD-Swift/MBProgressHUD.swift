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
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: UILayoutConstraintAxis.horizontal)//设置自动布局优先级
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998.0), for: UILayoutConstraintAxis.vertical)
    }
}

class MBProgressHUD: UIView {
    
    public var animationType:MBProgressHUDAnimation = MBProgressHUDAnimation.Fade
    
    public var mode:MBProgressHUDMode = MBProgressHUDMode.Indeterminate
    
    public var margin:Float = 20.0
    
    public var opacity:Float = 1.0
    
    public var defaultMotionEffectsEnabled:Bool = true
    
    public var offset:CGPoint = CGPoint.init(x: 0, y: 0)
    
    public var minSize:CGSize = CGSize.zero
    
    public var contentColor:UIColor = (kCFCoreFoundationVersionNumber<kCFCoreFoundationVersionNumber_iOS_7_0) ?UIColor.white:UIColor.init(white: 0.0, alpha: 0.7)
    
    var paddingConstraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        if self.needsUpdateConstraints() {
            self.updatePaddingConstraints()
        }
        super.layoutSubviews()
    }
    
    var bezelConstraints:[NSLayoutConstraint]!
    
    
    override func updateConstraints() {
        var bezelConstraints = [NSLayoutConstraint]()
        let metrics = ["margin":self.margin]
        
        var subviews:[UIView] = [self.topSpacer,self.label,self.detailsLabel,self.button,self.bottomSpacer]
        if (self.indicator != nil){
            subviews.insert(self.indicator, at: 1)
        }
        
        // 移除额外约束
        self.removeConstraints(self.constraints)
        self.topSpacer.removeConstraints(self.topSpacer.constraints)
        self.bottomSpacer.removeConstraints(self.bottomSpacer.constraints)
        if self.bezelConstraints != nil {
            self.bezelView.removeConstraints(self.bezelConstraints)
            self.bezelConstraints = nil
        }
        
        // 设置 bezelView 的中心点约束
        var centeringConstraints = [NSLayoutConstraint]()
        centeringConstraints.append(NSLayoutConstraint.init(item: self.bezelView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: self.offset.x))
        centeringConstraints.append(NSLayoutConstraint.init(item: self.bezelView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: self.offset.y))
        self.applyPriority(priority: UILayoutPriority(rawValue: 998.0), constraints: centeringConstraints)
        self.addConstraints(centeringConstraints)
        
        // 设置 bezelView 的左右上下约束
        var sideConstraints = [NSLayoutConstraint]()
        sideConstraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: "|-(>=margin)-[v1]-(>=margin)-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: metrics, views: dictionaryOfNames(arr: self.bezelView)))
        sideConstraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=margin)-[v1]-(>=margin)-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: metrics, views: dictionaryOfNames(arr: self.bezelView)))
        self.applyPriority(priority: UILayoutPriority(rawValue: 999.0), constraints: sideConstraints)
        self.addConstraints(sideConstraints)
        
        // 设置bezelView的最小尺寸 从而设置宽高约束
        if (self.minSize != CGSize.zero){
            var minSizeConstraints = [NSLayoutConstraint]()
            minSizeConstraints.append(NSLayoutConstraint.init(item: self.bezelView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: self.minSize.width))
            minSizeConstraints.append(NSLayoutConstraint.init(item: self.bezelView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: self.minSize.height))
            self.applyPriority(priority: UILayoutPriority(rawValue: 998.0), constraints: minSizeConstraints)
            self.addConstraints(minSizeConstraints)
        }
        
        // Square aspect ratio, if set
//        if (self.square) {
//            NSLayoutConstraint *square = [NSLayoutConstraint constraintWithItem:bezel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:bezel attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
//            square.priority = 997.f;
//            [bezelConstraints addObject:square];
//        }
        self.topSpacer.addConstraint(NSLayoutConstraint.init(item: self.topSpacer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: CGFloat(self.margin)))
        self.bottomSpacer.addConstraint(NSLayoutConstraint.init(item: self.bottomSpacer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: CGFloat(self.margin)))
        // Top and bottom spaces should be equal
        bezelConstraints.append(NSLayoutConstraint (item: self.topSpacer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.bottomSpacer, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0))
        
        // Layout subviews in bezel
        var paddingConstraints = [NSLayoutConstraint]()
        for (idx,view) in subviews.enumerated() {
            bezelConstraints.append(NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.bezelView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
            bezelConstraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: "|-(>=margin)-[v1]-(>=margin)-|" , options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: metrics, views: dictionaryOfNames(arr: view)))
            
            if idx == 0 {
                bezelConstraints.append(NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.bezelView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
            }else if (idx == subviews.count - 1){
                bezelConstraints.append(NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.bezelView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
            }
            if idx>0{
                let padding = NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: subviews[idx-1], attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
                bezelConstraints.append(padding)
                paddingConstraints.append(padding)
            }
        }
        
        self.bezelView.addConstraints(bezelConstraints)
        self.bezelConstraints = bezelConstraints
        
        self.paddingConstraints = paddingConstraints
        
        self.updatePaddingConstraints()
        super.updateConstraints()

    }
    
    func dictionaryOfNames(arr:UIView...) -> Dictionary<String,UIView> {
    var d = Dictionary<String,UIView>()
        for (ix,v) in arr.enumerated(){
        d["v\(ix+1)"] = v
    }
    return d
}
    
    private func updatePaddingConstraints() {
        for (idx,padding) in self.paddingConstraints.enumerated() {
            let firstView = padding.firstItem
            let secondView = padding.secondItem
//            padding.constant = 0.0
        }
    }
    
    func applyPriority(priority:UILayoutPriority,constraints:[NSLayoutConstraint]){
        for constraint in constraints {
            constraint.priority = priority
        }
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
        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleHeight]
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
        backgroundView.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleHeight]
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
        topSpacer.translatesAutoresizingMaskIntoConstraints = false//需要设置自动布局必须为false
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

    /// 设置运动视差
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
        indicatorView?.mb_setContentCompressionResistancePriority()
        self.indicator = indicatorView
        
        /*
         if ([indicator respondsToSelector:@selector(setProgress:)]) {
         [(id)indicator setValue:@(self.progress) forKey:@"progress"];
         }
        */
        
        self.updateViewsForColor(color: self.contentColor)
        self.setNeedsUpdateConstraints()
        
    }
    
    /*
     更新UI颜色
    */
    func updateViewsForColor(color:UIColor) {
        
        self.label.textColor = color
        self.detailsLabel.textColor = color
        self.button.setTitleColor(color, for: UIControlState.normal)
        if self.indicator?.isKind(of: UIActivityIndicatorView.self) == true{
//            let appearance:UIActivityIndicatorView!
//
//            if kCFCoreFoundationVersionNumber<kCFCoreFoundationVersionNumber_iOS_9_0{
//                appearance = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self])
//            }else{
//                appearance = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self])
//            }
        }
    }
    
    private func registerForNotifications() {
        
    }
    
    private func unregisterFromNotifications() {
        
    }
    
    //// UI Animated
    
    private var minShowTimer:Timer?
    
    private var useAnimation:Bool = false
    
    private var finished:Bool = false
    
    private var graceTime:TimeInterval = 0
    
    private var hideDelayTimer:Timer?
    
    private lazy var showStarted: NSDate = {
        let showStarted = NSDate.init()
        return showStarted
    }()
    
    func showAnimated(animated:Bool) {
        self.minShowTimer?.invalidate()
        self.useAnimation = animated
        self.finished = false
        if self.graceTime > 0.0 {
            
        }else{
            self.showUsingAnimation(animated: animated)
        }
    }
    
    private func showUsingAnimation(animated:Bool) {
        self.bezelView.layer.removeAllAnimations()
        self.backgroundView.layer.removeAllAnimations()
        
        self.hideDelayTimer?.invalidate()
        
        self.alpha = 1.0
        
//        self.progressObjectDisplayLink = nil;
        
        if(animated){
            
        }else{
            self.bezelView.alpha = 1.0;
            self.backgroundView.alpha = 1.0;
        }

    }
    
    
}

