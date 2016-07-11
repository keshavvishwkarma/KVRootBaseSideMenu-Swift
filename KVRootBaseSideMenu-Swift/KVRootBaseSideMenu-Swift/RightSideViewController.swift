//
//  RightSideViewController.swift
//  SideMenuDemo1
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import UIKit

class RightSideViewController: UIViewController {
        
    @IBAction func moveToFirstViewControllerButton(sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.firstViewController)
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleRight, object: self)
    }
    
    @IBAction func moveToSecondViewControllerButton(sender: AnyObject) {
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.secondViewController)
        NSNotificationCenter.defaultCenter().postNotificationName(KVSideMenu.Notifications.toggleRight, object: self)
    }

    
}
