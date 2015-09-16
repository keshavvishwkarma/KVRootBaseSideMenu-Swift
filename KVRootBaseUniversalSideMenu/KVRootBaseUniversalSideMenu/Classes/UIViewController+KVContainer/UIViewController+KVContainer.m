//
//  UIViewController+KVContainer.m
//  KVRootBaseUniversalSideMenu
//
//  Distributed under the MIT License.
//
//  Copyright (c) 2015  Keshav Vishwkarma.
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

#import "UIViewController+KVContainer.h"
#import "KVConstraintExtensionsMaster.h"

@implementation UIViewController (KVContainer)

- (instancetype)accessViewControllerHierarchyForClass:(Class)class_name {
    UIViewController *viewController = self.parentViewController ? self.parentViewController : self.presentingViewController;
    while (!(viewController == nil || [viewController isKindOfClass:class_name])) {
        viewController = viewController.parentViewController ? viewController.parentViewController : viewController.presentingViewController;
    }
    
    return viewController;
}

- (void)containerAddChildViewController:(UIViewController *)childViewController toContainerView:(UIView *)view
{
    if (childViewController)
    {
        [childViewController.view setFrame:view.bounds];
        [self addChildViewController:childViewController];
        [childViewController didMoveToParentViewController:self];
        
        if ([self isViewLoaded]) {
            // [view insertSubview:childViewController.view atIndex:0];
            [view addSubview:childViewController.view];
            // [view bringSubviewToFront:childViewController.view];
        }

        if (view.translatesAutoresizingMaskIntoConstraints) {
            UIViewAutoresizing autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
            [childViewController.view setAutoresizingMask:autoresizingMask];
        } else {
            UIView * parent = view;
            UIView * child  = childViewController.view;
            [child prepareViewForAutoLayout];
            [child applyConstraintFitToSuperview];
            [parent updateModifyConstraints];
        }
    }
}

- (void)containerAddChildViewController:(UIViewController *)childViewController {
    [self containerAddChildViewController:childViewController toContainerView:self.view ];
}

- (void)containerRemoveChildViewController:(UIViewController *)childViewController {
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
}

@end
