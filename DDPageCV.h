//
//  DDPageCV.h
//  TianXianPei
//
//  Created by ccxdd on 13-12-28.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDPageType) {
    DDPage_Type_None = 0,
    DDPage_Type_UIImage,
    DDPage_Type_UIImageData,
    DDPage_Type_ImageName,
    DDPage_Type_URL,
};

@interface DDPageCV : UIView

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIPageControl    *pageControl;

@property (nonatomic, strong) NSArray        *imageData;
@property (nonatomic, assign) BOOL           showPageControl;
@property (nonatomic, assign) BOOL           isCircle;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BOOL           startup;
@property (nonatomic, copy  ) NSString       *key;
@property (nonatomic, copy  ) NSString       *placeholderName;
@property (nonatomic, copy  ) NSString       *urlPrefix;
@property (nonatomic, copy) void(^selectedBlock)(NSInteger page, id item);

- (void)setImageData:(NSArray *)imageData type:(DDPageType)type key:(NSString *)key;

- (DDPageType)getPageTypeFrom:(NSArray *)imageData;

@end
