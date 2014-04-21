//
//  BMCheckButton.h
//  NTSCar
//
//  Created by ccxdd on 13-4-23.
//  Copyright (c) 2013年 Heidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMCheckButton : UIButton
{
    BOOL isChecked;
}

- (BOOL)isChecked;
- (void)setIsChecked:(BOOL)checked;

@end
