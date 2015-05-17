//
//  UIImageView+DD.m
//  WenStore
//
//  Created by ccxdd on 15/1/3.
//  Copyright (c) 2015年 ccxdd. All rights reserved.
//

#import "UIImageView+DD.h"

@implementation UIImageView (DD)

- (void)loadImageData:(id)data
{
    if ([data isKindOfClass:[NSData class]]) {
        self.image = [UIImage imageWithData:data];
    }
    else if ([data isKindOfClass:[UIImage class]]) {
        self.image = data;
    }
    else if ([data isKindOfClass:[NSString class]]) {
        if ([data hasPrefix:@"http://"]) {
            [self sd_setImageWithURL:[data toURL] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        } else {
            self.image = [UIImage imageNamed:data];
        }
    }
}

@end
