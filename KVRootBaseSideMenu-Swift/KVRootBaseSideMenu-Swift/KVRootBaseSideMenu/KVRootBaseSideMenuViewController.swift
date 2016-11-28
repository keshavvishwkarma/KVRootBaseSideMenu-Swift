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

open class KVRootBaseSideMenuViewController: UIViewController
{
    fileprivate typealias Key   = String
    fileprivate typealias Value = UIViewController
    
    fileprivate var rootObjects: [Key:Value] = [Key:Value]();
    
    fileprivate(set) var menuContainerView: KVMenuContainerView?
    
    /// If **true** then we will always create a new instance of every root viewcontroller.
    ///
    /// If **false** then we will reuse already created root viewcontroller if exist otherwise create it.
    /// By default valus is **false**.
    @IBInspectable open var freshRoot : Bool = false
    
    @IBOutlet open var containerView: UIView?
    
    open var leftSideMenuViewController: UIViewController? {
        didSet {
            menuContainerView!.allowRightPaning = leftSideMenuViewController != nil
            self.addChildViewControllerOnContainerView(leftSideMenuViewController, containerView: menuContainerView!.leftContainerView)
        }
    }
    
    open var rightSideMenuViewController: UIViewController? {
        didSet{
            menuContainerView!.allowLeftPaning = rightSideMenuViewController != nil
            self.addChildViewControllerOnContainerView(rightSideMenuViewController, containerView: menuContainerView!.rightContainerView)
        }
    }
    
    fileprivate var visibleRootViewController: UIViewController? {
        didSet
        {
            if oldValue == nil {
                self.addChildViewControllerOnContainerView(self.visibleRootViewController, containerView:self.menuContainerView?.centerContainerView)
            }
            else if oldValue != visibleRootViewController
            {
                oldValue?.willMove(toParentViewController: nil)
                oldValue?.removeFromParentViewController()
                
                UIView.animate(withDuration: 0, animations: { _ in }, completion: { _ in
                    DispatchQueue.main.async(execute: {
                        
                        oldValue?.view.removeFromSuperview()
                        oldValue?.didMove(toParentViewController: nil)
                        self.addChildViewControllerOnContainerView(self.visibleRootViewController, containerView:self.menuContainerView?.centerContainerView)
                        
                    })
                })
            }
            else{
                debugPrint("both objects are same.")
            }
            
        }
    }
    
    override open func loadView() {
        super.loadView()
        self.menuContainerView = KVMenuContainerView(superView: (containerView == nil) ? self.view : containerView);
    }
    
    ///Returns a Boolean value that indicates, either the side menu is showed or closed.
    open func isSideMenuOpen () -> Bool {
        let sieMenuOpen = !(menuContainerView!.currentSideMenuState == .none)
        return sieMenuOpen
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(KVRootBaseSideMenuViewController.handleKeyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(KVRootBaseSideMenuViewController.handleKeyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    /// To switch the root of side menu controller.
    override open func changeSideMenuViewControllerRoot(_ rootIdentifier:String)
    {
        if shouldPerformSegue(withIdentifier: rootIdentifier, sender: self) {
            performSegue(withIdentifier: rootIdentifier, sender: self)
        }
    }
    
    override open func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let shouldPerformSegue  = super.shouldPerformSegue(withIdentifier: identifier, sender: sender);
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
    func setUpSideMenuRootBySegue(_ segue:KVCustomSegue)
    {
        if ( self == segue.source )
        {
            // If freshRoot is true means allways prefere feresh root then we will always create a new instance for everry root viewcontrollers.
            // If freshRoot is false then we will reuse already created root view controller
            
            if freshRoot == false {
                if !(rootObjects.keys.contains(segue.identifier!)) {
                    rootObjects[segue.identifier!] = segue.destination
                }
                visibleRootViewController = rootObjects[segue.identifier!]
            }
            else{
                visibleRootViewController = segue.destination
            }
        }
        else {
            debugPrint("Both objects are distinct \(self), \(segue.source)")
        }
    }
    
    
    // MARK: Keyboard Event Notifications
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        
        // Get information about the animation.
        let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let rawAnimationCurveValue = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).uintValue
        let animationCurve = UIViewAnimationOptions(rawValue: rawAnimationCurveValue)
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardScreenEndFrame   = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardViewBeginFrame   = view.convert(keyboardScreenBeginFrame, from: view.window)
        let keyboardViewEndFrame     = view.convert(keyboardScreenEndFrame,   from: view.window)
        
        // Determine how far the keyboard has moved up or down.
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // Inform the view that its the layout should be updated.
        (menuContainerView!.leftContainerView   <- .bottom)?.constant += originDelta
        (menuContainerView!.centerContainerView <- .bottom)?.constant += originDelta
        (menuContainerView!.rightContainerView  <- .bottom)?.constant += originDelta
        
        menuContainerView!.layoutIfNeeded()
        // Animate updating the view's layout by calling layoutIfNeeded inside a UIView animation block.
        let animationOptions: UIViewAnimationOptions = [animationCurve, .beginFromCurrentState]
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}

public extension KVRootBaseSideMenuViewController {
    
    // MARK: To access the currently visible ViewController on the view of KVRootBaseSideMenuViewController.
    
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
    
    
    func sideMenuViewController() -> KVRootBaseSideMenuViewController?
    {
        var viewController:UIViewController? = ( self.parent != nil) ? self.parent : self.presentingViewController;
        
        while (!((viewController == nil ) || (viewController is KVRootBaseSideMenuViewController))) {
            viewController = ( viewController!.parent != nil) ? viewController!.parent : viewController!.presentingViewController;
        }
        
        return (viewController as! KVRootBaseSideMenuViewController)
    }
    
    /// To switch the root of side menu controller from any view controller.
    public func changeSideMenuViewControllerRoot(_ rootIdentifier:String)
    {
        if let sideMenuViewController = sideMenuViewController() {
            sideMenuViewController.changeSideMenuViewControllerRoot(rootIdentifier)
        }
    }
    
}

public extension UIViewController {
    
    public func addChildViewControllerOnContainerView(_ childViewController: UIViewController!, containerView: UIView!)
    {
        if childViewController != nil && containerView != nil
        {
            childViewController.view.frame = containerView.bounds
            self.addChildViewController(childViewController)
            containerView.addSubview(childViewController.view)
            childViewController.didMove(toParentViewController: self)
            containerView.bringSubview(toFront: childViewController.view)
            
            if (containerView.translatesAutoresizingMaskIntoConstraints) {
                childViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            } else {
                let child = childViewController.view
                child!.prepareViewForAutoLayout()
                
                // Apply Equal relation constrains to its parent view.
                child! +== [.centerX, .centerY, .height, .width]
            }
        }
        
    }
}
