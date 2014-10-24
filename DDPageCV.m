//
//  DDPageCV.m
//  TianXianPei
//
//  Created by ccxdd on 13-12-28.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "DDPageCV.h"

@interface DDPageCV () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, copy  ) NSString      *imageNameKey;
@property (nonatomic, assign) NSInteger     factImageCount;
@property (nonatomic, assign) DDPageType    type;

@end

@implementation DDPageCV

- (void)awakeFromNib
{
    [self configPageCV:self.frame];
}

- (void)dealloc
{
    self.startup = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configPageCV:frame];
    }
    return self;
}

#pragma mark - configPageCV

- (void)configPageCV:(CGRect)frame
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(tapAction)];
    [_scrollView addGestureRecognizer:tapGes];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 30)];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_pageControl];
    //timer
    _timeInterval = 5;
    _startup = YES;
    _isCircle = YES;
}

- (DDPageType)getPageTypeFrom:(NSArray *)imageData
{
    if (![imageData count]) {
        return DDPage_Type_None;
    }
    
    id obj = [imageData firstObject];
    
    if ([obj isKindOfClass:[UIImage class]]) {
        return DDPage_Type_UIImage;
    }
    else if ([obj isKindOfClass:[NSData class]]) {
        return DDPage_Type_UIImageData;
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        if ([obj hasPrefix:@"http://"]) {
            return DDPage_Type_URL;
        } else {
            return DDPage_Type_ImageName;
        }
    }
    
    return DDPage_Type_None;
}

- (void)setImageData:(NSArray *)imageData
{
    [self setImageData:imageData
                  type:[self getPageTypeFrom:imageData]
                   key:self.imageNameKey];
}

- (void)setImageData:(NSArray *)imageData type:(DDPageType)type key:(NSString *)key
{
    if ([imageData count] < 1 || type == DDPage_Type_None) {
        DLog(@"DDPageCV imageData none!");
        return;
    }
    
    _imageData = imageData;
    self.imageNameKey = key;
    self.type = type;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    _pageControl.numberOfPages = [imageData count];
    _pageControl.currentPage   = 0;
    _imageData                = imageData;
    NSMutableArray *newArrM   = [imageData mutableCopy];
    if (_isCircle) {
        [newArrM insertObject:[imageData lastObject] atIndex:0];
        [newArrM addObject:imageData[0]];
        [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
    }
    _factImageCount = [newArrM count];
    _scrollView.contentSize = CGSizeMake(self.width * _factImageCount, self.height);
    
    for (NSInteger i = 0; i < _factImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.width,
                                                                               0,
                                                                               self.width,
                                                                               self.height)];
        id imageObj = key ? newArrM[i][key] : newArrM[i];
        
        switch (type) {
            case DDPage_Type_UIImage: //
            {
                [imageView setImage:imageObj];
            }
                break;
            case DDPage_Type_UIImageData: //
            {
                [imageView setImage:[UIImage imageWithData:imageObj]];
            }
                break;
            case DDPage_Type_ImageName: //
            {
                [imageView setImage:[UIImage imageNamed:imageObj]];
            }
                break;
            case DDPage_Type_URL: //
            {
                [imageView sd_setImageWithURL:[imageObj toURL]
                             placeholderImage:[UIImage imageNamed:self.placeholderName]];
            }
                break;
            default:
                break;
        }
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:imageView];
    }
    
    if (_startup) {
        [self setStartup:YES];
    }
}

- (void)setStartup:(BOOL)startup
{
    _startup = startup;
    
    if (startup) {
        _isCircle = YES;
        _timer = [self pageControlTimer];
    } else {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    [_timer invalidate];
    _timer = nil;
    _timer = [self pageControlTimer];
}

#pragma mark - setShowPageControl

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

#pragma mark - isCircle

- (void)setIsCircle:(BOOL)isCircle
{
    _isCircle = isCircle;
    [self setImageData:self.imageData type:self.type key:self.imageNameKey];
}

#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isCircle) {
        NSInteger offsetX = scrollView.contentOffset.x;
        if (offsetX > (_factImageCount-1) * self.width) {
            [scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
        } else if (offsetX < self.width) {
            [scrollView setContentOffset:CGPointMake((_factImageCount-1) * self.width, 0) animated:NO];
        }
    }
    
    [self updatePageIndex];
}

#pragma mark - tapAction

- (void)tapAction
{
    if (self.pageControlViewBlock) {
        NSInteger page = _pageControl.currentPage;
        self.pageControlViewBlock(page, _imageData[page]);
    }
}

#pragma mark - timerAction

- (void)timerAction:(NSTimer *)sender
{
    NSInteger offsetX = _scrollView.contentOffset.x + 5;
    
    if (offsetX > (_factImageCount-1) * self.width) {
        [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+self.width, 0) animated:YES];
    } else {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+self.width, 0) animated:YES];
    }
    
}

- (void)updatePageIndex
{
    NSInteger offsetX = _scrollView.contentOffset.x;
    
    if (!_isCircle) {
        _pageControl.currentPage = offsetX / self.width;
    } else {
        NSInteger index = offsetX / self.width;
        if (index == 1) {
            _pageControl.currentPage = 0;
        } else if (index > _factImageCount-2) {
            _pageControl.currentPage = 0;
        } else {
            _pageControl.currentPage = index - 1;
        }
    }
}

- (NSTimer *)pageControlTimer
{
    [_timer invalidate];
    _timer = nil;
    return [NSTimer scheduledTimerWithTimeInterval:self.timeInterval
                                            target:self
                                          selector:@selector(timerAction:)
                                          userInfo:nil
                                           repeats:YES];
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
