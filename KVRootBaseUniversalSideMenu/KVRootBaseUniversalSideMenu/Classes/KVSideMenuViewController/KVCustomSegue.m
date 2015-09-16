//
//  KVCustomSegue.m
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav Vishwkarma. All rights reserved.
//

#import "KVCustomSegue.h"
#import "KVRootBaseSideMenuViewController.h"
#import "KVMenuContainerView.h"
#import "UIViewController+KVContainer.h"

@implementation KVCustomSegue

-(void)perform {
    if ([self.sourceViewController isMemberOfClass:[KVRootBaseSideMenuViewController class]]) {
        KVRootBaseSideMenuViewController *sourceVC = (KVRootBaseSideMenuViewController *)self.sourceViewController;
        if ([sourceVC shouldPerformSegueWithIdentifier:self.identifier sender:self]) {
            [sourceVC containerAddChildViewController:sourceVC.centerNavigationController
                                      toContainerView:sourceVC.menuContainerView.centerContainerView];
        }
    }
}

@end
