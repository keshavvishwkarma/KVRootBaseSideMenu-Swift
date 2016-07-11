//
//  SideMenuViwController.swift
//  SideMenuDemo1
//
//  Created by Keshav on 7/9/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

public extension KVSideMenu
{
    // Here define the roots identifier of side menus that must be connected from KVRootBaseSideMenuViewController
    // In Storyboard using KVCustomSegue
    
    static public let leftSideViewController   =  "LeftSideViewController"
    static public let rightSideViewController  =  "RightSideViewController"
    
    struct RootsIdentifiers
    {
        static public let initialViewController  =  "SecondViewController"

        // All roots viewcontrollers
        static public let firstViewController    =  "FirstViewController"
        static public let secondViewController   =  "SecondViewController"
    }
    
}

class SideMenuViewController: KVRootBaseSideMenuViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Configure The SideMenu

        leftSideMenuViewController  =  self.storyboard?.instantiateViewControllerWithIdentifier(KVSideMenu.leftSideViewController)
        rightSideMenuViewController =  self.storyboard?.instantiateViewControllerWithIdentifier(KVSideMenu.rightSideViewController)

        // Set default root
        self.performSegueWithIdentifier(KVSideMenu.RootsIdentifiers.initialViewController, sender: self)

    }
}



