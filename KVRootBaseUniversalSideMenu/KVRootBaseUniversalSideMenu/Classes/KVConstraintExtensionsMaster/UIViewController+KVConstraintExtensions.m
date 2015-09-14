//
//  UIViewController+KVConstraintExtensions.m
//  https://github.com/keshavvishwkarma/KVConstraintExtensionsMaster.git
//
//  Distributed under the MIT License.
//
//  Copyright (c) 2015 Keshav Vishwkarma
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "KVConstraintExtensionsMaster.h"

@implementation UIViewController (KVConstraintExtensions)

#pragma mark - common private Layout Guide constraint methods
// to create
- (NSLayoutConstraint*)prepareLayoutGuideConstraintToView:(UIView *)toView WithPadding:(CGFloat)padding isTopLayoutGuide:(BOOL)isTopLayoutGuide {
    NSLayoutConstraint *preparedConstraint = nil;
    [toView prepareViewForAutoLayout];
    
    NSAssert(([self view] != toView), @"you are passing wrong view and fromView must not be distinct from self.view of ViewController.");
    NSAssert(toView, @"fromView must not be nil.");
    
    if (isTopLayoutGuide) {
        preparedConstraint = [NSLayoutConstraint constraintWithItem:toView                                                                           attribute:NSLayoutAttributeTop relatedBy:defualtRelation toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:defualtMultiplier constant:padding];
    }
    else{
        preparedConstraint = [NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop relatedBy:defualtRelation toItem:toView attribute:NSLayoutAttributeBottom multiplier:defualtMultiplier constant:padding];
    }
    
    return preparedConstraint;
}

- (NSLayoutConstraint*)accessAppliedLayoutGuideConstraintFromView:(UIView *)fromView isTopLayoutGuide:(BOOL)isTopLayoutGuide
{
    __block NSLayoutConstraint *appliedConstraint = nil;
    __block id<UILayoutSupport>layoutGuide   = isTopLayoutGuide ? self.topLayoutGuide : self.bottomLayoutGuide;
    NSLayoutAttribute viewAttribute          = isTopLayoutGuide ? NSLayoutAttributeTop : NSLayoutAttributeBottom;
    NSLayoutAttribute layoutGuideAttribute   = isTopLayoutGuide ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
    
    [self.view.constraints enumerateObjectsUsingBlock: ^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop)
     {
         if ( ((constraint.firstItem == layoutGuide)&&(constraint.secondItem == fromView)) || ((constraint.secondItem == layoutGuide)&&(constraint.firstItem == fromView)) )
         {
             if (self.view == fromView) {
                 if (NSLayoutAttributeTop == (constraint.firstAttribute|constraint.secondAttribute)) {
                     appliedConstraint = constraint;
                 }else  if (NSLayoutAttributeBottom == (constraint.firstAttribute|constraint.secondAttribute)) {
                     appliedConstraint = constraint;
                 }else{
                     KVLog(@"NOT Found");
                 }
             }
             else if (((constraint.firstItem == layoutGuide) && (constraint.firstAttribute == layoutGuideAttribute)) && ((constraint.secondItem == fromView) && (constraint.secondAttribute == viewAttribute))) {
                 appliedConstraint = constraint;
             } else if (((constraint.secondItem == layoutGuide) && (constraint.secondAttribute == layoutGuideAttribute)) && ((constraint.firstItem == fromView) && (constraint.firstAttribute == viewAttribute))) {
                 appliedConstraint = constraint;
             } else {
                 KVLog(@"NOT Found");
             }
         }
     }];
    
    return appliedConstraint;
}


- (void)applyTopLayoutGuideConastrainToView:(UIView *)toView WithPadding:(CGFloat)padding {
    NSLayoutConstraint *preparedConstraint = [self prepareLayoutGuideConstraintToView:toView WithPadding:padding isTopLayoutGuide:YES];
    [self.view applyPreparedConastrainInView:preparedConstraint];
}
- (void)applyBottomLayoutGuideConastrainToView:(UIView *)toView WithPadding:(CGFloat)padding {
    NSLayoutConstraint *preparedConstraint = [self prepareLayoutGuideConstraintToView:toView WithPadding:padding isTopLayoutGuide:NO];
    [self.view applyPreparedConastrainInView:preparedConstraint];
}

- (NSLayoutConstraint*)accessAppliedTopLayoutGuideConstraintFromView:(UIView *)fromView{
    return [self accessAppliedLayoutGuideConstraintFromView:fromView isTopLayoutGuide:YES];
}
- (NSLayoutConstraint*)accessAppliedBottomLayoutGuideConstraintFromView:(UIView *)fromView{
    return [self accessAppliedLayoutGuideConstraintFromView:fromView isTopLayoutGuide:NO];
}

- (void)removeAppliedTopLayoutGuideConstraintFromView:(UIView *)fromView{
    if (self.view != fromView)
    {
        NSLayoutConstraint *appliedConstraint = [self accessAppliedTopLayoutGuideConstraintFromView:fromView];
        if (appliedConstraint) [self.view removeConstraint:appliedConstraint];
    }
}

- (void)removeAppliedBottomLayoutGuideConstraintFromView:(UIView *)fromView{
    if (self.view != fromView){
        NSLayoutConstraint *appliedConstraint = [self accessAppliedBottomLayoutGuideConstraintFromView:fromView];
        if (appliedConstraint) [self.view removeConstraint:appliedConstraint];
    }
}

@end
