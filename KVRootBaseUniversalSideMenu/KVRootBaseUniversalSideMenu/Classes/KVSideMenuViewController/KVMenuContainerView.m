//
//  KVMenuContainerView.m
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav Vishwkarma. All rights reserved.
//

#import "KVMenuContainerView.h"
#import "KVConstraintExtensionsMaster.h"

const CGFloat KVSideMenuOffsetValueInRatio = 0.75;
const CGFloat KVSideMenuViewControllerHideShowMenuDuration = 0.4;

@implementation KVMenuContainerView

- (instancetype)initWithSuperView:(UIView*)superView
{
    KVMenuContainerView *_mainContainerView = [KVMenuContainerView prepareNewViewForAutoLayout];
    [_mainContainerView setBackgroundColor:[UIColor clearColor]];
    [superView addSubview:_mainContainerView];
    
    [_mainContainerView applyConstraintForCenterInSuperview];
    [_mainContainerView applyEqualHeightPinConstrainToSuperview];
    [_mainContainerView applyEqualWidthPinConstrainToSuperview];
    
    return _mainContainerView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialise];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialise];
    }
    return self;
}

#pragma mark - Private method implementation

-(void)initialise
{
    [self setClipsToBounds:NO];
    
    _leftContainerView   = [UIView prepareNewViewForAutoLayout];
    _centerContainerView = [UIView prepareNewViewForAutoLayout];
    _rightContainerView  = [UIView prepareNewViewForAutoLayout];
    
    _leftContainerView.backgroundColor    = self.backgroundColor;
    _centerContainerView.backgroundColor  = self.backgroundColor;
    _rightContainerView.backgroundColor   = self.backgroundColor;
    
    [self addSubview:_leftContainerView];
    [self addSubview:_rightContainerView];
    [self addSubview:_centerContainerView];
    
    [_leftContainerView applyTopAndBottomPinConstraintToSuperviewWithPadding:defualtConstant];
    [_centerContainerView applyTopAndBottomPinConstraintToSuperviewWithPadding:defualtConstant];
    [_rightContainerView applyTopAndBottomPinConstraintToSuperviewWithPadding:defualtConstant];
    
    [_centerContainerView applyConstraintForHorizontallyCenterInSuperview];
    [_centerContainerView applyEqualWidthPinConstrainToSuperview];
    
    [_leftContainerView applyEqualWidthRatioPinConstrainToSuperview: KVSideMenuOffsetValueInRatio];
    [_rightContainerView applyEqualWidthRatioPinConstrainToSuperview: KVSideMenuOffsetValueInRatio];
    
    [_leftContainerView applyConstraintFromSiblingViewAttribute:NSLayoutAttributeTrailing toAttribute:NSLayoutAttributeLeading ofView:_centerContainerView spacing:defualtConstant];
    [_centerContainerView applyConstraintFromSiblingViewAttribute:NSLayoutAttributeTrailing toAttribute:NSLayoutAttributeLeading ofView:_rightContainerView spacing:defualtConstant];
    
    _currentSideMenuState = SideMenuStateNone;
    
}

-(void) closeSideMenu
{
    switch (_currentSideMenuState)
    {
        case SideMenuStateLeft:[self toggleLeftSideMenu];
            break;
            
        case SideMenuStateRight:[self toggleRightSideMenu];
            break;
            
        default:
            break;
    }
}

