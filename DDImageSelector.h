//
//  DDImageSelector.h
//  WenStore
//
//  Created by ccxdd on 14/12/22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDImageSelector : NSObject

+ (void)imageModalVC:(UIViewController *)fromVC
       allowsEditing:(BOOL)allowsEditing
               scale:(float)scale
          completion:(void(^)(UIImage *image))completion;

+ (void)imageModalVC:(UIViewController *)fromVC
       allowsEditing:(BOOL)allowsEditing
            maxWidth:(float)maxWidth
          completion:(void(^)(UIImage *image))completion;

+ (void)imageModalVC:(UIViewController *)fromVC
       allowsEditing:(BOOL)allowsEditing
           maxHeight:(float)maxHeight
          completion:(void(^)(UIImage *image))completion;

+ (void)imageModalVC:(UIViewController *)fromVC
       allowsEditing:(BOOL)allowsEditing
            maxWidth:(float)maxWidth
           maxHeight:(float)maxHeight
          completion:(void(^)(UIImage *image))completion;

@end
