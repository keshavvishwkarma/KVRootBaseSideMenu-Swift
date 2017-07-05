//
//  ViewController.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/12/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var disableMenuButton: UIButton! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        disableMenuButton.isSelected = !(sideMenuViewController()?.menuContainerView?.allowPanGesture ?? false)
    }
    
    @IBAction func defaultButtonPressed(_ sender: AnyObject)
    {
        sideMenuViewController()?.menuContainerView?.animationType = KVSideMenu.AnimationType.default
    }
    
    @IBAction func foldingButtonPressed(_ sender: AnyObject)
    {
        sideMenuViewController()?.menuContainerView?.animationType = KVSideMenu.AnimationType.folding
    }
    
    @IBAction func windowButtonPressed(_ sender: AnyObject)
    {
        sideMenuViewController()?.menuContainerView?.animationType = KVSideMenu.AnimationType.window
    }
    
    @IBAction func disablePanGustureButtonPressed(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        sideMenuViewController()?.menuContainerView?.allowPanGesture = !sender.isSelected
//        sideMenuViewController()?.menuContainerView?.allowPanGesture = false

    }

}


