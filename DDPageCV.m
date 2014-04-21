//
//  DDPageCV.m
//  TianXianPei
//
//  Created by ccxdd on 13-12-28.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "DDPageCV.h"

@interface DDPageCV () <UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    NSInteger factImageCount;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DDPageCV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _isCircle = NO;
        [self addSubview:_scrollView];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 30)];
        [self addSubview:pageControl];
    }
    return self;
}

- (void)setImageData:(NSMutableArray *)imageData
{
    if (imageData) {
        [_scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        pageControl.numberOfPages = [imageData count];
        pageControl.currentPage = 0;
        _imageData = imageData;
        NSInteger imageCount = pageControl.numberOfPages;
        NSMutableArray *newArrM = [imageData mutableCopy];
        if (_isCircle) {
            [newArrM insertObject:imageData[imageCount-1] atIndex:0];
            [newArrM addObject:imageData[0]];
            [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
        }
        factImageCount = [newArrM count];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*factImageCount, CGRectGetHeight(self.frame));
        
        for (NSInteger i = 0; i < factImageCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.frame),
                                                                                   0,
                                                                                   CGRectGetWidth(self.frame),
                                                                                   CGRectGetHeight(self.frame))];
            imageView.image = [UIImage imageNamed:newArrM[i]];
            [_scrollView addSubview:imageView];
        }
    }
}

#pragma mark - setShowPageControl

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    pageControl.hidden = !showPageControl;
}

#pragma mark - isCircle

- (void)setIsCircle:(BOOL)isCircle
{
    _isCircle = isCircle;
    [self setImageData:self.imageData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger offsetX = scrollView.contentOffset.x;
    
    if (!_isCircle) {
        pageControl.currentPage = offsetX / CGRectGetWidth(self.frame);
    } else {
        NSInteger index = offsetX / CGRectGetWidth(self.frame);
        if (index == 1) {
            pageControl.currentPage = 0;
        } else if (index > factImageCount-2) {
            pageControl.currentPage = 0;
        } else {
            pageControl.currentPage = index - 1;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isCircle) {
        NSInteger offsetX = scrollView.contentOffset.x;
        if (offsetX > (factImageCount-1) * CGRectGetWidth(self.frame)) {
            [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
        } else if (offsetX < CGRectGetWidth(self.frame)) {
            [scrollView setContentOffset:CGPointMake((factImageCount-1) * CGRectGetWidth(self.frame), 0) animated:NO];
        }
    }
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
