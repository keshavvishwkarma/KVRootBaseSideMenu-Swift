//
//  KVCustomSegue.swift
//  KVRootBaseSideMenu-Swift
//
//  Created by Keshav on 7/3/16.
//  Copyright © 2016 Keshav. All rights reserved.
//

import UIKit

public class KVCustomSegue: UIStoryboardSegue {
    
    override public func perform()
    {
        // Must Call this method from Source ViewController
        if self.sourceViewController.shouldPerformSegueWithIdentifier(self.identifier!, sender: self) {
            
        }
    }
    
    
}
