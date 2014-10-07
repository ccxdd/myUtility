//
//  ButtonGroup.m
//  aDiningHall
//
//  Created by ccxdd on 14-2-1.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "ButtonGroup.h"

#define kSELECTED_COLOR          [UIColor clearColor]
#define kUN_SELECTED_COLOR       [UIColor clearColor]
#define kSELECTED_IMAGE          @"radio_selected"
#define kUN_SELECTED_IMAGE       @"radio_unselected"
#define kBUTTON_TEXT_COLOR       kVcTextColor
#define kBUTTON_FONT             [UIFont systemFontOfSize:16]
#define kIS_SELECTED_IMAGE       (i == selfView.selectedIndex) ? kSELECTED_IMAGE : kUN_SELECTED_IMAGE

@interface ButtonGroup ()

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIColor   *unSelectedColor;
@property (nonatomic, strong) UIColor   *selectedColor;

@end

@implementation ButtonGroup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.selectedIndex = 0;
        self.unSelectedColor = kSELECTED_COLOR;
        self.selectedColor = kUN_SELECTED_COLOR;
    }
    return self;
}

+ (instancetype)viewWithFrame:(CGRect)frame
                         type:(ButtonGroupType)type
                       titles:(NSArray *)titles
                          gap:(float)gap
                     itemSize:(CGSize)itemSize
                          key:(NSString *)key
                     selected:(NSInteger)selectedIndex
{
    float x = 0, y = 0;
    float self_height = CGRectGetHeight(frame);
    float self_width = CGRectGetWidth(frame);
    ButtonGroup *selfView = [[ButtonGroup alloc] initWithFrame:frame];
    selfView.selectedIndex = selectedIndex;
    
    for (int i = 0; i < [titles count]; i++) {
        
        NSString *title = key ? titles[i][key] : titles[i];
        CGSize btnSize = CGSizeZero;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:kBUTTON_TEXT_COLOR forState:UIControlStateNormal];
        [btn.titleLabel setFont:kBUTTON_FONT];
        if (itemSize.width == 0) {
            btnSize = CGSizeMake([Utility calcSizeFromString:title font:btn.titleLabel.font width:self_width].width, itemSize.height);
            if (x + btnSize.width > self_width) {
                x = 0;
                y += itemSize.height + gap;
            }
        } else {
            btnSize = itemSize;
        }
        [btn setFrame:CGRectMake(x, y, btnSize.width, btnSize.height)];
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:kUN_SELECTED_IMAGE] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 0, 0)];
        [btn setImage:[UIImage imageNamed:kIS_SELECTED_IMAGE] forState:UIControlStateNormal];
        [selfView addSubview:btn];
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [[selfView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    [obj setBackgroundColor:selfView.unSelectedColor];
                    [obj setImage:[UIImage imageNamed:kUN_SELECTED_IMAGE] forState:UIControlStateNormal];
                }
            }];
            
            switch (type) {
                case ButtonGroup_Type_Radio: //
                {
                    [sender setImage:[UIImage imageNamed:kSELECTED_IMAGE] forState:UIControlStateNormal];
                }
                    break;
                case ButtonGroup_Type_CheckBox: //
                {
                    
                }
                    break;
            }
            [btn setBackgroundColor:selfView.selectedColor];
            selfView.selectedIndex = btn.tag;
            if (selfView.buttonGroupSelectHandler) {
                selfView.buttonGroupSelectHandler(selfView.selectedIndex, titles[selfView.selectedIndex]);
            }
            
        }];
        
        x += gap + btnSize.width;
    }
    
    if (self_height == 0) {
        [selfView setFrame:CGRectMake(frame.origin.x, frame.origin.y, self_width, y+itemSize.height)];
    }
    
    return selfView;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
