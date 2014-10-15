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
        return nil;
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

+ (UIImage *)screenCapture
{
    UIView *screenView = [UIApplication sharedApplication].keyWindow;
    return [screenView captureView];
}

+ (void)saveScreenToAlbum
{
    UIView *screenView = [UIApplication sharedApplication].keyWindow;
    [screenView saveCaptureToAlbum];
}

+ (UINib *)nibWithName:(NSString *)name
{
    return [UINib nibWithNibName:name bundle:nil];
}

#pragma mark - X, Y, Width, Height -

- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)x1
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
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.bounds);
}

- (CGFloat)midX
{
    return CGRectGetMidX(self.bounds);
}

- (CGFloat)midY
{
    return CGRectGetMidY(self.bounds);
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
    return self.frame.origin;
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
    CGFloat nav_height = 0;
    
    if (!IOS7_OR_LATER) {
        if (superView.height == kVIEW_HEIGHT) {
            nav_height = -44;
        }
    }
    
    [self animated:animated duration:duration animations:^{
        switch (position) {
            case UIViewAlignPositionTop:
            {
                self.y = 0 + offset + nav_height;
            }
                break;
            case UIViewAlignPositionLeft:
            {
                self.x = 0 + offset;
            }
                break;
            case UIViewAlignPositionBottom:
            {
                self.y = superView.height - self.height + offset + nav_height;
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

#pragma mark - line -

+ (void)lineWithRect:(CGRect)frame color:(UIColor *)color toView:(UIView *)view
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    
    [view addSubview:line];
}

+ (UIView *)lineWithRect:(CGRect)frame color:(UIColor *)color
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    
    return line;
}

- (UIImage *)captureView
{
    CGRect rect = self.frame;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    }
    if (IOS7_OR_LATER) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)captureView1x
{
    CGRect rect = self.frame;

    UIGraphicsBeginImageContext(rect.size);
    if (IOS7_OR_LATER) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)captureViewInRect:(CGRect)rect
{
    UIImage *img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([[self captureView] CGImage], rect)];
    return img;
}

- (UIImage *)captureView1xInRect:(CGRect)rect
{
    UIImage *img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([[self captureView1x] CGImage], rect)];
    return img;
}

- (void)saveCaptureToAlbum
{
    UIImageWriteToSavedPhotosAlbum([self captureView],
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL){
        //失败
        [BMWaitVC showMessage:@"保存失败！"];
    }
    else{
        //成功
        [BMWaitVC showMessage:@"保存成功！"];
    }
}

- (CGPoint)toWindowPoint
{
    return [self convertPoint:self.origin toView:nil];
}

- (CGRect)toWindowFrame
{
    return [self convertRect:self.frame toView:nil];
}

- (void)setBlurBackground
{
    self.backgroundColor = [UIColor colorWithPatternImage:[[[self superview] captureView1xInRect:self.frame] applyDarkEffect]];
}

@end
