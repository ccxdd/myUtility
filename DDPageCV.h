//
//  DDPageCV.h
//  TianXianPei
//
//  Created by ccxdd on 13-12-28.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPageCV : UIView

@property (nonatomic, strong) NSArray *imageData;
@property (nonatomic, assign) BOOL    showPageControl;
@property (nonatomic, assign) BOOL    isCircle;
@property (nonatomic, copy) void(^pageControlViewBlock)(NSInteger page, id item);

- (void)setImageData:(NSArray *)imageData
placeholderImageName:(NSString *)placeholderImageName
                 key:(NSString *)key;

@end
