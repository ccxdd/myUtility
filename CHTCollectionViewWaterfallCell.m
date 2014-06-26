//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"

@interface CHTCollectionViewWaterfallCell ()

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CHTCollectionViewWaterfallCell

#pragma mark - Accessors
- (UILabel *)displayLabel {
	if (!_displayLabel) {
		_displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
		_displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_displayLabel.backgroundColor = kUIColorRGBA(0, 0, 0, .5);
		_displayLabel.textColor = [UIColor whiteColor];
        _displayLabel.font = [UIFont systemFontOfSize:12];
		_displayLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _displayLabel;
}

- (void)setDisplayString:(NSString *)displayString {
	if (![_displayString isEqualToString:displayString]) {
		_displayString = [displayString copy];
		self.displayLabel.text = _displayString;
	}
}

#pragma mark - Life Cycle
- (void)dealloc {
	[_displayLabel removeFromSuperview];
	_displayLabel = nil;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kNavigationBarColor;
		[self.contentView addSubview:self.displayLabel];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bottomView];
        
	}
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.displayLabel.frame = CGRectMake(0, 0, self.frame.size.width, 25);
    self.bottomView.frame = CGRectMake(0, self.height - 20, self.width, 20);
}

@end
