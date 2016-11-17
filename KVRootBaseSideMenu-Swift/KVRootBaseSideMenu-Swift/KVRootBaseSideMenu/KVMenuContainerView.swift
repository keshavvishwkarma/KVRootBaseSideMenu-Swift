//
//  KVMenuContainerView.swift
//  https://github.com/keshavvishwkarma/KVRootBaseSideMenu-Swift.git
//
//  Distributed under the MIT License.
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//

import UIKit

public struct KVSideMenu
{
    public struct Notifications {
        static public let toggleLeft   = "ToggleLeftSideMenuNotification"
        static public let toggleRight  = "ToggleRightSideMenuNotification"
        static public let close        = "CloseSideMenuNotification"
    }
    
    enum SideMenuState {
        case None, Left, Right
        init() {
            self = None
        }
    }
    
    public enum AnimationType
    {
        case Default, Window, Folding
        public init() {
            self = Default
        }
    }
    
}

public class KVMenuContainerView: UIView
{
    // MARK: - Properties
    
    private let thresholdFactor: CGFloat = 0.25
    public var KVSideMenuOffsetValueInRatio : CGFloat = 0.75
    public var KVSideMenuHideShowDuration   : CGFloat = 0.4
    
    private let transformScale:CGAffineTransform = CGAffineTransformMakeScale(1.0, 0.8)
    
    private(set) var leftContainerView   :UIView! = UIView.prepareNewViewForAutoLayout()
    private(set) var centerContainerView :UIView! = UIView.prepareNewViewForAutoLayout()
    private(set) var rightContainerView  :UIView! = UIView.prepareNewViewForAutoLayout()
    
    private(set) var currentSideMenuState:KVSideMenu.SideMenuState = KVSideMenu.SideMenuState()
    
    private var appliedConstraint : NSLayoutConstraint? // may be center, leading, trailling
    private var panRecognizer     : UIPanGestureRecognizer? {
        didSet {
            panRecognizer?.delegate = self
            panRecognizer?.maximumNumberOfTouches = 1
            addGestureRecognizer(panRecognizer!)
        }
    }
    
    public var animationType   = KVSideMenu.AnimationType()
    public var allowPanGesture :    Bool = true
    
    /// A Boolean value indicating whether the left swipe is enabled.
    public var allowLeftPaning  : Bool = false {
        didSet{
            rightContainerView.subviews.first?.removeFromSuperview()
        }
    }
    
    /// A Boolean value indicating whether the right swipe is enabled.
    public var allowRightPaning : Bool = false {
        didSet{
            leftContainerView.subviews.first?.removeFromSuperview()
        }
    }
    
    // MARK: - Initialization
    
    required public init(superView:UIView!)
    {
        self.init()
        
        prepareViewForAutoLayout()
        backgroundColor = UIColor.clearColor()
        superView.addSubview(self)
        superView.clipsToBounds = true
        
        // apply constraints vai oprator overloading.
        self +== [.Height, .Width, .CenterX, .CenterY]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }
    
    private func initialise()
    {
        registerNotifications()

        setupGestureRecognizer()
        
        clipsToBounds = false
        
        leftContainerView.backgroundColor   = backgroundColor
        centerContainerView.backgroundColor = backgroundColor
        rightContainerView.backgroundColor  = backgroundColor
        
        // addSubview order maitter for side shadow
        addSubview(leftContainerView)
        addSubview(rightContainerView)
        addSubview(centerContainerView)
        
        // apply constraints vai oprator overloading.
        leftContainerView   +== [ .Top, .Bottom ]
        centerContainerView +== [ .Top, .Bottom, .Width, .CenterX ]
        rightContainerView  +== [ .Top, .Bottom ]
        
        leftContainerView  +*== ( .Width, KVSideMenuOffsetValueInRatio )
        rightContainerView +*== ( .Width, KVSideMenuOffsetValueInRatio )
        
        leftContainerView   <==> (.Trailing, .Leading, centerContainerView, 0)
        centerContainerView <==> (.Trailing, .Leading, rightContainerView,  0)
        
    }
    
