//
//  CALayer+KVAnimationExtention.m
//  KVRootBaseUniversalSideMenu
//
//  Created by Keshav on 15/09/15.
//  Copyright (c) 2015 Keshav Vishwkarma. All rights reserved.
//

#import "CALayer+KVAnimationExtention.h"
#import "KVConstraintExtensionsMaster.h"
#import <objc/runtime.h>

@implementation CALayer (KVAnimationExtention)

@dynamic tintColor;

- (void)setTintColor:(UIColor*)color {
    objc_setAssociatedObject(self, @selector(tintColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*)tintColor {
    return objc_getAssociatedObject(self, @selector(tintColor));
}

- (void)setAssociatedObject:(id)object {
    objc_setAssociatedObject(self, @selector(associatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

-(void)startAnimation
{
    if (![self associatedObject]) {
        CALayer *_circleLayer = [CALayer layer];
        [self addSublayer:_circleLayer];
        [_circleLayer setName:@"KVAnimationExtention"]; // for Identifier
        [self setAssociatedObject:_circleLayer];
        
        CGFloat size = MAX(CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds));
        CGFloat dx = (self.bounds.size.width - size) / 2.0f;
        CGFloat dy = (self.bounds.size.height - size) / 2.0f;
        
        _circleLayer.opacity = 0.0f;
        if (!self.tintColor) {
            self.tintColor = [UIColor colorWithWhite:1 alpha:0.25f];
        }
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _circleLayer.frame = CGRectMake(dx, dy, size, size);
        _circleLayer.cornerRadius = size / 2.0f;
        _circleLayer.backgroundColor = self.tintColor.CGColor;
        [CATransaction commit];
        
        CABasicAnimation *circleLayerAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        circleLayerAnim.fromValue = @(0.2);
        circleLayerAnim.toValue = @(1.1);
        circleLayerAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = @(0.75);
        opacityAnim.toValue = @(0.0);
        opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CAAnimationGroup *groupAnim = [CAAnimationGroup new];
        groupAnim.duration = 0.65f;
        groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        groupAnim.removedOnCompletion = YES;
        groupAnim.fillMode = kCAFillModeForwards;
        groupAnim.animations = @[circleLayerAnim, opacityAnim];
        
        [groupAnim setDelegate:self];
        [_circleLayer addAnimation:groupAnim forKey:@"animation"];
    }
}

-(void)stopAnimation {
    [[self associatedObject] removeFromSuperlayer];
}

- (void)animationDidStart:(CAAnimation *)anim {
//    KVLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    KVLog(@"%@",NSStringFromSelector(_cmd));
    CALayer *l =[self associatedObject];
    if ([l.name isEqualToString:@"KVAnimationExtention"]) {
        [l removeFromSuperlayer];
        [self setAssociatedObject:nil];
    }
}

@end
