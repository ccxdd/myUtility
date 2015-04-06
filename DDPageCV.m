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

@property (nonatomic, strong) NSTimer          *timer;
@property (nonatomic, copy  ) NSString         *imageNameKey;
@property (nonatomic, assign) NSInteger        factImageCount;
@property (nonatomic, assign) DDPageType       type;
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
    //CollectionView
    
    if (!self.collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumLineSpacing:0];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setSectionInset:UIEdgeInsetsZero];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                 collectionViewLayout:flowLayout];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionView setPagingEnabled:YES];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView registerClass:[PageCvCell class]
                forCellWithReuseIdentifier:@"PageCvCell"];
        [self addSubview:self.collectionView];
        
        NSDictionary *views = @{@"collView":self.collectionView};
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collView]|"
                                                                     options:0 metrics:nil
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collView]|"
                                                                     options:0 metrics:nil
                                                                       views:views]];
    }
    
    //PageControl
    
    if (!self.pageControl) {
        self.pageControl = [UIPageControl new];
        [self addSubview:self.pageControl];
        
        NSDictionary *views = @{@"pageControl":self.pageControl};
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControl]|"
                                                                     options:0 metrics:nil
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl(20)]|"
                                                                     options:0 metrics:nil
                                                                       views:views]];
    }
    
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
    self.factImageCount = [_reformImageData count];
    
    if (_startup) {
        [self setStartup:YES];
    }
    
    if (_isCircle) {
        NSIndexPath *currIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
        if (!currIndexPath) {
            currIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        [self.collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:currIndexPath
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
            [self updatePageIndex];
        });
    } else {
        [self.collectionView reloadData];
    }
}

- (void)setStartup:(BOOL)startup
{
    _startup = startup;
    
    if (startup) {
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

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isCircle && self.factImageCount) {
        NSInteger offsetX = scrollView.contentOffset.x;
        if (offsetX > (self.factImageCount-1) * self.width) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
        } else if (offsetX < self.width) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.factImageCount-1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
        }
    }
    
    [self updatePageIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.startup = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startup = NO;
}

#pragma mark - 刷新Page指示

- (void)updatePageIndex
{
    NSInteger offsetX = self.collectionView.contentOffset.x;
    
    if (!_isCircle) {
        _pageControl.currentPage = offsetX / self.width;
    } else {
        NSInteger index = offsetX / self.width;
        if (index == 1) {
            _pageControl.currentPage = 0;
        } else if (index > self.factImageCount-2) {
            _pageControl.currentPage = 0;
        } else {
            _pageControl.currentPage = index - 1;
        }
    }
}

#pragma mark - timerAction

- (void)timerAction:(NSTimer *)sender
{
    if (self.factImageCount) {
        
        NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
        
        if (self.isCircle) {
            if (currentIndexPath.item == self.factImageCount-1) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                    animated:NO];
                currentIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            }
        } else {
            if (currentIndexPath.item == self.imageData.count-1) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                    animated:YES];
                return;
            }
        }
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndexPath.item+1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
}

- (NSTimer *)pageControlTimer
{
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval
                                            target:self
                                          selector:@selector(timerAction:)
                                          userInfo:nil
                                           repeats:YES];
    return _timer;
}

#pragma mark - CollectionView Delegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.factImageCount;
}

- (PageCvCell *)collectionView:(UICollectionView *)collectionView
        cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"PageCvCell";
    PageCvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                 forIndexPath:indexPath];
    
    id imageObj = self.imageNameKey ? [_reformImageData[indexPath.row] valueForKey:self.imageNameKey] : _reformImageData[indexPath.row];
    
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
            NSString *imageURL = self.urlPrefix ? [self.urlPrefix addSuffix:imageObj] : imageObj;
            if (self.placeholderName) {
                [cell.imageView sd_setImageWithURL:[imageURL toURL] placeholderImage:[UIImage imageNamed:self.placeholderName]];
            } else {
                [cell.imageView sd_setImageWithURL:[imageURL toURL]];
            }
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