    // MARK: - Deinitialization
    
    deinit
    {
        unRegisterNotifications()
    }
    
    /// A method that closes the side menu if the menu is showed.
    public func closeSideMenu()
    {
        switch (currentSideMenuState)
        {
        case .Left:  closeOpenedSideMenu(leftContainerView,  attribute: .Leading)
        case .Right: closeOpenedSideMenu(rightContainerView, attribute: .Trailing)
            
        default: appliedConstraint?.constant = 0
                 applyAnimations({
                    self.centerContainerView.transform = CGAffineTransformIdentity
                 })
        }
        
    }
    
    /**
     A method that opens or closes the left side menu &
     toggles it's current state either Left or None too.
     */
    public func toggleLeftSideMenu()
    {
        if allowRightPaning {
            toggleSideMenu(true)
        }
        else {
            debugPrint("Left SideMenu has beed disable, because leftSideMenuViewController is nil.")
        }
        
    }
    
    /**
     A method that opens or closes the right side menu &
     toggles it's current state either Right or None too.
     */
    public func toggleRightSideMenu()
    {
        if allowLeftPaning {
            toggleSideMenu(false)
        }
        else{
            debugPrint("Right SideMenu has beed disable, because rightSideMenuViewController is nil.")
        }
    }
    
}

// MARK: -  Helpper methods to Open & Close the SideMenu

private extension KVMenuContainerView
{
    final func toggleSideMenu(isLeft:Bool)
    {
        let constraintView = isLeft ? leftContainerView         : rightContainerView
        let attribute      = isLeft ? NSLayoutAttribute.Leading : NSLayoutAttribute.Trailing
        
        endEditing(true)
        backgroundColor = constraintView.subviews.first?.backgroundColor
        
        if isLeft {
            if (currentSideMenuState == .Right) {
                closeOpenedSideMenu(rightContainerView, attribute: .Trailing)
            }
        }
        else{
            if (currentSideMenuState == .Left) {
                closeOpenedSideMenu(leftContainerView, attribute: .Leading)
            }
        }
        
        centerContainerView.accessAppliedConstraintBy(attribute: .CenterX) { appliedConstraint in
            if appliedConstraint != nil {
                
                self.currentSideMenuState = isLeft ? .Left : .Right
                self.centerContainerView.superview! - appliedConstraint!
                constraintView +== attribute
                
                self.handelTransformAnimations()
            }
            else {

                self.closeOpenedSideMenu(constraintView, attribute: attribute, completion: { _ in
                    self.applyAnimations({
                        self.centerContainerView.transform = CGAffineTransformIdentity
                    })
                })
            }
        }
        
    }
    
    final func closeOpenedSideMenu(view:UIView, attribute attr: NSLayoutAttribute, completion: (Void -> Void)? = nil )
    {
        view.accessAppliedConstraintBy(attribute: attr, completionHandler: { (appliedConstraint) -> Void in
            if appliedConstraint != nil {
                self.currentSideMenuState = .None
                view.superview! - appliedConstraint!
                self.centerContainerView +== [.Top, .CenterX, .Bottom]
                if completion == nil {
                    self.layoutIfNeeded()
                    self.setNeedsLayout()
                }else{
                    completion?()
                }
            }
        })
    }
    
    final func handelTransformAnimations()
    {
        if self.animationType == KVSideMenu.AnimationType.Window
        {
            // update Top And Bottom Pin Constraints Of SideMenu
            (centerContainerView +== .Bottom).constant = -22.5
            (centerContainerView +== .Top).constant    = 22.5
            // this valus is fixed for orientation so try to avoid it
        }
        
        self.applyAnimations({
            
            if self.animationType == KVSideMenu.AnimationType.Folding
            {
                self.applyTransformAnimations(self.centerContainerView, transform_d: self.transformScale.d )
            }
            else if self.animationType == KVSideMenu.AnimationType.Window
            {
                self.applyTransform3DAnimations(self.centerContainerView, transformRotatingAngle: 22.5)
            }
            else{
                
            }
        })
    }
    
}

