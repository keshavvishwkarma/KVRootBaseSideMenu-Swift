//
//  KVBaseRootVC.m
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav Vishwkarma. All rights reserved.
//

#import "KVBaseRootVC.h"
#import "KVRootBaseSideMenuViewController.h"
#import "KVConstraintExtensionsMaster.h"
#import "CALayer+KVAnimationExtention.h"

@interface KVBaseRootVC ()

@end

#pragma mark - View lifecycle

@implementation KVBaseRootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    UILabel *centerLabel = [UILabel prepareNewViewForAutoLayout];
    [centerLabel setFont:[UIFont fontWithName:@"American Typewriter" size:28.0f]];
    [self.view addSubview:centerLabel];
    [centerLabel setText:NSStringFromClass(self.class)];
    [self setTitle:centerLabel.text];
    [centerLabel applyConstraintForHorizontallyCenterInSuperview];
    [centerLabel applyCenterYPinConstraintToSuperviewWithPadding:-32.0f];

    CGRect barItemFram = CGRectMake(0, 0, 44, 44);
    
    // Customize the UIBarButtonItem
    UIButton *leftItemCustomeView = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemCustomeView.frame = barItemFram;
    [leftItemCustomeView setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    
    UIButton *rightItemCustomeView = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemCustomeView.frame = barItemFram;
    [rightItemCustomeView setImage:[UIImage imageNamed:@"forward_arrow"] forState:UIControlStateNormal];

    [leftItemCustomeView addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightItemCustomeView addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemCustomeView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemCustomeView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods

- (void)leftButtonAction:(UIButton*)sender
{
// For Animation
    [sender.layer setTintColor:self.view.backgroundColor];
    [sender.layer startAnimation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KVToggleLeftSideMenuNotification object:self];

    // OR
    //  instead of notification, we can call toggleRightSideMenu
//    [self.sideMenuViewController.menuContainerView toggleLeftSideMenu];
}

- (void)rightButtonAction:(UIButton*)sender
{
    // For Animation
    [sender.layer setTintColor:self.view.backgroundColor];
    [sender.layer startAnimation];

    [[NSNotificationCenter defaultCenter] postNotificationName:KVToggleRightSideMenuNotification object:self];
    // OR
    //  instead of notification, we can call toggleRightSideMenu
    //  [aSideMenuViewController.menuContainerView toggleRightSideMenu];
}



@end
