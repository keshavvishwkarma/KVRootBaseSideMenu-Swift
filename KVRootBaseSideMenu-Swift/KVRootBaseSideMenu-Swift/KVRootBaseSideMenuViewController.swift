//
//  KVRootBaseSideMenuViewController.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import UIKit

public class KVRootBaseSideMenuViewController: UIViewController
{
    private typealias Key   = String
    private typealias Value = UIViewController
    
    private var rootObjects: [Key:Value] = [Key:Value]();
    
    private var menuContainerView: KVMenuContainerView?
    
    public var leftSideMenuViewController: UIViewController? {
        didSet {
            menuContainerView!.allowRightSwipe = leftSideMenuViewController != nil
            self.addChildViewControllerOnContainerView(leftSideMenuViewController, containerView: menuContainerView!.leftContainerView)
        }
    }
    
    public var rightSideMenuViewController: UIViewController? {
        didSet{
            menuContainerView!.allowLeftSwipe = rightSideMenuViewController != nil
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
                oldValue?.removeFromParentViewController()
                
                UIView.animateWithDuration(0, animations: { _ in }, completion: { _ in
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        oldValue?.view.removeFromSuperview()
                        oldValue?.didMoveToParentViewController(nil)
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
        self.menuContainerView = KVMenuContainerView(superView: self.view);
    }
    
    override public func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let shouldPerformSegue  = super.shouldPerformSegueWithIdentifier(identifier, sender: sender);
        if (shouldPerformSegue) {
            if (sender is KVCustomSegue) {
                setUpSideMenuRootBySegue((sender as! KVCustomSegue))
            }
        }
        return shouldPerformSegue;
    }
    
    ///Returns a Boolean value that indicates, either the side menu is showed or closed.
    public func isSideMenuOpen () -> Bool {
        let sieMenuOpen = !(menuContainerView!.currentSideMenuState == .None)
        return sieMenuOpen
    }

}

// MARK:
private extension KVRootBaseSideMenuViewController {
    func setUpSideMenuRootBySegue(segue:KVCustomSegue)
    {
        if ( self == segue.sourceViewController )
        {
            if !(rootObjects.keys.contains(segue.identifier!)) {
                rootObjects[segue.identifier!] = segue.destinationViewController
            }
            visibleRootViewController = rootObjects[segue.identifier!]
        }
        else {
            debugPrint("Both objects are distinct \(self), \(segue.sourceViewController)")
        }
    }
    
}

// MARK:
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
    
    public func changeSideMenuViewControllerRoot(rootIdentifier:String) {
        sideMenuViewController()?.performSegueWithIdentifier(rootIdentifier, sender: self)
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
                let parent = containerView
                let child  = childViewController.view
                child!.prepareViewForAutoLayout()
                
                parent.addConstraints(constraint("H:|[child]|", views: ["child" : child]))
                parent.addConstraints(constraint("V:|[child]|", views: ["child" : child]))
                parent.layoutIfNeeded()
                
            }
        }
        
    }
    
    @warn_unused_result
    public func constraint(format: String, options: NSLayoutFormatOptions = [], metrics: Dictionary<String, AnyObject>?=nil, views: Dictionary<String, AnyObject>) -> Array<NSLayoutConstraint> {
        return NSLayoutConstraint.constraintsWithVisualFormat( format, options: options, metrics: metrics, views: views )
    }
}
