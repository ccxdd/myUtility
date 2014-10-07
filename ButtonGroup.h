//
//  ButtonGroup.h
//  aDiningHall
//
//  Created by ccxdd on 14-2-1.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ButtonGroup_Type_Radio      = 0,
    ButtonGroup_Type_CheckBox   = 1,
} ButtonGroupType;

@interface ButtonGroup : UIView

+ (instancetype)viewWithFrame:(CGRect)frame
                         type:(ButtonGroupType)type
                       titles:(NSArray *)titles
                          gap:(float)gap
                     itemSize:(CGSize)itemSize
                          key:(NSString *)key
                     selected:(NSInteger)selectedIndex;

@property (nonatomic, copy) void(^buttonGroupSelectHandler)(NSInteger index, id item);

@end
