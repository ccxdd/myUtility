//
//  DDVisualView.h
//  ZH_iOS
//
//  Created by ccxdd on 15/6/9.
//  Copyright (c) 2015年 上海佐昊网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDVisualView : UIView

@property (nonatomic, assign) IBInspectable NSInteger blurEffectStyle;

+ (instancetype)visualViewframe:(CGRect)frame;

@end
