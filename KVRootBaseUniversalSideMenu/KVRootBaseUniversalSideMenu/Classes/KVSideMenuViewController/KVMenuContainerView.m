//
//  KVMenuContainerView.m
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav. All rights reserved.
//

#import "KVMenuContainerView.h"
#import "KVConstraintExtensionsMaster.h"

const CGFloat KVSideMenuOffsetValueInRatio = 0.75;
const CGFloat KVSideMenuViewControllerHideShowMenuDuration = 0.4;

@implementation KVMenuContainerView

- (instancetype)initWithSuperView:(UIView*)superView
{
    KVMenuContainerView *_mainContainerView = [KVMenuContainerView prepareNewViewForAutoLayout];
    [_mainContainerView setBackgroundColor:[UIColor brownColor]];
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
    
    [_leftContainerView applyConstraintFromSiblingViewAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeLeading ofView:_centerContainerView spacing:defualtConstant];
    [_centerContainerView applyConstraintFromSiblingViewAttribute:NSLayoutAttributeRight toAttribute:NSLayoutAttributeLeading ofView:_rightContainerView spacing:defualtConstant];
    
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

-(void)applyAnimations
{
    UIViewAnimationOptions options = (UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut);
    
    [UIView animateWithDuration:KVSideMenuViewControllerHideShowMenuDuration delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:10 options:options animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [self updateModifyConstraints];
    } completion:NULL];
}

@end