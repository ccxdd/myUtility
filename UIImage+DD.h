//
//  UIImage+DD.h
//  WenStore
//
//  Created by ccxdd on 15/1/3.
//  Copyright (c) 2015年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DD)

+ (instancetype)fixOrientation:(UIImage *)aImage;

+ (instancetype)scaleImage:(UIImage *)image withScale:(float)scale;

+ (instancetype)scaleImage:(UIImage *)image toSize:(CGSize)size;

- (instancetype)withScale:(float)scale;

- (instancetype)scaleToWidth:(float)width;

- (instancetype)scaleToHeight:(float)height;

- (instancetype)scaleToSize:(CGSize)size;

@end
