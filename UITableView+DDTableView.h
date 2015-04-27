//
//  UITableView+DDTableView.h
//  WenStore
//
//  Created by ccxdd on 14-7-19.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDataSource;

@interface UITableView (DDTableView)

/**
 *  返回当前tableView的DataSource
 *
 *  @return DDDateSource
 */
- (DDDataSource *)tableViewDS;

/**
 *  返回当前选中的row值
 *
 *  @param sectionKey sectionKey
 *  @param rowKey     rowKey
 *
 *  @return row值
 */
- (id)selectedRowValueWithSectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey;

/**
 *  返回当前选中的row值(多选)
 *
 *  @param sectionKey sectionKey
 *  @param rowKey     rowKey
 *
 *  @return row值(多选)
 */
- (NSMutableArray *)selectedRowsValuesWithSectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey;

/**
 *  选中指定的row(只支持单一Section)
 *
 *  @param array     被选值列表
 *  @param key       列中的key
 *  @param targetKey DataSource中的key
 */
- (void)selectedRowsForArray:(NSArray *)array key:(NSString *)key targetKey:(NSString *)targetKey;

- (void)multipleSelection:(BOOL)multipleSelection;

/**
 *  Cell自适应
 *
 *  @param identifier    cell identifier
 *  @param configuration block
 *
 *  @return cell height
 */
- (CGFloat)heightForCellWithIdentifier:(NSString *)identifier configuration:(void(^)(id cell))configuration;

/**
 *  注册Cell(nib名字默认和identifier相同)
 *
 *  @param nibArray Nib Names
 */
- (void)registerCellWithNibArray:(NSArray *)nibArray;

@end
