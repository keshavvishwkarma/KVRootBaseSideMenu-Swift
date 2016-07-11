//
//  LeftSideViewController.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController {
    
    @IBAction func moveToFirstViewControllerButton(sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.firstViewController)
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleLeft, object: self)
    }
    
    @IBAction func moveToSecondViewControllerButton(sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.secondViewController)
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleLeft, object: self)
    }


}

