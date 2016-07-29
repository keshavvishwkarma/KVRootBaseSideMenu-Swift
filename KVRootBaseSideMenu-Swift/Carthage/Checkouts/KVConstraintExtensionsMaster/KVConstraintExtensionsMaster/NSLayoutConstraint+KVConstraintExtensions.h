//
//  NSLayoutConstraint+KVConstraintExtensions.h
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

@interface NSLayoutConstraint (KVConstraintExtensions)

UIKIT_EXTERN const CGFloat defualtMultiplier;
UIKIT_EXTERN const CGFloat defualtConstant;
UIKIT_EXTERN const NSLayoutRelation defualtRelation;
UIKIT_EXTERN const CGFloat defualtLessMaxPriority;
UIKIT_EXTERN const CGFloat defualt_iPadRatio;

+ (CGFloat)defualtSpacingBetweenSiblings;
+ (CGFloat)defualtSpacingBetweenSuperview;
+ (BOOL)recognizedDirectionByAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toTttribute;
/* This method is used to trace the allready added constraints on receiver view
 */
+ (NSLayoutConstraint *)appliedConstraintForView:(UIView*)aView attribute:(NSLayoutAttribute)attribute;
+ (BOOL)isSelfConstraintAttribute:(NSLayoutAttribute)attribute;
- (BOOL)isEqualToConstraint:(NSLayoutConstraint *)aConstraint;
- (NSLayoutConstraint *)swapConstraintItems;
- (NSLayoutConstraint *)modifyConstraintRelatedBy:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)modifyConstraintMultiplierBy:(CGFloat)multiplier;

@end

@interface NSArray (KV_ContainsConstraint)

- (NSLayoutConstraint *)containsAppliedConstraint:(NSLayoutConstraint *)appliedConstraint;

@end