-(void) toggleLeftSideMenu {
    [self endEditing:YES];
    
    Boolean notAlreadyExpanded = (self.currentSideMenuState == SideMenuStateRight);
    if (notAlreadyExpanded) {
        [self.rightContainerView accessAppliedConstraintByAttribute:NSLayoutAttributeTrailing completion:^(NSLayoutConstraint *appliedConstraint) {
            if (appliedConstraint) {
                [self.rightContainerView.superview removeConstraint:appliedConstraint];
                [self.centerContainerView applyConstraintForHorizontallyCenterInSuperview];
                [self updateModifyConstraints];
            }
        }];
    }
    
    [self.centerContainerView accessAppliedConstraintByAttribute:NSLayoutAttributeCenterX completion:^(NSLayoutConstraint *appliedConstraint) {
        if (appliedConstraint) {
            _currentSideMenuState = SideMenuStateLeft;
            
            [self.centerContainerView.superview removeConstraint:appliedConstraint];
            [self.leftContainerView applyLeadingPinConstraintToSuperviewWithPadding:defualtConstant];
            
            [self applyAnimations];
        }
        else
        {
            [self.leftContainerView accessAppliedConstraintByAttribute:NSLayoutAttributeLeading completion:^(NSLayoutConstraint *appliedConstraint) {
                if (appliedConstraint) {
                    _currentSideMenuState = SideMenuStateNone;
                    
                    [self.leftContainerView.superview removeConstraint:appliedConstraint];
                    [self.centerContainerView applyConstraintForHorizontallyCenterInSuperview];
                    
                    [self applyAnimations];
                }
            }];
        }
    }];
}

-(void) toggleRightSideMenu {
    [self endEditing:YES];
    
    Boolean notAlreadyExpanded = (self.currentSideMenuState == SideMenuStateLeft);
    if (notAlreadyExpanded) {
        [self.leftContainerView accessAppliedConstraintByAttribute:NSLayoutAttributeLeading completion:^(NSLayoutConstraint *appliedConstraint) {
            if (appliedConstraint) {
                [self.leftContainerView.superview removeConstraint:appliedConstraint];
                [self.centerContainerView applyConstraintForHorizontallyCenterInSuperview];
                [self updateModifyConstraints];
            }
        }];
    }
    
    [self.centerContainerView accessAppliedConstraintByAttribute:NSLayoutAttributeCenterX completion:^(NSLayoutConstraint *appliedConstraint) {
        if (appliedConstraint) {
            _currentSideMenuState = SideMenuStateRight;
            
            [self.centerContainerView.superview removeConstraint:appliedConstraint];
            [self.rightContainerView applyTrailingPinConstraintToSuperviewWithPadding:defualtConstant];
            [self applyAnimations];
        }
        else
        {
            _currentSideMenuState = SideMenuStateNone;
            [self.rightContainerView accessAppliedConstraintByAttribute:NSLayoutAttributeTrailing completion:^(NSLayoutConstraint *appliedConstraint) {
                if (appliedConstraint) {
                    _currentSideMenuState = SideMenuStateNone;
                    
                    [self.rightContainerView.superview removeConstraint:appliedConstraint];
                    [self.centerContainerView applyConstraintForHorizontallyCenterInSuperview];
                    [self applyAnimations];
                }
            }];
        }
    }];
}

- (void)applyShadow:(UIView*)shadowView
{
    CALayer *shadowViewLayer = shadowView.layer;
    shadowViewLayer.shadowColor = shadowView.backgroundColor.CGColor;
    shadowViewLayer.shadowOpacity = 0.4;
    shadowViewLayer.shadowRadius = 4.0f;
    shadowViewLayer.rasterizationScale = self.window.screen.scale;

    if (self.currentSideMenuState == SideMenuStateLeft) {
        shadowViewLayer.shadowOffset = CGSizeMake(-2, 2);
    } else if (self.currentSideMenuState == SideMenuStateRight){
        shadowViewLayer.shadowOffset = CGSizeMake(0, 2);
    } else {
        shadowViewLayer.shadowRadius = 3;
        shadowViewLayer.shadowOpacity = 0;
        shadowViewLayer.shadowOffset = CGSizeMake(0, -3);
        shadowViewLayer.shadowColor = nil;
    }
}

-(void)applyAnimations
{
    UIViewAnimationOptions options = (UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut);
    
    [UIView animateWithDuration:KVSideMenuViewControllerHideShowMenuDuration delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:10 options:options animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [self updateModifyConstraints];
        [self applyShadow:self.centerContainerView];
    } completion:NULL];
}

@end