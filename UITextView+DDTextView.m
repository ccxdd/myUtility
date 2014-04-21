//
//  UITextView+DDTextView.m
//  TianXianPei
//
//  Created by ccxdd on 14-2-7.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "UITextView+DDTextView.h"
#import <objc/runtime.h>

static char kDDTextViewPlaceholderKey;

@implementation UITextView (DDTextView)

@dynamic placeholder;

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder) {
        UILabel *placeholdLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, 20)];
        placeholdLab.text = placeholder;
        placeholdLab.font = self.font;
        placeholdLab.backgroundColor = [UIColor clearColor];
        placeholdLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
        placeholdLab.tag = 1000;
        [self addSubview:placeholdLab];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    
    objc_setAssociatedObject(self, &kDDTextViewPlaceholderKey, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

#pragma mark - textViewDidDidChange

- (void)textViewDidDidChange:(NSNotification *)notification
{
    if (self.text.length > 0) {
        UILabel *lab = (UILabel *)[self viewWithTag:1000];
        if (lab) {
            [lab removeFromSuperview];
        }
    } else if (self.text.length == 0) {
        NSString *placeholder = objc_getAssociatedObject(self, &kDDTextViewPlaceholderKey);
        if (placeholder.length > 0) {
            UILabel *placeholdLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, 20)];
            placeholdLab.text = placeholder;
            placeholdLab.font = self.font;
            placeholdLab.backgroundColor = [UIColor clearColor];
            placeholdLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
            placeholdLab.tag = 1000;
            [self addSubview:placeholdLab];
        }
    }
    
}

@end
