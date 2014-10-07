//
//  UIView+POP.h
//  WenStore
//
//  Created by ccxdd on 14/9/20.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (POP)

//x
- (void)popX_speed:(CGFloat)speed
        bounciness:(CGFloat)bounciness
          velocity:(CGFloat)velocity
        completion:(void(^)())completion;

- (void)popX_to:(CGFloat)to
          speed:(CGFloat)speed
     bounciness:(CGFloat)bounciness
       velocity:(CGFloat)velocity
     completion:(void(^)())completion;

- (void)popX_from:(CGFloat)from
               to:(CGFloat)to
            speed:(CGFloat)speed
       bounciness:(CGFloat)bounciness
         velocity:(CGFloat)velocity
       completion:(void(^)())completion;
//y
- (void)popY_speed:(CGFloat)speed
        bounciness:(CGFloat)bounciness
          velocity:(CGFloat)velocity
        completion:(void(^)())completion;

- (void)popY_to:(CGFloat)to
          speed:(CGFloat)speed
     bounciness:(CGFloat)bounciness
       velocity:(CGFloat)velocity
     completion:(void(^)())completion;

- (void)popY_from:(CGFloat)from
               to:(CGFloat)to
            speed:(CGFloat)speed
       bounciness:(CGFloat)bounciness
         velocity:(CGFloat)velocity
       completion:(void(^)())completion;
//xy
- (void)popXY_to:(CGPoint)to
        velocity:(CGPoint)velocity
           speed:(CGFloat)speed
      bounciness:(CGFloat)bounciness
      completion:(void(^)())completion;

- (void)popXY_from:(CGPoint)from
                to:(CGPoint)to
          velocity:(CGPoint)velocity
             speed:(CGFloat)speed
        bounciness:(CGFloat)bounciness
        completion:(void(^)())completion;

//size
- (void)popScale_to:(CGSize)to
           velocity:(CGSize)velocity
              speed:(CGFloat)speed
         bounciness:(CGFloat)bounciness
         completion:(void(^)())completion;

//scale
- (void)popScale_from:(CGSize)from
                   to:(CGSize)to
             velocity:(CGSize)velocity
                speed:(CGFloat)speed
           bounciness:(CGFloat)bounciness
           completion:(void(^)())completion;

- (void)baseScale_from:(CGSize)from
                    to:(CGSize)to
              duration:(CGFloat)duration
            completion:(void(^)())completion;

@end
