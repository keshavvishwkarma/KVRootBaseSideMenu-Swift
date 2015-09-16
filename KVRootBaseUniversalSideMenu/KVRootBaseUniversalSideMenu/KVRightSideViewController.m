//
//  KVRightSideViewController.m
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav Vishwkarma. All rights reserved.
//

#import "KVRightSideViewController.h"
#import "KVRootBaseSideMenuViewController.h"
#import "CALayer+KVAnimationExtention.h"

@interface KVRightSideViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *sideMenuItems;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KVRightSideViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    sideMenuItems = @[@"RightNavRoot1",@"RightNavRoot2",@"RightNavRoot3"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightMenuCell" forIndexPath:indexPath];
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
    NSString*rightRootIdentifier = [NSString stringWithFormat:@"RightNavRoot%@",@(indexPath.row+1)];
    
    @try {
        [aSideMenuVC performSegueWithIdentifier:rightRootIdentifier sender:self];
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
