//
//  DDDataSource.h
//  Zhaoing
//
//  Created by ccxdd on 14-4-25.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, assign) BOOL           isAllowEdit;
@property (nonatomic, copy  ) NSString       *sectionKey;
@property (nonatomic, copy  ) NSString       *rowKey;

@property (nonatomic, copy) UITableViewCell* (^cellForIndexPath)(NSIndexPath *indexPath);
//number
@property (nonatomic, copy) NSInteger (^numberOfSectionsInTableView)(void);
@property (nonatomic, copy) NSInteger (^numberOfRowsInSection)(NSInteger section);
@property (nonatomic, copy) NSArray*  (^sectionIndexTitlesForTableView)(void);
//header, footer
@property (nonatomic, copy) NSString* (^titleForHeaderInSection)(NSInteger section);
@property (nonatomic, copy) NSString* (^titleForFooterInSection)(NSInteger section);
@property (nonatomic, copy) CGFloat   (^heightForHeaderInSection)(NSInteger section);
@property (nonatomic, copy) CGFloat   (^heightForFooterInSection)(NSInteger section);
@property (nonatomic, copy) UIView*   (^viewForHeaderInSection)(NSInteger section);
@property (nonatomic, copy) UIView*   (^viewForFooterInSection)(NSInteger section);
//edit
@property (nonatomic, copy) UITableViewCellEditingStyle (^editingStyleForRowAtIndexPath)(NSIndexPath *indexPath);
//cellForRow, didSelect
@property (nonatomic, copy) void      (^cellForRowAtIndexPath)(id cell, NSIndexPath *indexPath, id item);
@property (nonatomic, copy) void      (^didSelectRowAtIndexPath)(NSIndexPath *indexPath, id item);

- (id)initWithTableData:(NSArray *)tableData
         cellIdentifier:(NSString *)cellIdentifier
  cellForRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath sectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey;

@end
