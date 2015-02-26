//
//  DDPageCV.m
//  TianXianPei
//
//  Created by ccxdd on 13-12-28.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "DDPageCV.h"

#pragma mark - PageCvCell -

@interface PageCvCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *name;

@end

@implementation PageCvCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        self.name = [UILabel new];
        self.name.font = [UIFont systemFontOfSize:12];
        self.name.textColor = [UIColor whiteColor];
        self.name.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
        self.name.hidden = YES;
        [self.contentView addSubview:self.name];
        
        NSDictionary *views = @{@"imageView":self.imageView,
                                @"label":self.name};
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.name.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|"
                                                                     options:0 metrics:nil
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|"
                                                                     options:0 metrics:nil
                                                                       views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|"
                                                                     options:0 metrics:nil
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(35)]|"
                                                                     options:0 metrics:nil
                                                                       views:views]];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageView sd_cancelCurrentImageLoad];
}

@end

#pragma mark - DDPageCV -

@interface DDPageCV () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIPageControl    *pageControl;

@property (nonatomic, strong) NSTimer          *timer;
@property (nonatomic, copy  ) NSString         *imageNameKey;
@property (nonatomic, assign) NSInteger        factImageCount;
@property (nonatomic, assign) DDPageType       type;
@property (nonatomic, assign) BOOL             lockStatus;
@property (nonatomic, strong) NSMutableArray   *reformImageData;

@end

@implementation DDPageCV

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configPageCV];
}

- (void)dealloc
{
    self.startup = NO;
}

#pragma mark - configPageCV

- (void)configPageCV
{
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[PageCvCell class]
            forCellWithReuseIdentifier:@"PageCvCell"];
    
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
    
    _pageControl.numberOfPages = [imageData count];
    _pageControl.currentPage   = 0;
    _imageData                = imageData;
    _reformImageData   = [imageData mutableCopy];
    if (_isCircle) {
        [_reformImageData insertObject:[imageData lastObject] atIndex:0];
        [_reformImageData addObject:imageData[0]];
    }
    _factImageCount = [_reformImageData count];
    
    if (_startup) {
        //[self setStartup:YES];
    }
    
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
    });
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
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
        } else if (offsetX < self.width) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_factImageCount-1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
        }
    }
    
    [self updatePageIndex];
}

#pragma mark - timerAction

- (void)timerAction:(NSTimer *)sender
{
    
}

- (void)updatePageIndex
{
    NSInteger offsetX = self.collectionView.contentOffset.x;
    
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

#pragma mark CollectionView Delegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _factImageCount;
}

- (PageCvCell *)collectionView:(UICollectionView *)collectionView
        cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"PageCvCell";
    PageCvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                 forIndexPath:indexPath];
    cell.imageView.backgroundColor = kRandomColor;
    
    id imageObj = self.imageNameKey ? _reformImageData[indexPath.row][self.imageNameKey] : _reformImageData[indexPath.row];
    
    switch (self.type) {
        case DDPage_Type_UIImage: //
        {
            [cell.imageView setImage:imageObj];
        }
            break;
        case DDPage_Type_UIImageData: //
        {
            [cell.imageView setImage:[UIImage imageWithData:imageObj]];
        }
            break;
        case DDPage_Type_ImageName: //
        {
            [cell.imageView setImage:[UIImage imageNamed:imageObj]];
        }
            break;
        case DDPage_Type_URL: //
        {
            [cell.imageView loadImageData:imageObj];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedBlock) {
        self.selectedBlock(self.pageControl.currentPage, [self.reformImageData atIndex:indexPath.row]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width, collectionView.height);
}

@end
