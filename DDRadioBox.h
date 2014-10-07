//
//  DDRadioBox.h
//  ZH_xinxin
//
//  Created by ccxdd on 14-6-26.
//  Copyright (c) 2014年 上海佐昊网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDRadioBox : UIButton

@property (nonatomic, assign) BOOL checked;

+ (instancetype)radioBoxWithFrame:(CGRect)frame title:(NSString *)title checked:(BOOL)checked;

@end
