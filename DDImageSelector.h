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
          completion:(void(^)(UIImage *image))completion;

@end
