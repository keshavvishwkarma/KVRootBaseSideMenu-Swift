//
//  LeftSideViewController.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController {
    
    @IBAction func moveToFirstViewControllerButton(_ sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.firstViewController)
        NotificationCenter.default.post(name:  KVSideMenu.Notifications.toggleLeft, object: self)
    }
    
    @IBAction func moveToSecondViewControllerButton(_ sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.secondViewController)
        NotificationCenter.default.post(name:  KVSideMenu.Notifications.toggleLeft, object: self)
    }
    
    
}