extension KVMenuContainerView
{
    func registerNotifications()
    {
        let selector: Selector = Selector("didReceivedNotification:")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name:KVSideMenu.Notifications.toggleLeft, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name:KVSideMenu.Notifications.toggleRight, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name:KVSideMenu.Notifications.close, object: nil)
    }
    
    func unRegisterNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:KVSideMenu.Notifications.close, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:KVSideMenu.Notifications.toggleLeft, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:KVSideMenu.Notifications.toggleRight, object: nil)
    }
    
    // Must be public or internal but not private other wise app will crashed.
    @objc func didReceivedNotification(notify:NSNotification)
    {
        if (notify.name == KVSideMenu.Notifications.toggleLeft) {
            toggleLeftSideMenu()
        } else if (notify.name == KVSideMenu.Notifications.toggleRight) {
            toggleRightSideMenu()
        } else if (notify.name == KVSideMenu.Notifications.close) {
            closeSideMenu()
        }
        else{
            
        }
    }
    
}

// MARK: -  Helpper Methods to Open & Close the SideMenu

extension KVMenuContainerView: UIGestureRecognizerDelegate
{
    // MARK: Gesture recognizer
    
    private func setupGestureRecognizer()
    {
        if allowPanGesture {
            panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        }
    }
    
    private dynamic func handlePanGesture(recognizer: UIPanGestureRecognizer)
    {
        let translation = recognizer.translationInView(recognizer.view)
        
        switch(recognizer.state)
        {
        case .Began:
            switch (currentSideMenuState)
            {
            case .Left:
                appliedConstraint = leftContainerView.accessAppliedConstraintBy(attribute: .Leading)
            case .Right:
                appliedConstraint = rightContainerView.accessAppliedConstraintBy(attribute: .Trailing)
            default:
                appliedConstraint = centerContainerView.accessAppliedConstraintBy(attribute: .CenterX)
            }
            
        case .Changed:
            
            if appliedConstraint != nil {
                var xPoint : CGFloat = appliedConstraint!.constant + translation.x
                
                switch (currentSideMenuState)
                {
                case .Left:
                    xPoint = max(-CGRectGetWidth(leftContainerView.bounds), min(CGFloat(xPoint), 0))
                    
                case .Right:
                    xPoint = max(0, min(CGFloat(xPoint), CGRectGetWidth(rightContainerView.bounds)))
                    
                default:
                    
                    if allowLeftPaning && allowRightPaning {
                        xPoint = max(-CGRectGetWidth(rightContainerView.bounds), min(CGFloat(xPoint), CGRectGetWidth(leftContainerView.bounds)))
                    }
                    else if allowLeftPaning {
                        xPoint = max(-CGRectGetWidth(leftContainerView.bounds), min(CGFloat(xPoint), 0))
                    }
                    else if allowRightPaning {
                        xPoint = max(0, min(CGFloat(xPoint), CGRectGetWidth(rightContainerView.bounds)))
                    }
                    else {
                        xPoint = max(0, min(CGFloat(xPoint), 0))
                    }
                    
                }
                
                if animationType == KVSideMenu.AnimationType.Folding
                {
                    let dy = abs(CGFloat(Int(xPoint)))*(1.0 - transformScale.d)/CGRectGetWidth(leftContainerView.bounds)
                    debugPrint(dy)
                    
                    if (currentSideMenuState == .Left || currentSideMenuState == .Right) {
                        applyTransformAnimations(centerContainerView, transform_d: min(1.0, transformScale.d + dy))
                    }
                    else{
                        applyTransformAnimations(centerContainerView, transform_d: min(1.0, abs(1-dy)) )
                    }
                }
                
                self.appliedConstraint?.constant = CGFloat(Int(xPoint))
                recognizer.setTranslation(CGPointZero, inView: self)
            }
            
        default:
            
            let constaint = appliedConstraint?.constant ?? 0
            
            switch (currentSideMenuState)
            {
            case .Left:     // Negative value
                if abs(constaint) > CGRectGetWidth(leftContainerView.bounds)*thresholdFactor {
                    self.toggleLeftSideMenu();
                }else{
                    // Keep open left SideMenu here
                    self.appliedConstraint?.constant = 0
                    self.handelTransformAnimations()
                }
                
            case .Right:    // Possitive value
                if constaint > CGRectGetWidth(rightContainerView.bounds)*thresholdFactor {
                    self.toggleRightSideMenu();
                }else{
                    // Keep open right SideMenu here
                    self.appliedConstraint?.constant = 0
                    self.handelTransformAnimations()
                }
                
            default:  // None state
                if constaint > 0
                {
                    if constaint > CGRectGetWidth(leftContainerView.bounds)*thresholdFactor {
                        self.toggleLeftSideMenu();
                    }else{
                        self.closeSideMenu()
                    }
                }
                else if constaint < 0
                {
                    if abs(constaint) > CGRectGetWidth(rightContainerView.bounds)*thresholdFactor {
                        self.toggleRightSideMenu();
                    }else{
                        self.closeSideMenu()
                    }
                }
            }
            
            appliedConstraint = nil
        }
        
    }
    
