//
//  UIView+KVConstraintExtensions.h
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

#import <UIKit/UIKit.h>

@interface UIView (KVConstraintExtensions)

/* This method is used to create new instance of ui elements for autolayout.
 */
+ (instancetype)prepareNewViewForAutoLayout;

/* This method is used to prepare already created instance of ui elements for autolayout.
 */
- (void)prepareViewForAutoLayout;

#pragma mark - Generic methods
#pragma mark - To create constraints for superview

- (NSLayoutConstraint *)prepareConstraintToSuperviewAttribute:(NSLayoutAttribute)attribute1 attribute:(NSLayoutAttribute)attribute2 relation:(NSLayoutRelation)relation;

- (NSLayoutConstraint *)prepareEqualRelationPinConstraintToSuperview:(NSLayoutAttribute)attribute constant:(CGFloat)constant;

- (NSLayoutConstraint *)prepareEqualRelationPinRatioConstraintToSuperview:(NSLayoutAttribute)attribute multiplier:(CGFloat)multiplier;

#pragma mark - To create constraints for sibling views

- (NSLayoutConstraint *)prepareConstraintFromSiblingViewAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherSiblingView relation:(NSLayoutRelation)relation;

- (NSLayoutConstraint *)prepareConstraintFromSiblingViewAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherSiblingView multiplier:(CGFloat)multiplier;

#pragma mark - Add constraints cumulative

- (void)applyPreparedConastrainInView:(NSLayoutConstraint *)constraint;

#pragma mark - Remove Constraints From a specific View
/* This method is used to remove all the its related constraint from the its superview.
 */
- (void)removeAppliedConstraintFromSupreview;

/* This method is used to remove all constraint (self + superview).
 */
- (void)removeAllAppliedConstraints;

#pragma mark - Modify applied constraint of a UIView
/* This method is used to change the priority of constraint.
 */
- (void)changeAppliedConstraintPriority:(UILayoutPriority)priority forAttribute:(NSLayoutAttribute)attribute;

/* This method is used to replace already applied constraint by new constraint.
 */
- (void)replaceAppliedConastrainInView:(NSLayoutConstraint *)appliedConstraint replaceBy:(NSLayoutConstraint *)constraint;

- (void)updateModifyConstraints;

- (void)updateModifyConstraintsWithAnimation:(void (^)(BOOL finished))completion;

- (void)updateAppliedConstraintConstantValueByAttribute:(NSLayoutAttribute)attribute withConstantRatio:(CGFloat)constantRatio;

- (void)updateAppliedConstraintConstantValueForIpadByAttribute:(NSLayoutAttribute)attribute;

#pragma mark - Access Applied Constraint By Attributes From a specific View
/* This method is used to access already applied constraint (means expected constraint) constraint by attribute of a constraints.
 */
- (NSLayoutConstraint*)accessAppliedConstraintByAttribute:(NSLayoutAttribute)attribute;

/* This method is also used to access already applied constraint (means expected constraint) by attribute of a constraints with completion block.
 */
- (void)accessAppliedConstraintByAttribute:(NSLayoutAttribute)attribute completion:(void (^)(NSLayoutConstraint *appliedConstraint))completion;

/* This method is used to access already applied constraint apply\add constraint between two sibling views. No matter by which sibling View you call this method & no matter order of attributes but you need to call it by one sibling View and pass second other sibling View.
 */
- (NSLayoutConstraint*)accessAppliedConstraintFromSiblingViewByAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherSiblingView;

#pragma mark - Apply Pin Edges to Superview
/* These methods are used to applied\add constraints in supreview of caller(self).
 */
- (void)applyLeftPinConstraintToSuperviewWithPadding:(CGFloat)padding;
- (void)applyRightPinConstraintToSuperviewWithPadding:(CGFloat)padding;
- (void)applyTopPinConstraintToSuperviewWithPadding:(CGFloat)padding;
- (void)applyBottomPinConstraintToSuperviewWithPadding:(CGFloat)padding;
- (void)applyLeadingPinConstraintToSuperviewWithPadding:(CGFloat)padding;
- (void)applyTrailingPinConstraintToSuperviewWithPadding:(CGFloat)padding;
- (void)applyCenterXPinConstraintToSuperviewWithPadding:(CGFloat)padding;
- (void)applyCenterYPinConstraintToSuperviewWithPadding:(CGFloat)padding;

/* This method is used to apply\add same leading and trailing pin constraints to superview .
 */
- (void)applyLeadingAndTrailingPinConstraintToSuperviewWithPadding:(CGFloat)padding;
/* This method is used to apply\add same Top and Bottom pin constraints to superview .
 */
- (void)applyTopAndBottomPinConstraintToSuperviewWithPadding:(CGFloat)padding;

- (void)applyEqualWidthPinConstrainToSuperview;
- (void)applyEqualHeightPinConstrainToSuperview;

- (void)applyEqualHeightRatioPinConstrainToSuperview: (CGFloat)ratio;
- (void)applyEqualWidthRatioPinConstrainToSuperview: (CGFloat)ratio;

- (void)applyCenterXRatioPinConstrainToSuperview:(CGFloat)ratio padding:(CGFloat)padding;
- (void)applyCenterYRatioPinConstrainToSuperview:(CGFloat)ratio padding:(CGFloat)padding;

- (void)applyConstraintForCenterInSuperview;     /* Center horizontally and Vertically */
- (void)applyConstraintForVerticallyCenterInSuperview;    /* Center Vertically */
- (void)applyConstraintForHorizontallyCenterInSuperview;  /* Center horizontally */

- (void)applyConstraintFitToSuperview;
- (void)applyConstraintFitToSuperviewHorizontally;
- (void)applyConstraintFitToSuperviewVertically;

/* This method is used to apply\add top, left, bottom & right pin constraints to superview.
 * to exclude any pin between (top, left, bottom & right) then set Inset Edge INFINITY/HUGE_VALF.
 * For Ex. we want to exclude then we must set left Edge of insets either INFINITY or HUGE_VALF.
 * [self applyConstraintFitToSuperviewContentInset:UIEdgeInsetsMake(0, INFINITY, 0, 0)];
 */
- (void)applyConstraintFitToSuperviewContentInset:(UIEdgeInsets)Insets;

#pragma mark - Apply self view constraints
/* This method is used to applied\add constraint in self view.
 */
- (void)applyAspectRatioConstrain;
- (void)applyWidthConstraint:(CGFloat)width;
- (void)applyHeightConstraint:(CGFloat) height;

#pragma mark - Apply Constraint between sibling views
/* This method is used to apply\add constraint between sibling views.
 */
- (void)applyConstraintFromSiblingViewAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherSiblingView spacing:(CGFloat)spacing;

@end
