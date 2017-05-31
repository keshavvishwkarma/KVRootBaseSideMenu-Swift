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
        static public let toggleLeft   =  Notification.Name(rawValue: "ToggleLeftSideMenuNotification")
        static public let toggleRight  =  Notification.Name(rawValue: "ToggleRightSideMenuNotification")
        static public let close        =  Notification.Name(rawValue: "CloseSideMenuNotification")
    }
    
    @objc
    public enum SideMenuState: Int {
        case none, left, right
        init() {
            self = .none
        }
    }
    
    @objc
    public enum AnimationType: Int
    {
        case `default`, window, folding
        public init() {
            self = .`default`
        }
    }
    
}

@objc(KVRootBaseSideMenuDelegate)
public protocol KVRootBaseSideMenuDelegate: class {
    /**
     An optional delegation method that is fired before the KVMenuContainerView opens.
     */
    @objc optional func willOpenSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState)
    
    /**
     An optional delegation method that is fired after the KVMenuContainerView opened.
     */
    @objc optional func didOpenSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState)
    
    /**
     An optional delegation method that is fired before the KVMenuContainerView closes.
     */
    @objc optional func willCloseSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState)
    
    /**
     An optional delegation method that is fired after the KVMenuContainerView closed.
     */
    @objc optional func didCloseSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState)
}

@objc(KVMenuContainerView)
open class KVMenuContainerView: UIView
{
    // MARK: - Properties
    
    /// A KVRootBaseSideMenuDelegate property used to bind the delegation object.
    open weak var delegate: KVRootBaseSideMenuDelegate?
    
    open var animationType: KVSideMenu.AnimationType  = KVSideMenu.AnimationType()
    open var allowTapGesture : Bool = true
    open var allowPanGesture : Bool = true
    
    /// A Boolean property that indicates either left swipe is enables or disables .
    open var allowLeftPaning: Bool = false {
        didSet{
            rightContainerView.subviews.first?.removeFromSuperview()
        }
    }
    
    /// A Boolean property that indicates either right swipe is enables or disables .
    open var allowRightPaning : Bool = false {
        didSet{
            leftContainerView.subviews.first?.removeFromSuperview()
        }
    }
    
    /**
     A CGFloat property that accesses the leftContainerView and
     rightContainerView threshold of the KVMenuContainerView.
     
     When the panning gesture has ended, if the position is
     beyond the threshold, either left or right side menu
     is opened, if it is below the threshold, the side menu is closed.
     */
    fileprivate let thresholdFactor: CGFloat = 0.25
    
    open var KVSideMenuOffsetValueInRatio: CGFloat = 0.75
    open var KVSideMenuHideShowDuration  : CGFloat = 0.4
    
    fileprivate let transformScale = CGAffineTransform(scaleX: 1.0, y: 0.8)
    
    open fileprivate(set) var leftContainerView  : UIView! = UIView.prepareAutoLayoutView()
    open fileprivate(set) var centerContainerView: UIView! = UIView.prepareAutoLayoutView()
    open fileprivate(set) var rightContainerView : UIView! = UIView.prepareAutoLayoutView()
    
    open fileprivate(set) var currentSideMenuState:KVSideMenu.SideMenuState = KVSideMenu.SideMenuState()
    
    fileprivate var appliedConstraint: NSLayoutConstraint? // may be center, leading, trailling
    
    fileprivate var panRecognizer: UIPanGestureRecognizer? {
        didSet {
            panRecognizer?.delegate = self
            panRecognizer?.maximumNumberOfTouches = 1
            addGestureRecognizer(panRecognizer!)
        }
    }
    
    fileprivate var tapRecognizer : UITapGestureRecognizer? {
        didSet {
            tapRecognizer?.delegate = self
            addGestureRecognizer(tapRecognizer!)
        }
    }
    
    // MARK: - Initialization
    
    required public init(superView:UIView!)
    {
        self.init()
        
        prepareAutoLayoutView()
        backgroundColor = UIColor.clear
        superView.addSubview(self)
        superView.clipsToBounds = true
        
        // apply constraints vai oprator overloading.
        self +== [.height, .width, .centerX, .centerY]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }
    
