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
        
        self.title = self.classForCoder.description().components(separatedBy: ".").last!
        
        let barItemFram = CGRect(x: 0, y: 0, width: 44, height: 44);
        
        // Customize the UIBarButtonItem
        let leftItemCustomeView   = UIButton(type: UIButtonType.custom);
        leftItemCustomeView.frame = barItemFram;
        leftItemCustomeView.setImage(UIImage(named:"backward_arrow"), for: UIControlState())
        
        let rightItemCustomeView   = UIButton(type: UIButtonType.custom);
        rightItemCustomeView.frame = barItemFram;
        rightItemCustomeView.setImage(UIImage(named:"forward_arrow"), for: UIControlState())
        
        leftItemCustomeView.addTarget(self, action: #selector(BaseViewController.leftButtonAction(_:)), for: UIControlEvents.touchUpInside)
        rightItemCustomeView.addTarget(self, action: #selector(BaseViewController.rightButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: leftItemCustomeView);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItemCustomeView);
        
    }
    
    // MARK: - IBAction Methods
    
    @objc func leftButtonAction(_ sender: UIButton)
    {
        // with orange color
        sender.layer.startAnimation(tintColor :UIColor.orange)
        NotificationCenter.default.post(name:  KVSideMenu.Notifications.toggleLeft, object: self)
    }
    
    @objc func rightButtonAction(_ sender: UIButton)
    {
        // with defaultt color
        sender.layer.startAnimation()
        NotificationCenter.default.post(name: KVSideMenu.Notifications.toggleRight, object: self)
        //   OR
        // self.sideMenuViewController()?.menuContainerView?.toggleRightSideMenu();
    }
    
    
}
