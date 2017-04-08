//
//  KVCustomSegue.swift
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

import UIKit

public class KVRootBaseSideMenuViewController: UIViewController
{
    private typealias Key   = String
    private typealias Value = UIViewController
    
    private var rootObjects: [Key:Value] = [Key:Value]();
    
    public private(set) var menuContainerView: KVMenuContainerView?
    
    /// If **true** then we will always create a new instance of every root viewcontroller.
    ///
    /// If **false** then we will reuse already created root viewcontroller if exist otherwise create it.
    /// By default valus is **false**.
    @IBInspectable public var freshRoot : Bool = false
    
    @IBOutlet public var containerView: UIView?
    
    public var leftSideMenuViewController: UIViewController? {
        didSet {
            menuContainerView!.allowRightPaning = leftSideMenuViewController != nil
            self.addChildViewControllerOnContainerView(leftSideMenuViewController, containerView: menuContainerView!.leftContainerView)
        }
    }
    
    public var rightSideMenuViewController: UIViewController? {
        didSet{
            menuContainerView!.allowLeftPaning = rightSideMenuViewController != nil
            self.addChildViewControllerOnContainerView(rightSideMenuViewController, containerView: menuContainerView!.rightContainerView)
        }
    }
    
    private var visibleRootViewController: UIViewController? {
        didSet
        {
            if oldValue == nil {
                self.addChildViewControllerOnContainerView(self.visibleRootViewController, containerView:self.menuContainerView?.centerContainerView)
            }
            else if oldValue != visibleRootViewController
            {
                oldValue?.willMoveToParentViewController(nil)
                UIView.animateWithDuration(0, animations: { _ in }, completion: { _ in
                    dispatch_async(dispatch_get_main_queue(), {
                        oldValue?.view.removeFromSuperview()
                        oldValue?.didMoveToParentViewController(nil)
                        oldValue?.removeFromParentViewController()
                        self.addChildViewControllerOnContainerView(self.visibleRootViewController, containerView:self.menuContainerView?.centerContainerView)
                        
                    })
                })
            }
            else{
                debugPrint("both objects are same.")
            }
            
        }
    }
    
    override public func loadView() {
        super.loadView()
        self.menuContainerView = KVMenuContainerView(superView: (containerView == nil) ? self.view : containerView);
    }
    
    ///Returns a Boolean value that indicates, either the side menu is showed or closed.
    public func isSideMenuOpen () -> Bool {
        let sieMenuOpen = !(menuContainerView!.currentSideMenuState == .None)
        return sieMenuOpen
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("handleKeyboardNotification:"), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("handleKeyboardNotification:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    
    /// To switch the root of side menu controller.
    override public func changeSideMenuViewControllerRoot(rootIdentifier:String)
    {
        if shouldPerformSegueWithIdentifier(rootIdentifier, sender: self) {
            performSegueWithIdentifier(rootIdentifier, sender: self)
        }
    }
    
    override public func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let shouldPerformSegue  = super.shouldPerformSegueWithIdentifier(identifier, sender: sender);
        if (shouldPerformSegue)
        {
            // If root view controller, already exist in the rootObjects list then change to root only.
            // and sugue should be ignored
            if let value = rootObjects[identifier] {
                visibleRootViewController = value
                return false
            }
            
            // If root view controller, does not exist in the rootObjects list, that means
            // The segue should be performed to fetch destinationViewController obejct.
            // If sender is KVCustomSegue that means viewcontroller is first time going to be initialise.
            if (sender is KVCustomSegue) {
                setUpSideMenuRootBySegue((sender as! KVCustomSegue))
            }
        }
        
        return shouldPerformSegue;
    }
    
}

private extension KVRootBaseSideMenuViewController
{
    func setUpSideMenuRootBySegue(segue:KVCustomSegue)
    {
        if ( self == segue.sourceViewController )
        {
            // If freshRoot is true means allways prefere feresh root then we will always create a new instance for everry root viewcontrollers.
            // If freshRoot is false then we will reuse already created root view controller
            
            if freshRoot == false {
                if !(rootObjects.keys.contains(segue.identifier!)) {
                    rootObjects[segue.identifier!] = segue.destinationViewController
                }
                visibleRootViewController = rootObjects[segue.identifier!]
            }
            else{
                visibleRootViewController = segue.destinationViewController
            }
        }
        else {
            debugPrint("Both objects are distinct \(self), \(segue.sourceViewController)")
        }
    }
    
    
    // MARK: Keyboard Event Notifications
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        // Get information about the animation.
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let rawAnimationCurveValue = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).unsignedLongValue
        let animationCurve = UIViewAnimationOptions(rawValue: rawAnimationCurveValue)
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame   = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame   = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame     = view.convertRect(keyboardScreenEndFrame,   fromView: view.window)
        
        // Determine how far the keyboard has moved up or down.
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // Inform the view that its the layout should be updated.
        (menuContainerView!.leftContainerView   <- .Bottom)?.constant += originDelta
        (menuContainerView!.centerContainerView <- .Bottom)?.constant += originDelta
        (menuContainerView!.rightContainerView  <- .Bottom)?.constant += originDelta
        
        menuContainerView!.layoutIfNeeded()
        // Animate updating the view's layout by calling layoutIfNeeded inside a UIView animation block.
        let animationOptions: UIViewAnimationOptions = [animationCurve, .BeginFromCurrentState]
        UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}

public extension KVRootBaseSideMenuViewController {
    
    // MARK: To access the currently visible ViewController on the view of KVRootBaseSideMenuViewController.
    @warn_unused_result
    public func visibleViewController() -> UIViewController? {
        
        if visibleRootViewController is UINavigationController {
            return (visibleRootViewController as! UINavigationController).topViewController
            // return (visibleRootViewController as! UINavigationController).visibleViewController
        }
        else {
            return visibleRootViewController
        }
    }
    
}

// MARK:
public extension UIViewController {
    
    @warn_unused_result
    func sideMenuViewController() -> KVRootBaseSideMenuViewController?
    {
        var viewController:UIViewController? = ( self.parentViewController != nil) ? self.parentViewController : self.presentingViewController;
        
        while (!((viewController == nil ) || (viewController is KVRootBaseSideMenuViewController))) {
            viewController = ( viewController!.parentViewController != nil) ? viewController!.parentViewController : viewController!.presentingViewController;
        }
        
        return (viewController as! KVRootBaseSideMenuViewController)
    }
    
    /// To switch the root of side menu controller from any view controller.
    public func changeSideMenuViewControllerRoot(rootIdentifier:String)
    {
        if let sideMenuViewController = sideMenuViewController() {
            sideMenuViewController.changeSideMenuViewControllerRoot(rootIdentifier)
        }
    }
    
}

public extension UIViewController {
    
    public func addChildViewControllerOnContainerView(childViewController: UIViewController!, containerView: UIView!)
    {
        if childViewController != nil && containerView != nil
        {
            childViewController.view.frame = containerView.bounds
            self.addChildViewController(childViewController)
            containerView.addSubview(childViewController.view)
            childViewController.didMoveToParentViewController(self)
            containerView.bringSubviewToFront(childViewController.view)
            
            if (containerView.translatesAutoresizingMaskIntoConstraints) {
                childViewController.view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
            } else {
                let child = childViewController.view
                child!.prepareAutoLayoutView()
                
                // Apply Equal relation constrains to its parent view.
                child +== [.CenterX, .CenterY, .Height, .Width]
            }
        }
        
    }
}
