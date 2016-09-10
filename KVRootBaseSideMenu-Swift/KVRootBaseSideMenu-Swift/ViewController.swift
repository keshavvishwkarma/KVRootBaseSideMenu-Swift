//
//  ViewController.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/12/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func defaultButtonPressed(sender: AnyObject)
    {
        sideMenuViewController()?.menuContainerView?.animationType = KVSideMenu.AnimationType.Default
    }
    
    @IBAction func foldingButtonPressed(sender: AnyObject)
    {
        sideMenuViewController()?.menuContainerView?.animationType = KVSideMenu.AnimationType.Folding
    }
    
    @IBAction func windowButtonPressed(sender: AnyObject)
    {
        sideMenuViewController()?.menuContainerView?.animationType = KVSideMenu.AnimationType.Window
    }
}