    override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panRecognizer {
            return (allowPanGesture && (allowLeftPaning || allowRightPaning ))
        }
        
        return false
    }
    
}

// MARK: -  Helpper methods to apply animation & shadow with SideMenu

private extension KVMenuContainerView
{
    final func applyAnimations(completionHandler: (Void -> Void)? = nil)
    {
        // let options : UIViewAnimationOptions = [.AllowUserInteraction, .OverrideInheritedCurve, .LayoutSubviews, .BeginFromCurrentState, .CurveEaseOut]
        
        let options : UIViewAnimationOptions = [.AllowUserInteraction, .LayoutSubviews, .BeginFromCurrentState, .CurveLinear, .CurveEaseOut]
        let duration = NSTimeInterval(self.KVSideMenuHideShowDuration)
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 10, options: options, animations: { _ in
            self.layoutIfNeeded()
            self.setNeedsLayout()
            self.setNeedsUpdateConstraints()
            self.applyShadow(self.centerContainerView)
            completionHandler?()
            }, completion: nil)
    }
    
    final func applyTransformAnimations(view:UIView!,transform_d:CGFloat) {
        view.transform.d = transform_d
    }
    
    final func applyTransform3DAnimations(view:UIView!,transformRotatingAngle:CGFloat)
    {
        let layerTemp : CALayer = view.layer
        layerTemp.zPosition = 1000
        
        var tRotate : CATransform3D = CATransform3DIdentity
        tRotate.m34 = 1.0/(500)
        
        let aXpos: CGFloat = CGFloat(22.5*((currentSideMenuState == .Right) ? -1.0 : 1.0)*(M_PI/180))
        tRotate = CATransform3DRotate(tRotate,aXpos, 0, 1, 0)
        layerTemp.transform = tRotate
        
    }
    
    // MARK: -  Helpper methods to apply shadow with SideMenu
    
    final func applyShadow(shadowView:UIView)
    {
        let shadowViewLayer : CALayer = shadowView.layer
        shadowViewLayer.shadowColor = shadowView.backgroundColor?.CGColor
        shadowViewLayer.shadowOpacity = 0.4
        shadowViewLayer.shadowRadius = 4.0
        shadowViewLayer.rasterizationScale = (self.window?.screen.scale)!
        
        if (self.currentSideMenuState == .Left) {
            shadowViewLayer.shadowOffset = CGSizeMake(-2, 2)
        } else if (self.currentSideMenuState == .Right){
            shadowViewLayer.shadowOffset = CGSizeMake(0, 2)
        } else {
            shadowViewLayer.shadowRadius = 3
            shadowViewLayer.shadowOpacity = 0
            shadowViewLayer.shadowOffset = CGSizeMake(0, -3)
            shadowViewLayer.shadowColor = nil
        }
    }
    
    
}
