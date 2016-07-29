//
//  UIViewController+KVConstraintExtensions.h
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

@interface UIViewController (KVConstraintExtensions)

#pragma mark - Apply LayoutGuide Constraint From view of ViewController to a specific view
/* These method is used to access applied LayoutGuide constraint from view of ViewController(self.view) to a specific view(toView).
 */
- (void)applyTopLayoutGuideConastrainToView:(UIView *)toView WithPadding:(CGFloat)padding NS_AVAILABLE_IOS(7_0);

- (void)applyBottomLayoutGuideConastrainToView:(UIView *)toView WithPadding:(CGFloat)padding NS_AVAILABLE_IOS(7_0);

#pragma mark - Access LayoutGuide Constraint From a specific View
/* This method is used to access applied LayoutGuide constraint if layout guide constraint is exist in self.view for fromView.
 */
- (NSLayoutConstraint*)accessAppliedTopLayoutGuideConstraintFromView:(UIView *)fromView NS_AVAILABLE_IOS(7_0);

- (NSLayoutConstraint*)accessAppliedBottomLayoutGuideConstraintFromView:(UIView *)fromView NS_AVAILABLE_IOS(7_0);

#pragma mark - Remove LayoutGuide Constraints From a specific View

/* These method is used to remove the layoutGuide constraint.
 * But you cann't remove default TopLayoutGuide and BottomLayoutGuide constraint
 */
- (void)removeAppliedTopLayoutGuideConstraintFromView:(UIView *)fromView NS_AVAILABLE_IOS(7_0);

- (void)removeAppliedBottomLayoutGuideConstraintFromView:(UIView *)fromView NS_AVAILABLE_IOS(7_0);

@end
