//
//  SideMenuViwController.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/3/16.
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
        
        leftSideMenuViewController  =  self.storyboard?.instantiateViewController(withIdentifier: KVSideMenu.leftSideViewController)
        rightSideMenuViewController =  self.storyboard?.instantiateViewController(withIdentifier: KVSideMenu.rightSideViewController)
        
        // Set default root
        self.changeSideMenuViewControllerRoot(KVSideMenu.RootsIdentifiers.initialViewController)
        
        // Set freshRoot value to true/false according to your roots managment polity. By Default value is false.
        // If freshRoot value is ture then we will always create a new instance of every root viewcontroller.
        // If freshRoot value is ture then we will reuse already created root viewcontroller if exist otherwise create it.
        
        // self.freshRoot = true
     
        self.menuContainerView?.delegate = self

    }
}

extension SideMenuViewController: KVRootBaseSideMenuDelegate
{
    func willOpenSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState) {
        print(#function)
    }
    
    func didOpenSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState){
        print(#function)
    }
    
    func willCloseSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState){
        print(#function)
    }
    
    func didCloseSideMenuView(_ sideMenuView: KVMenuContainerView, state: KVSideMenu.SideMenuState){
        print(#function)
    }
}



