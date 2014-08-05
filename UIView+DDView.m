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

#pragma mark - X, Y, Width, Height -

- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)x2
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)y
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
    [self setFrame:CGRectMake(x, self.y, self.width, self.height)
          animated:NO
          duration:kDuation];
}

- (void)setX:(CGFloat)x animated:(BOOL)animated
{
    [self setFrame:CGRectMake(x, self.y, self.width, self.height)
          animated:animated
          duration:kDuation];
}

- (void)setX:(CGFloat)x animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(x, self.y, self.width, self.height)
          animated:animated
          duration:duration];
}

- (void)setY:(CGFloat)y
{
    [self setFrame:CGRectMake(self.x, y, self.width, self.height)
          animated:NO
          duration:kDuation];
}

- (void)setY:(CGFloat)y animated:(BOOL)animated
{
    [self setFrame:CGRectMake(self.x, y, self.width, self.height)
          animated:animated
          duration:kDuation];
}

- (void)setY:(CGFloat)y animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(self.x, y, self.width, self.height)
          animated:animated
          duration:duration];
}

- (void)setX:(CGFloat)x y:(CGFloat)y;
{
    [self setFrame:CGRectMake(x, y, self.width, self.height)
          animated:NO
          duration:kDuation];
}

- (void)setX:(CGFloat)x y:(CGFloat)y animated:(BOOL)animated
{
    [self setFrame:CGRectMake(x, y, self.width, self.height)
          animated:animated
          duration:kDuation];
}

- (void)setX:(CGFloat)x y:(CGFloat)y animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(x, y, self.width, self.height)
          animated:animated
          duration:duration];
}

- (void)setWidth:(CGFloat)width
{
    [self setFrame:CGRectMake(self.x, self.y, width, self.height)
          animated:NO
          duration:kDuation];
}

- (void)setWidth:(CGFloat)width animated:(BOOL)animated
{
    [self setFrame:CGRectMake(self.x, self.y, width, self.height)
          animated:animated
          duration:kDuation];
}

- (void)setWidth:(CGFloat)width animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(self.x, self.y, width, self.height)
          animated:animated
          duration:duration];
}

- (void)setHeight:(CGFloat)height
{
    [self setFrame:CGRectMake(self.x, self.y, self.width, height)
          animated:NO
          duration:kDuation];
}

- (void)setHeight:(CGFloat)height animated:(BOOL)animated
{
    [self setFrame:CGRectMake(self.x, self.y, self.width, height)
          animated:animated
          duration:kDuation];
}

- (void)setHeight:(CGFloat)height animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(self.x, self.y, self.width, height)
          animated:animated
          duration:duration];
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height
{
    [self setFrame:CGRectMake(self.x, self.y, width, height)
          animated:NO
          duration:kDuation];
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height animated:(BOOL)animated
{
    [self setFrame:CGRectMake(self.x, self.y, width, height)
          animated:animated
          duration:kDuation];
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setFrame:CGRectMake(self.x, self.y, width, height)
          animated:animated
          duration:duration];
}

- (void)setAlpha:(CGFloat)alpha duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = alpha;
    } completion:^(BOOL finished) {
        
    }];
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    [self setWidth:size.width height:size.height];
}

- (CGPoint)origin
{
    return self.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    [self setX:origin.x y:origin.y];
}

#pragma mark - setFrame:animated: -

- (void)setFrame:(CGRect)frame animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self animated:animated duration:duration animations:^{
        self.frame = frame;
    }];
}

#pragma mark - CornerRadius, Border, Shadow -

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

#pragma mark - alignPostiion:offset: -

- (void)alignPostiion:(UIViewAlignPosition)position offset:(CGFloat)offset
{
    [self alignPostiion:position offset:offset animated:NO duration:kDuation];
}

- (void)alignPostiion:(UIViewAlignPosition)position offset:(CGFloat)offset
             animated:(BOOL)animated
{
    [self alignPostiion:position offset:offset animated:animated duration:kDuation];
}

- (void)alignPostiion:(UIViewAlignPosition)position offset:(CGFloat)offset
             animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    UIView *superView = [self superview];
    
    [self animated:animated duration:duration animations:^{
        switch (position) {
            case UIViewAlignPositionTop:
            {
                self.y = 0 + offset;
            }
                break;
            case UIViewAlignPositionLeft:
            {
                self.x = 0 + offset;
            }
                break;
            case UIViewAlignPositionBottom:
            {
                self.y = superView.height - self.height + offset;
            }
                break;
            case UIViewAlignPositionRight:
            {
                self.x = superView.width - self.width + offset;
            }
                break;
            case UIViewAlignPositionVerticalCenter:
            {
                self.center = CGPointMake(self.x, superView.midY);
            }
                break;
            case UIViewAlignPositionHorizontalCenter:
            {
                self.center = CGPointMake(superView.midX, self.y);
            }
                break;
            case UIViewAlignPositionCenter:
            {
                self.center = superView.center;
            }
                break;
        }
    }];
}

#pragma mark -

- (void)animated:(BOOL)animated duration:(NSTimeInterval)duration animations:(void (^)(void))animations
{
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            if (animations) {
                animations();
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        if (animations) {
            animations();
        }
    }
}

@end
