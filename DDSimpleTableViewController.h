//
//  DDSimpleTableViewController.h
//  WenStore
//
//  Created by ccxdd on 14-6-20.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSimpleTableViewController : UIViewController

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) DDDataSource *tableDataDS;
@property (nonatomic, copy  ) NSString     *cellClassName;
@property (nonatomic, assign) CGFloat      rowHeight;
@property (nonatomic, assign) BOOL         isNib;

+ (instancetype)simpleWithTitle:(NSString *)title
                  cellClassName:(NSString *)cellClassName
                          isNib:(BOOL)isNib
                      tableData:(NSArray *)tableData
                      rowHeight:(CGFloat)rowHeight
          cellForRowAtIndexPath:(void(^)(UITableViewCell *cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath
        didSelectRowAtIndexPath:(void(^)(NSIndexPath *indexPath, id item))didSelectRowAtIndexPath;

@end