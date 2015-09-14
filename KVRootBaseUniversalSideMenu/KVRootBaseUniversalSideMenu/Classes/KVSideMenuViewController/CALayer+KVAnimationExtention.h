//
//  CALayer+KVAnimationExtention.h
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (KVAnimationExtention)

@property(nonatomic,strong) UIColor *tintColor;

-(void)startAnimation;
-(void)stopAnimation;

@end
