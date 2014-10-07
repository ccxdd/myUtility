//
//  UIView+POP.m
//  WenStore
//
//  Created by ccxdd on 14/9/20.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "UIView+POP.h"
#import <pop/POP.h>

@implementation UIView (POP)

#pragma mark - x

- (void)popX_speed:(CGFloat)speed bounciness:(CGFloat)bounciness velocity:(CGFloat)velocity completion:(void(^)())completion
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, springAnimation.property.name];
    [self.layer pop_addAnimation:springAnimation forKey:name];
    [self pop_springAnimation:springAnimation speed:speed bounciness:bounciness velocity:velocity completion:completion];
}

- (void)popX_to:(CGFloat)to speed:(CGFloat)speed bounciness:(CGFloat)bounciness velocity:(CGFloat)velocity completion:(void(^)())completion;
{
    [self popX_from:self.x to:to speed:speed bounciness:bounciness velocity:velocity completion:completion];
}

- (void)popX_from:(CGFloat)from to:(CGFloat)to speed:(CGFloat)speed bounciness:(CGFloat)bounciness velocity:(CGFloat)velocity completion:(void(^)())completion
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(from);
    springAnimation.toValue = @(to);
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, springAnimation.property.name];
    [self.layer pop_addAnimation:springAnimation forKey:name];
    [self pop_springAnimation:springAnimation speed:speed bounciness:bounciness velocity:velocity completion:completion];
}

#pragma mark - y

- (void)popY_speed:(CGFloat)speed bounciness:(CGFloat)bounciness velocity:(CGFloat)velocity completion:(void(^)())completion
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, springAnimation.property.name];
    [self.layer pop_addAnimation:springAnimation forKey:name];
    [self pop_springAnimation:springAnimation speed:speed bounciness:bounciness velocity:velocity completion:completion];
}

- (void)popY_to:(CGFloat)to speed:(CGFloat)speed bounciness:(CGFloat)bounciness velocity:(CGFloat)velocity completion:(void(^)())completion;
{
    [self popX_from:self.y to:to speed:speed bounciness:bounciness velocity:velocity completion:completion];
}

- (void)popY_from:(CGFloat)from to:(CGFloat)to speed:(CGFloat)speed bounciness:(CGFloat)bounciness velocity:(CGFloat)velocity completion:(void(^)())completion
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimation.fromValue = @(from);
    springAnimation.toValue = @(to);
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, springAnimation.property.name];
    [self.layer pop_addAnimation:springAnimation forKey:name];
    [self pop_springAnimation:springAnimation speed:speed bounciness:bounciness velocity:velocity completion:completion];
}

#pragma mark - xy

- (void)popXY_to:(CGPoint)to
        velocity:(CGPoint)velocity
           speed:(CGFloat)speed
      bounciness:(CGFloat)bounciness
      completion:(void(^)())completion
{
    [self popXY_from:self.center to:to velocity:velocity speed:speed bounciness:bounciness completion:completion];
}

- (void)popXY_from:(CGPoint)from
                to:(CGPoint)to
          velocity:(CGPoint)velocity
             speed:(CGFloat)speed
        bounciness:(CGFloat)bounciness
        completion:(void(^)())completion
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.fromValue = [NSValue valueWithCGPoint:from];
    springAnimation.toValue = [NSValue valueWithCGPoint:to];
    springAnimation.velocity = [NSValue valueWithCGPoint:velocity];
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, springAnimation.property.name];
    [self.layer pop_addAnimation:springAnimation forKey:name];
    [self pop_springAnimation:springAnimation speed:speed bounciness:bounciness velocity:0 completion:completion];
}

#pragma mark - size

- (void)popSize_width:(CGFloat)width
               height:(CGFloat)height
                speed:(CGFloat)speed
           bounciness:(CGFloat)bounciness
           completion:(void(^)())completion
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(width, height)];
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, springAnimation.property.name];
    [self.layer pop_addAnimation:springAnimation forKey:name];
    [self pop_springAnimation:springAnimation speed:speed bounciness:bounciness velocity:0 completion:completion];
}

#pragma mark - scale

- (void)popScale_to:(CGSize)to
           velocity:(CGSize)velocity
              speed:(CGFloat)speed
         bounciness:(CGFloat)bounciness
         completion:(void(^)())completion
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    springAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(to.width*1.1, to.height*1.1)];
    springAnimation.toValue = [NSValue valueWithCGSize:to];
    springAnimation.velocity = [NSValue valueWithCGSize:velocity];
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, springAnimation.property.name];
    [self.layer pop_addAnimation:springAnimation forKey:name];
    [self pop_springAnimation:springAnimation speed:speed bounciness:bounciness velocity:0 completion:completion];
}

- (void)popScale_from:(CGSize)from
                   to:(CGSize)to
             velocity:(CGSize)velocity
                speed:(CGFloat)speed
           bounciness:(CGFloat)bounciness
           completion:(void(^)())completion
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    springAnimation.fromValue = [NSValue valueWithCGSize:from];
    springAnimation.toValue = [NSValue valueWithCGSize:to];
    springAnimation.velocity = [NSValue valueWithCGSize:velocity];
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, springAnimation.property.name];
    [self.layer pop_addAnimation:springAnimation forKey:name];
    [self pop_springAnimation:springAnimation speed:speed bounciness:bounciness velocity:0 completion:completion];
}

- (void)baseScale_from:(CGSize)from
                    to:(CGSize)to
              duration:(CGFloat)duration
            completion:(void(^)())completion
{
    POPBasicAnimation *baseAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    baseAnimation.duration = duration;
    baseAnimation.fromValue = [NSValue valueWithCGSize:from];
    baseAnimation.toValue = [NSValue valueWithCGSize:to];
    NSString *name = [NSString stringWithFormat:@"%p_%@", self, baseAnimation.property.name];
    [self.layer pop_addAnimation:baseAnimation forKey:name];
    [self pop_baseAnimation:baseAnimation completion:completion];
}

#pragma mark -

- (void)pop_springAnimation:(POPSpringAnimation *)springAnimation speed:(CGFloat)speed bounciness:(CGFloat)bounciness velocity:(CGFloat)velocity completion:(void(^)())completion
{
    springAnimation.springSpeed = speed >= 0 ? speed : 12;
    springAnimation.springBounciness = bounciness >= 0 ? bounciness : 4;
    if (velocity > 0) {
        springAnimation.velocity = @(velocity);
    }
    self.userInteractionEnabled = NO;
    [springAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.userInteractionEnabled = YES;
        if (finished) {
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)pop_baseAnimation:(POPBasicAnimation *)baseAnimation completion:(void(^)())completion
{
    self.userInteractionEnabled = NO;
    [baseAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.userInteractionEnabled = YES;
        if (finished) {
            if (completion) {
                completion();
            }
        }
    }];
}

@end
