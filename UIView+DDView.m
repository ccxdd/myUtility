//
//  UIView+DDView.m
//  WenStore
//
//  Created by ccxdd on 14-6-5.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "UIView+DDView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuation    0.3f

@implementation UIView (DDView)

+ (id)viewForXibName:(NSString *)xibName
{
    return [self viewForXibName:xibName atIndex:0];
}

+ (id)viewForXibName:(NSString *)xibName atIndex:(NSInteger)index
{
    @try {
        if (xibName) {
            NSArray *xibArr = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
            return xibArr[index];
        } else {
            NSLog(@"\n Error: viewForXibName:atIndex:");
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"\n exception: %@ \n %@",NSStringFromSelector(_cmd), exception);
    }
}

+ (CGRect)commonFrameTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    CGRect frame = CGRectMake(0 + left,
                              0 + top,
                              kSCREEN_WIDTH - left - right,
                              kSCREEN_HEIGHT - top - bottom + kIOS67_VIEW_OFFSET);
    NSLog(@"%@", NSStringFromCGRect(frame));
    
    return frame;
}

- (CGFloat)x1
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)x2
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)y1
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)y2
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)midX
{
    return CGRectGetMidX(self.frame);
}

- (CGFloat)midY
{
    return CGRectGetMidY(self.frame);
}

- (void)setX:(CGFloat)x
{
    [self setFrame:CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:NO
          duration:kDuation];
}

- (void)setX:(CGFloat)x animated:(BOOL)animated
{
    [self setFrame:CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:animated
          duration:kDuation];
}

- (void)setX:(CGFloat)x animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:animated
          duration:duration];
}

- (void)setY:(CGFloat)y
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:NO
          duration:kDuation];
}

- (void)setY:(CGFloat)y animated:(BOOL)animated
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:animated
          duration:kDuation];
}

- (void)setY:(CGFloat)y animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:animated
          duration:duration];
}

- (void)setX:(CGFloat)x y:(CGFloat)y;
{
    [self setFrame:CGRectMake(x, y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:NO
          duration:kDuation];
}

- (void)setX:(CGFloat)x y:(CGFloat)y animated:(BOOL)animated
{
    [self setFrame:CGRectMake(x, y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:animated
          duration:kDuation];
}

- (void)setX:(CGFloat)x y:(CGFloat)y animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(x, y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
          animated:animated
          duration:duration];
}

- (void)setWidth:(CGFloat)width
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, CGRectGetHeight(self.frame))
          animated:NO
          duration:kDuation];
}

- (void)setWidth:(CGFloat)width animated:(BOOL)animated
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, CGRectGetHeight(self.frame))
          animated:animated
          duration:kDuation];
}

- (void)setWidth:(CGFloat)width animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, CGRectGetHeight(self.frame))
          animated:animated
          duration:duration];
}

- (void)setHeight:(CGFloat)height
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)
          animated:NO
          duration:kDuation];
}

- (void)setHeight:(CGFloat)height animated:(BOOL)animated
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)
          animated:animated
          duration:kDuation];
}

- (void)setHeight:(CGFloat)height animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)
          animated:animated
          duration:duration];
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, height)
          animated:NO
          duration:kDuation];
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height animated:(BOOL)animated
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, height)
          animated:animated
          duration:kDuation];
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, height)
          animated:animated
          duration:duration];
}

- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
}

- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)width
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
}

- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor width:(CGFloat)width
{
    self.layer.cornerRadius = radius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
}

#pragma mark - setShadowX:y:color:opacity:radius:usePath

- (void)setShadowX:(CGFloat)x y:(CGFloat)y color:(UIColor *)color opacity:(float)opacity radius:(CGFloat)radius
           usePath:(BOOL)usePath
{
    self.layer.shadowColor   = color.CGColor;
    self.layer.shadowOffset  = CGSizeMake(x, y);
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius  = radius;
    self.clipsToBounds = NO;
    
    if (usePath) {
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
}

#pragma mark - setFrame:animated:

- (void)setFrame:(CGRect)frame animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:frame];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self setFrame:frame];
    }
}

- (void)alignPostiion:(UIViewAlignPosition)position offset:(CGFloat)offset
{
    switch (position) {
        case UIViewAlignPositionTop:
        {
            [self setY:0 + offset];
        }
            break;
        case UIViewAlignPositionLeft:
        {
            [self setX:0 + offset];
        }
            break;
        case UIViewAlignPositionBottom:
        {
            [self setY:kSCREEN_HEIGHT - self.height + offset + kIOS67_VIEW_OFFSET];
        }
            break;
        case UIViewAlignPositionRight:
        {
            [self setX:kSCREEN_WIDTH - self.width + offset];
        }
            break;
    }
}

@end
