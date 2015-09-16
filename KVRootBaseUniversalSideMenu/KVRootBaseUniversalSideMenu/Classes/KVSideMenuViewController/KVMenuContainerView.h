//
//  KVMenuContainerView.h
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav Vishwkarma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SideMenuState){
    SideMenuStateNone, SideMenuStateLeft, SideMenuStateRight
};

UIKIT_EXTERN const CGFloat KVSideMenuOffsetValueInRatio;
UIKIT_EXTERN const CGFloat KVSideMenuViewControllerHideShowMenuDuration;

@interface KVMenuContainerView : UIView

- (instancetype)initWithSuperView:(UIView*)superView;

@property(nonatomic, readonly) UIView *leftContainerView;
@property(nonatomic, readonly) UIView *centerContainerView;
@property(nonatomic, readonly) UIView *rightContainerView;

@property(nonatomic, readonly) SideMenuState currentSideMenuState;

-(void) closeSideMenu;
-(void) toggleLeftSideMenu;
-(void) toggleRightSideMenu;

@end