//
//  UIImageView+DD.h
//  WenStore
//
//  Created by ccxdd on 15/1/3.
//  Copyright (c) 2015年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DD)

/**
 *  根据类型自己切换方法
 *
 *  @param data NSString, NSData, UIImage
 */
- (void)loadImageData:(id)data;

@end