    fileprivate func initialise()
    {
        registerNotifications()
        setupGestureRecognizer()
        
        leftContainerView.backgroundColor   = backgroundColor
        centerContainerView.backgroundColor = backgroundColor
        rightContainerView.backgroundColor  = backgroundColor
        
        // addSubview order maitter for side shadow
        addSubview(leftContainerView)
        addSubview(rightContainerView)
        addSubview(centerContainerView)
        
        // apply constraints vai oprator overloading.
        leftContainerView   +== [ .top, .bottom ]
        centerContainerView +== [ .top, .bottom, .width, .centerX ]
        rightContainerView  +== [ .top, .bottom ]
        
        leftContainerView  *== ( .width, KVSideMenuOffsetValueInRatio )
        rightContainerView *== ( .width, KVSideMenuOffsetValueInRatio )
        
        leftContainerView   |==| ( .trailing, .leading, centerContainerView )
        centerContainerView |==| ( .trailing, .leading, rightContainerView  )
        
    }
    
    // MARK: - Deinitialization
    
    deinit {
        unRegisterNotifications()
    }
    
    /// A method that is used to close the side menu if the menu is showed.
    open func closeSideMenu()
    {
        switch (currentSideMenuState)
        {
        case .left:  self.toggleLeftSideMenu()
        case .right: self.toggleRightSideMenu()
        default: appliedConstraint?.constant = 0
        }
        
        applyAnimations({
            self.centerContainerView.transform = CGAffineTransform.identity
        })
        
    }
    
    /**
     A method that opens or closes the left side menu &
     toggles it's current state either Left or None too.
     */
    open func toggleLeftSideMenu()
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
    open func toggleRightSideMenu()
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
    final func toggleSideMenu(_ isLeft:Bool)
    {
        let constraintView = isLeft ? leftContainerView         : rightContainerView
        let attribute      = isLeft ? NSLayoutAttribute.leading : NSLayoutAttribute.trailing
        
        endEditing(true)
        
        if isLeft {
            if (currentSideMenuState == .right) {
                closeOpenedSideMenu(rightContainerView, attribute: .trailing)
            }
        }
        else{
            if (currentSideMenuState == .left) {
                closeOpenedSideMenu(leftContainerView, attribute: .leading)
            }
        }
        
        centerContainerView.accessAppliedConstraintBy(attribute: .centerX) { appliedConstraint in
            if appliedConstraint != nil {
                // debugPrint("will_Opened_SideMenu")
                // debugPrint(self.currentSideMenuState.rawValue)
                self.delegate?.willOpenSideMenuView?(self, state: self.currentSideMenuState)
                
                self.currentSideMenuState = isLeft ? .left : .right
                (constraintView?.superview!)! - appliedConstraint!
                constraintView! +== attribute
                
                self.handelTransformAnimations {
                    // debugPrint(self.currentSideMenuState.rawValue)
                    // debugPrint("did_Opened_SideMenu")
                    self.delegate?.didOpenSideMenuView?(self, state: self.currentSideMenuState)
                }
            }
            else {
                // debugPrint("will_Closed_SideMenu")
                // debugPrint(self.currentSideMenuState.rawValue)
                self.delegate?.willCloseSideMenuView?(self, state: self.currentSideMenuState)
                
                self.closeOpenedSideMenu(constraintView!, attribute: attribute) { _ in
                    self.applyAnimations {
                        self.centerContainerView.transform = CGAffineTransform.identity
                        
                        // debugPrint("did_Closed_SideMenu")
                        // debugPrint(self.currentSideMenuState.rawValue)
                        self.delegate?.didCloseSideMenuView?(self, state: self.currentSideMenuState)
                        
                    }
                }
            }
        }
        
    }
    
    final func closeOpenedSideMenu(_ view:UIView, attribute attr: NSLayoutAttribute, completion: ((Void) -> Void)? = nil )
    {
        view.accessAppliedConstraintBy(attribute: attr, completionHandler: { (appliedConstraint) -> Void in
            if appliedConstraint != nil {
                self.currentSideMenuState = .none
                view.superview! - appliedConstraint!
                self.centerContainerView +== [.top, .centerX, .bottom]
                if completion == nil {
                    self.layoutIfNeeded()
                    self.setNeedsLayout()
                }else{
                    completion?()
                }
            }
        })
    }
    
