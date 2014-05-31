//
//  DDCheckBox.h
//  NTSCar
//
//  Created by ccxdd on 13-4-23.
//  Copyright (c) 2013年 Heidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCheckBox : UIButton

@property (nonatomic, assign) BOOL checked;

+ (instancetype)checkBoxWithFrame:(CGRect)frame title:(NSString *)title checked:(BOOL)checked;

@end
