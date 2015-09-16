//
//  KVLeftSideViewController.m
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav Vishwkarma. All rights reserved.
//

#import "KVLeftSideViewController.h"
#import "KVRootBaseSideMenuViewController.h"
#import "CALayer+KVAnimationExtention.h"

@interface KVLeftSideViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *sideMenuItems;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KVLeftSideViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    sideMenuItems = @[@"LeftNavRoot1",@"LeftNavRoot2",@"LeftNavRoot3"];
    
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sideMenuItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMenuCell" forIndexPath:indexPath];
    [cell.textLabel setText: sideMenuItems[indexPath.row]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // for animation
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.layer startAnimation];

    KVRootBaseSideMenuViewController *aSideMenuVC = self.sideMenuViewController;
    NSString*leftRootIdentifier = [NSString stringWithFormat:@"LeftNavRoot%@",@(indexPath.row+1)];
    
    @try {
        [aSideMenuVC performSegueWithIdentifier:leftRootIdentifier sender:self];
    } @catch (NSException *exception) {
        NSLog(@"name =%@, reason =%@",exception.name,exception.reason);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KVCloseSideMenuNotification object:self];
    
    // OR
    //  instead of notification, we can call toggleRightSideMenu
    //  [aSideMenuViewController.menuContainerView toggleRightSideMenu];
    // OR
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KVToggleRightSideMenuNotification object:self];
}

@end