    /// A method that will handel transform & animations too.
    final func handelTransformAnimations(_ completionHandler: ((Void) -> Void)? = nil)
    {
        if self.animationType == KVSideMenu.AnimationType.window {
            // update Top And Bottom Pin Constraints Of SideMenu
            (centerContainerView +== .bottom).constant = -22.5
            (centerContainerView +== .top).constant    = 22.5
            // this valus is fixed for orientation so try to avoid it
        }
        
        self.applyAnimations {
            
            if self.animationType == KVSideMenu.AnimationType.folding {
                self.applyTransformAnimations(self.centerContainerView, transform_d: self.transformScale.d )
            }
            else if self.animationType == KVSideMenu.AnimationType.window {
                self.applyTransform3DAnimations(self.centerContainerView, transformRotatingAngle: 22.5)
            }
            else{
                
            }
            
            completionHandler?()
        }
    }
    
}

private extension KVMenuContainerView
{
    final func registerNotifications()
    {
        let selector: Selector = #selector(KVMenuContainerView.didReceivedNotification(_:))
        NotificationCenter.default.addObserver(self, selector: selector, name:KVSideMenu.Notifications.toggleLeft, object: nil)
        NotificationCenter.default.addObserver(self, selector: selector, name:KVSideMenu.Notifications.toggleRight, object: nil)
        NotificationCenter.default.addObserver(self, selector: selector, name:KVSideMenu.Notifications.close, object: nil)
    }
    
    final func unRegisterNotifications()
    {
        NotificationCenter.default.removeObserver(self, name:KVSideMenu.Notifications.close, object: nil)
        NotificationCenter.default.removeObserver(self, name:KVSideMenu.Notifications.toggleLeft, object: nil)
        NotificationCenter.default.removeObserver(self, name:KVSideMenu.Notifications.toggleRight, object: nil)
    }
    
    // Must be public or internal but not private other wise app will crashed.
    @objc func didReceivedNotification(_ notify:Notification)
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
    
    fileprivate func setupGestureRecognizer()
    {
        if allowPanGesture {
            panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(KVMenuContainerView.handlePanGesture(_:)))
        }
        
        if allowTapGesture {
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(KVMenuContainerView.closeSideMenu))
        }
        
    }
    
    fileprivate dynamic func handlePanGesture(_ recognizer: UIPanGestureRecognizer)
    {
        let translation = recognizer.translation(in: recognizer.view)
        
        switch(recognizer.state)
        {
        case .began:
            switch (currentSideMenuState)
            {
            case .left:
                appliedConstraint = leftContainerView.accessAppliedConstraintBy(attribute: .leading)
            case .right:
                appliedConstraint = rightContainerView.accessAppliedConstraintBy(attribute: .trailing)
            default:
                appliedConstraint = centerContainerView.accessAppliedConstraintBy(attribute: .centerX)
            }
            
        case .changed:
            
            if appliedConstraint != nil {
                var xPoint : CGFloat = appliedConstraint!.constant + translation.x
                
                switch (currentSideMenuState)
                {
                case .left:
                    xPoint = max(-leftContainerView.bounds.width, min(CGFloat(xPoint), 0))
                    
                case .right:
                    xPoint = max(0, min(CGFloat(xPoint), rightContainerView.bounds.width))
                    
                default:
                    
                    if allowLeftPaning && allowRightPaning {
                        xPoint = max(-rightContainerView.bounds.width, min(CGFloat(xPoint), leftContainerView.bounds.width))
                    }
                    else if allowLeftPaning {
                        xPoint = max(-leftContainerView.bounds.width, min(CGFloat(xPoint), 0))
                    }
                    else if allowRightPaning {
                        xPoint = max(0, min(CGFloat(xPoint), rightContainerView.bounds.width))
                    }
                    else {
                        xPoint = max(0, min(CGFloat(xPoint), 0))
                    }
                    
                }
                
                if animationType == KVSideMenu.AnimationType.folding
                {
                    let dy = abs(CGFloat(Int(xPoint)))*(1.0 - transformScale.d)/leftContainerView.bounds.width
                    debugPrint(dy)
                    
                    if (currentSideMenuState == .left || currentSideMenuState == .right) {
                        applyTransformAnimations(centerContainerView, transform_d: min(1.0, transformScale.d + dy))
                    }
                    else{
                        applyTransformAnimations(centerContainerView, transform_d: min(1.0, abs(1-dy)) )
                    }
                }
                
                self.appliedConstraint?.constant = CGFloat(Int(xPoint))
                recognizer.setTranslation(CGPoint.zero, in: self)
            }
            
        default:
            
            let constaint = appliedConstraint?.constant ?? 0
            
            switch (currentSideMenuState)
            {
            case .left:     // Negative value
                if abs(constaint) > leftContainerView.bounds.width*thresholdFactor {
                    self.toggleLeftSideMenu();
                }else{
                    // Keep open left SideMenu here
                    self.appliedConstraint?.constant = 0
                    self.handelTransformAnimations()
                }
                
            case .right:    // Possitive value
                if constaint > rightContainerView.bounds.width*thresholdFactor {
                    self.toggleRightSideMenu();
                }else{
                    // Keep open right SideMenu here
                    self.appliedConstraint?.constant = 0
                    self.handelTransformAnimations()
                }
                
            default:  // None state
                if constaint > 0
                {
                    if constaint > leftContainerView.bounds.width*thresholdFactor {
                        self.toggleLeftSideMenu();
                    }else{
                        self.closeSideMenu()
                    }
                }
                else if constaint < 0
                {
                    if abs(constaint) > rightContainerView.bounds.width*thresholdFactor {
                        self.toggleRightSideMenu();
                    }else{
                        self.closeSideMenu()
                    }
                }
            }
            
            appliedConstraint = nil
        }
        
    }
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panRecognizer {
            return (allowPanGesture && (allowLeftPaning || allowRightPaning ))
        }
        
        if gestureRecognizer == tapRecognizer {
            return currentSideMenuState != .none && allowTapGesture && self.centerContainerView.frame.contains(gestureRecognizer.location(in: gestureRecognizer.view))
        }
        
        return false
    }
    
}

