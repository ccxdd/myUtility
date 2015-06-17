//
//  DDVisualView.m
//  ZH_iOS
//
//  Created by ccxdd on 15/6/9.
//  Copyright (c) 2015年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "DDVisualView.h"

@interface DDVisualView ()

@property (nonatomic, strong) IBOutlet UIVisualEffectView *visualView;

@end

@implementation DDVisualView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self configView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _blurEffectStyle = UIBlurEffectStyleLight;
        [self configView];
    }
    return self;
}

+ (instancetype)visualViewframe:(CGRect)frame
{
    DDVisualView *view = [[DDVisualView alloc] initWithFrame:frame];
    
    return view;
}

#pragma mark - configView

- (void)configView
{
    if (iOS8_OR_LATER) {
        if (!_visualView) {
            _visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:_blurEffectStyle]];
            [self addSubview:_visualView];
            _visualView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = @{@"vsv": _visualView};
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[vsv]|"
                                                                         options:0 metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[vsv]|"
                                                                         options:0 metrics:nil views:views]];
        }
    } else {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    }
}

@end
