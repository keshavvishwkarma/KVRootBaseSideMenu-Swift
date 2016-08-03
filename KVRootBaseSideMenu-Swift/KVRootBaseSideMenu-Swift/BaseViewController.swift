//
//  BaseViewController.swift
//  DemoApp
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = self.classForCoder.description().componentsSeparatedByString(".").last!
        
        let barItemFram = CGRectMake(0, 0, 44, 44);
        
        // Customize the UIBarButtonItem
        let leftItemCustomeView   = UIButton(type: UIButtonType.Custom);
        leftItemCustomeView.frame = barItemFram;
        leftItemCustomeView.setImage(UIImage(named:"backward_arrow"), forState: UIControlState.Normal)
        
        let rightItemCustomeView   = UIButton(type: UIButtonType.Custom);
        rightItemCustomeView.frame = barItemFram;
        rightItemCustomeView.setImage(UIImage(named:"forward_arrow"), forState: UIControlState.Normal)
        
        leftItemCustomeView.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        rightItemCustomeView.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: leftItemCustomeView);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItemCustomeView);
        
    }
    
    // MARK: - IBAction Methods
    
    func leftButtonAction(sender: UIButton)
    {
        // with orange color
        sender.layer.startAnimation(tintColor :UIColor.orangeColor())
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleLeft, object: self)
    }
    
    func rightButtonAction(sender: UIButton)
    {
        // with defualt color
        sender.layer.startAnimation()
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleRight, object: self)
        //   OR
        // self.sideMenuViewController()?.menuContainerView?.toggleRightSideMenu();
    }
    
    
}