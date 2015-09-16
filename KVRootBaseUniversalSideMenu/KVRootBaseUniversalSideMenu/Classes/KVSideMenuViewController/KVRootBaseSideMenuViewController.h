//
//  KVRootBaseSideMenuViewController.h
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav Vishwkarma. All rights reserved.
//

#import "KVMenuContainerView.h"
#import "KVConstraintExtensionsMaster.h"

UIKIT_EXTERN NSString *const KVToggleLeftSideMenuNotification;
UIKIT_EXTERN NSString *const KVToggleRightSideMenuNotification;
UIKIT_EXTERN NSString *const KVCloseSideMenuNotification;

@interface KVRootBaseSideMenuViewController : UIViewController

@property (nonatomic, readonly) KVMenuContainerView *menuContainerView;
@property (nonatomic, readonly) UINavigationController *centerNavigationController;

@end

@interface UIViewController (KVViewControllerHierarchy)

- (KVRootBaseSideMenuViewController *)sideMenuViewController;

@end