// MARK: -  Helpper methods to apply animation & shadow with SideMenu

private extension KVMenuContainerView
{
    final func applyAnimations(_ completionHandler: ((Void) -> Void)? = nil)
    {
        // let options : UIViewAnimationOptions = [.AllowUserInteraction, .OverrideInheritedCurve, .LayoutSubviews, .BeginFromCurrentState, .CurveEaseOut]
        
        let options : UIViewAnimationOptions = [.allowUserInteraction, .layoutSubviews, .beginFromCurrentState, .curveLinear, .curveEaseOut]
        let duration = TimeInterval(self.KVSideMenuHideShowDuration)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 10, options: options, animations: { _ in
            self.layoutIfNeeded()
            self.setNeedsLayout()
            self.setNeedsUpdateConstraints()
            self.applyShadow(self.centerContainerView)
            completionHandler?()
        })
    }
    
    final func applyTransformAnimations(_ view:UIView!,transform_d:CGFloat) {
        view.transform.d = transform_d
    }
    
    final func applyTransform3DAnimations(_ view:UIView!,transformRotatingAngle:CGFloat)
    {
        let layerTemp : CALayer = view.layer
        layerTemp.zPosition = 1000
        
        var tRotate : CATransform3D = CATransform3DIdentity
        tRotate.m34 = 1.0/(500)
        
        let aXpos: CGFloat = CGFloat(22.5*((currentSideMenuState == .right) ? -1.0 : 1.0)*(Double.pi/180))
        tRotate = CATransform3DRotate(tRotate,aXpos, 0, 1, 0)
        layerTemp.transform = tRotate
        
    }
    
    // MARK: -  Helpper methods to apply shadow with SideMenu
    
    final func applyShadow(_ shadowView:UIView)
    {
        let shadowViewLayer : CALayer = shadowView.layer
        shadowViewLayer.shadowColor = shadowView.backgroundColor?.cgColor
        shadowViewLayer.shadowOpacity = 0.4
        shadowViewLayer.shadowRadius = 4.0
        shadowViewLayer.rasterizationScale = (self.window?.screen.scale)!
        
        if (self.currentSideMenuState == .left) {
            shadowViewLayer.shadowOffset = CGSize(width: -2, height: 2)
        } else if (self.currentSideMenuState == .right){
            shadowViewLayer.shadowOffset = CGSize(width: 0, height: 2)
        } else {
            shadowViewLayer.shadowRadius = 3
            shadowViewLayer.shadowOpacity = 0
            shadowViewLayer.shadowOffset = CGSize(width: 0, height: -3)
            shadowViewLayer.shadowColor = nil
        }
    }
    
}
