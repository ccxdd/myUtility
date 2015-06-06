//
//  DDDataSource.h
//  Zhaoing
//
//  Created by ccxdd on 14-4-25.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - DDDataSourceCellItem -

@interface DDDataSourceCellItem : NSObject

@property (nonatomic, assign) Class     cellClass;
@property (nonatomic, assign) BOOL      isNib;

+ (instancetype)cellItemWithClass:(Class)cellClass isNib:(BOOL)isNib;
- (void)setCellClass:(Class)cellClass isNib:(BOOL)isNib;

@end

#pragma mark - DDDataSource -

@interface DDDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong          ) NSMutableArray *tableData;
@property (nonatomic, assign          ) BOOL           isAllowEdit;
@property (nonatomic, copy            ) NSString       *sectionKey;
@property (nonatomic, copy            ) NSString       *rowKey;
@property (nonatomic, assign, readonly) CGFloat        totalHeight;

@property (nonatomic, copy) UITableViewCell* (^cellForIndexPath)(NSIndexPath *indexPath);
//number
@property (nonatomic, copy) NSInteger (^numberOfSectionsInTableView)(NSMutableArray *tableData);
@property (nonatomic, copy) NSInteger (^numberOfRowsInSection)(NSInteger section, id item);
@property (nonatomic, copy) NSArray*  (^sectionIndexTitlesForTableView)(void);
//header, footer
@property (nonatomic, copy) NSString* (^titleForHeaderInSection)(NSInteger section, id item);
@property (nonatomic, copy) NSString* (^titleForFooterInSection)(NSInteger section, id item);
@property (nonatomic, copy) CGFloat   (^heightForHeaderInSection)(NSInteger section, id item);
@property (nonatomic, copy) CGFloat   (^heightForFooterInSection)(NSInteger section, id item);
@property (nonatomic, copy) UIView*   (^viewForHeaderInSection)(NSInteger section, id item);
@property (nonatomic, copy) UIView*   (^viewForFooterInSection)(NSInteger section, id item);
//edit, delete
@property (nonatomic, copy) UITableViewCellEditingStyle (^editingStyleForRowAtIndexPath)(NSIndexPath *indexPath);
@property (nonatomic, copy) void      (^deleteRowAtIndexPath)(NSIndexPath *indexPath, id item);
@property (nonatomic, copy) BOOL      (^canEditRowAtIndexPath)(NSIndexPath *indexPath, id item);
//cellForRow, didSelect, height
@property (nonatomic, copy) void      (^cellForRowAtCustom)(id cell, NSIndexPath *indexPath);
@property (nonatomic, copy) void      (^cellForRowAtIndexPath)(id cell, NSIndexPath *indexPath, id item);
@property (nonatomic, copy) void      (^didSelectRowAtCustom)(NSIndexPath *indexPath);
@property (nonatomic, copy) void      (^didSelectRowAtIndexPath)(NSIndexPath *indexPath, id item);
@property (nonatomic, copy) void      (^didDeselectRowAtIndexPath)(NSIndexPath *indexPath, id item);
@property (nonatomic, copy) CGFloat   (^heightForRowAtIndexPath)(NSIndexPath *indexPath, id item);


- (id)initWithTableData:(NSArray *)tableData
         cellIdentifier:(NSString *)cellIdentifier
  cellForRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath;

+ (id)tableData:(NSArray *)tableData
   multipleCell:(void (^)(NSIndexPath *indexPath, DDDataSourceCellItem *cellItem))multipleCell
cellForRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath;

- (id)itemAtSection:(NSInteger)section sectionKey:(NSString *)sectionKey;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath sectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey;

@end


