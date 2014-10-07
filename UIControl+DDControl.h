//
//  UIControl+DDControl.h
//  IndividuationLogin
//
//  Created by ccxdd on 14-1-23.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (DDControl)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;

@end
