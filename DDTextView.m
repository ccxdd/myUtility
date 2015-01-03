//
//  DDTextView.m
//  TianXianPei
//
//  Created by ccxdd on 14-2-8.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDTextView.h"

@interface DDTextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation DDTextView

- (void)awakeFromNib
{
    [self setupTextView];
}

- (void)setupTextView
{
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, 20)];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
    self.placeholderLabel.text = self.placeholder;
    self.delegate = self;
    [self addSubview:self.placeholderLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupTextView];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder) {
        _placeholder = placeholder;
        self.placeholderLabel.text = _placeholder;
    }
}

- (void)setFont:(UIFont *)font
{
    super.font = font;
    self.placeholderLabel.font = font;
}

- (void)setText:(NSString *)text
{
    [self checkTextLength:text];;
    
    [super setText:text];
}

#pragma mark - textViewDidDidChange

- (void)textViewDidDidChange:(NSNotification *)notification
{
    [self checkTextLength:self.text];
}

- (void)checkTextLength:(NSString *)text
{
    if (text.length > 0) {
        self.placeholderLabel.hidden = YES;
    } else if (text.length == 0) {
        if (self.placeholder.length > 0) {
            self.placeholderLabel.hidden = NO;
        }
    }
}

#pragma mark UITextView Delegate

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (range.location >= 260 || [text isEqualToString:@"\n"])
//    {
//        [self resignFirstResponder];
//        return  NO;
//    }
//    else
//    {
//        return YES;
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
