//
//  KVRootBaseSideMenuViewController.m
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav. All rights reserved.
//

#import "KVRootBaseSideMenuViewController.h"
#import "UIViewController+KVContainer.h"
#import "KVCustomSegue.h"

NSString *const KVToggleLeftSideMenuNotification   =  @"KVToggleLeftSideMenuNotification";
NSString *const KVToggleRightSideMenuNotification  =  @"KVToggleRightSideMenuNotification";
NSString *const KVCloseSideMenuNotification        =  @"KVCloseSideMenuNotification";

@interface KVRootBaseSideMenuViewController ()<UIGestureRecognizerDelegate>
{
    @private
        NSMutableDictionary *_rootsObjectsInfo;
    
    @protected
        UIViewController *leftSideMenuViewController;
        UIViewController *rightSideMenuViewController;
}

@end

@implementation KVRootBaseSideMenuViewController

-(void)initialise
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivedNotification:) name:KVToggleLeftSideMenuNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivedNotification:)
                                                 name:KVToggleRightSideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivedNotification:)
                                                 name:KVCloseSideMenuNotification object:nil];
    
    _rootsObjectsInfo = [NSMutableDictionary new];
    
    _menuContainerView = [[KVMenuContainerView alloc] initWithSuperView:self.view];
    
    [self containerAddChildViewController:[self leftSideMenuViewController]
                          toContainerView:_menuContainerView.leftContainerView];
    [self containerAddChildViewController:[self rightSideMenuViewController]
                          toContainerView:_menuContainerView.rightContainerView];
    
    [self performSegueWithIdentifier:@"LeftNavRoot1" sender:self];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KVToggleLeftSideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KVToggleRightSideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KVCloseSideMenuNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initialise];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didReceivedNotification:(NSNotification*)notify
{
    if ([notify.name isEqualToString:KVToggleLeftSideMenuNotification]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self.menuContainerView methodSignatureForSelector:@selector(toggleLeftSideMenu)]];
        invocation.target = self.menuContainerView;
        invocation.selector = @selector(toggleLeftSideMenu);
        [invocation invoke];
        
    } else if ([notify.name isEqualToString:KVToggleRightSideMenuNotification]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self.menuContainerView methodSignatureForSelector:@selector(toggleRightSideMenu)]];
        invocation.target = self.menuContainerView;
        invocation.selector = @selector(toggleRightSideMenu);
        [invocation invoke];
        
    } else if ([notify.name isEqualToString:KVCloseSideMenuNotification]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self.menuContainerView methodSignatureForSelector:@selector(closeSideMenu)]];
        invocation.target = self.menuContainerView;
        invocation.selector = @selector(closeSideMenu);
        [invocation invoke];
    }
    else{
        
    }
}

-(UIViewController *)leftSideMenuViewController {
    if (!leftSideMenuViewController) {
        @try {
            leftSideMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KVLeftSideViewController"];
        } @catch (NSException *exception) {
            NSLog(@"name =%@, reason =%@",exception.name,exception.reason);
        }
    }
    return leftSideMenuViewController;
}

-(UIViewController *)rightSideMenuViewController {
    if (!rightSideMenuViewController) {
        @try {
            rightSideMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KVRightSideViewController"];
        } @catch (NSException *exception) {
            NSLog(@"name =%@, reason =%@",exception.name,exception.reason);
        }
    }
    return rightSideMenuViewController;
}

#pragma mark - Private method implementation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldPerformSegue = [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    if (shouldPerformSegue) {
        if ([sender isMemberOfClass:[KVCustomSegue class]]){
            [self setUpSideMenuRootBySegue:sender];
        }
    }
    return shouldPerformSegue;
}

-(void)setUpSideMenuRootBySegue:(KVCustomSegue*)segue
{
    if ( self == segue.sourceViewController )
    {
        if (![[_rootsObjectsInfo allKeys] containsObject:segue.identifier]) {
            [_rootsObjectsInfo setObject:segue.destinationViewController forKey:segue.identifier];
        }
        
        id rootViewController = [_rootsObjectsInfo valueForKey:segue.identifier];
        
        if (rootViewController != self.centerNavigationController) {
            if (self.centerNavigationController) {
                [self containerRemoveChildViewController:self.centerNavigationController];
            }
            _centerNavigationController = rootViewController;
        }
    }else{
        KVLog(@"%@, %@ %@",@"Both objects are distinct", self, (KVRootBaseSideMenuViewController *)segue.sourceViewController);
    }
}

@end

@implementation UIViewController (KVViewControllerHierarchy)

- (KVRootBaseSideMenuViewController *)sideMenuViewController {
    KVRootBaseSideMenuViewController *aSideMenuViewController = [(KVRootBaseSideMenuViewController *)self accessViewControllerHierarchyForClass:KVRootBaseSideMenuViewController.class];
    return aSideMenuViewController;
}

@end