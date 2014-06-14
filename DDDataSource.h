//
//  DDDataSource.h
//  Zhaoing
//
//  Created by ccxdd on 14-4-25.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, assign) BOOL           isAllowEdit;

@property (copy, nonatomic) NSInteger (^numberOfSectionsInTableView)(void);
@property (copy, nonatomic) NSInteger (^numberOfRowsInSection)(NSInteger section);
@property (copy, nonatomic) NSString* (^titleForHeaderInSection)(NSInteger section);
@property (copy, nonatomic) NSString* (^titleForFooterInSection)(NSInteger section);
@property (copy, nonatomic) NSString* (^classNameForIndexPath)(NSIndexPath *indexPath);

- (id)initWithTableData:(NSArray *)tableData
         cellIdentifier:(NSString *)cellIdentifier
  cellForRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)registerCellWithClassName:(NSString *)className;

@end
