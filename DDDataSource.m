//
//  DDDataSource.m
//  Zhaoing
//
//  Created by ccxdd on 14-4-25.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDDataSource.h"

#pragma mark - DDDataSourceCellItem -

@implementation DDDataSourceCellItem

+ (instancetype)cellItemWithClass:(Class)cellClass isNib:(BOOL)isNib
{
    DDDataSourceCellItem *item = [DDDataSourceCellItem new];
    item.cellClass = cellClass;
    item.isNib = isNib;
    
    return item;
}

- (void)setCellClass:(Class)cellClass isNib:(BOOL)isNib
{
    _cellClass = cellClass;
    _isNib = isNib;
}

@end

#pragma mark - DDDataSource -

@interface DDDataSource ()

@property (nonatomic, copy  ) NSString            *cellIdentifier;
//mulitCell
@property (nonatomic, strong) NSMutableDictionary *registerCell;
@property (nonatomic, copy) void (^multipleCellBlock)(NSIndexPath *indexPath, DDDataSourceCellItem *cellItem);

@end

@implementation DDDataSource

- (id)initWithTableData:(NSArray *)tableData
         cellIdentifier:(NSString *)cellIdentifier
  cellForRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath
{
    self = [super init];
    
    if (self) {
        _tableData             = [NSMutableArray arrayWithArray:tableData];
        _cellIdentifier        = cellIdentifier;
        _cellForRowAtIndexPath = [cellForRowAtIndexPath copy];
        _isAllowEdit           = NO;
        _totalHeight           = 0;
    }
    
    return self;
}

+ (id)tableData:(NSArray *)tableData
   multipleCell:(void (^)(NSIndexPath *indexPath, DDDataSourceCellItem *cellItem))multipleCell
cellForRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath
{
    DDDataSource *dds = [DDDataSource new];
    
    dds.tableData             = [NSMutableArray arrayWithArray:tableData];
    dds.multipleCellBlock     = [multipleCell copy];
    dds.cellForRowAtIndexPath = [cellForRowAtIndexPath copy];
    dds.isAllowEdit           = NO;
    dds.registerCell          = [NSMutableDictionary dictionary];
    
    return dds;
}

- (void)setTableData:(NSMutableArray *)tableData
{
    _tableData = [NSMutableArray arrayWithArray:tableData];
}

#pragma mark - TableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    _totalHeight = 0;
    
    if (_numberOfSectionsInTableView) {
        return _numberOfSectionsInTableView(_tableData);
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        if (_numberOfRowsInSection) {
            return _numberOfRowsInSection(section, [self itemAtSection:section sectionKey:_sectionKey]);
        } else if (_numberOfSectionsInTableView) {
            NSArray *sectionArr = [self itemAtSection:section sectionKey:_sectionKey];
            return [sectionArr count];
        } else {
            return [_tableData count];
        }
    }
    @catch (NSException *exception) {
        DLog(@"\n exception:%@", NSStringFromSelector(_cmd));
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id cellIndexItem;
    
    @try {
        if (_multipleCellBlock) {
            DDDataSourceCellItem *cellItem = [DDDataSourceCellItem new];
            _multipleCellBlock(indexPath, cellItem);
            if (cellItem.cellClass) {
                NSString *cellIdentifier = NSStringFromClass(cellItem.cellClass);
                if (!_registerCell[cellIdentifier]) {
                    if (cellItem.isNib) {
                        [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil]
                        forCellReuseIdentifier:cellIdentifier];
                        _registerCell[cellIdentifier] = cellItem.cellClass;
                    } else {
                        [tableView registerClass:cellItem.cellClass
                          forCellReuseIdentifier:cellIdentifier];
                    }
                }
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            } else {
                @throw [NSException exceptionWithName:@"DDDataSource Exception" reason:@"Register Cell Error!!!" userInfo:nil];
            }
        } else if (!_cellForIndexPath) {
            cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
            if (!cell) {
                cell = _cellForIndexPath(indexPath);
            }
        }
    }
    @catch (NSException *exception) {
        DLog(@"\n exception:%@", NSStringFromSelector(_cmd));
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    if (_cellForRowAtCustom) {
        _cellForRowAtCustom(cell, indexPath);
    } else if (_cellForRowAtIndexPath) {
        cellIndexItem = [self itemAtIndexPath:indexPath sectionKey:_sectionKey rowKey:nil];
        _cellForRowAtIndexPath(cell, indexPath, cellIndexItem);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id item = [self itemAtIndexPath:indexPath sectionKey:_sectionKey rowKey:nil];
        [_tableData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (_deleteRowAtIndexPath) {
            _deleteRowAtIndexPath(indexPath, item);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_canEditRowAtIndexPath) {
        id item = [self itemAtIndexPath:indexPath sectionKey:_sectionKey rowKey:nil];
        return _canEditRowAtIndexPath(indexPath, item);
    }
    
    return _isAllowEdit;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_titleForHeaderInSection) {
        return _titleForHeaderInSection(section, [_tableData atIndex:section]);
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (_titleForFooterInSection) {
        return _titleForFooterInSection(section, [_tableData atIndex:section]);
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    
    if (_heightForRowAtIndexPath) {
        id item = [self itemAtIndexPath:indexPath sectionKey:_sectionKey rowKey:nil];
        rowHeight =  _heightForRowAtIndexPath(indexPath, item);
    } else {
        rowHeight =  tableView.rowHeight;
    }
    
    _totalHeight += rowHeight;
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (_heightForHeaderInSection) {
        return _heightForHeaderInSection(section, [_tableData atIndex:section]);
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_heightForFooterInSection) {
        return _heightForFooterInSection(section, [_tableData atIndex:section]);
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_viewForHeaderInSection) {
        return _viewForHeaderInSection(section, [_tableData atIndex:section]);
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_viewForFooterInSection) {
        return _viewForFooterInSection(section, [_tableData atIndex:section]);
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellItem;
    
    if (!tableView.allowsMultipleSelection) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (_didSelectRowAtCustom) {
        _didSelectRowAtCustom(indexPath);
    } else if (_didSelectRowAtIndexPath) {
        cellItem = [self itemAtIndexPath:indexPath sectionKey:_sectionKey rowKey:_rowKey];
        _didSelectRowAtIndexPath(indexPath, cellItem);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didDeselectRowAtIndexPath) {
        id cellItem;
        cellItem = [self itemAtIndexPath:indexPath sectionKey:_sectionKey rowKey:_rowKey];
        _didDeselectRowAtIndexPath(indexPath, cellItem);
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editingStyleForRowAtIndexPath) {
        return _editingStyleForRowAtIndexPath(indexPath);
    } else if (_isAllowEdit && tableView.allowsMultipleSelection) {
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_sectionIndexTitlesForTableView) {
        return _sectionIndexTitlesForTableView();
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除", nil);
}

- (id)itemAtSection:(NSInteger)section sectionKey:(NSString *)sectionKey
{
    id value;
    
    @try {
        if (_numberOfSectionsInTableView && _tableData.count > 1) {
            if (sectionKey) {
                value = [_tableData atIndex:section][sectionKey];
            } else {
                value = [_tableData atIndex:section];
            }
        }
    }
    @catch (NSException *exception) {
        value = nil;
        DLog(@"\n exception:%@", NSStringFromSelector(_cmd));
    }
    
    return value;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath sectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey
{
    if (!_tableData.count) {
        return nil;
    }
    
    id value;
    
    @try {
        if (_numberOfSectionsInTableView) {
            if (sectionKey && rowKey) {
                value = _tableData[indexPath.section][sectionKey][indexPath.row][rowKey];
            } else if (sectionKey) {
                value = _tableData[indexPath.section][sectionKey][indexPath.row];
            } else if (rowKey) {
                value = _tableData[indexPath.section][indexPath.row][rowKey];
            } else {
                value = _tableData[indexPath.section][indexPath.row];
            }
        } else if (rowKey) {
            value = _tableData[indexPath.row][rowKey];
        } else {
            value = _tableData[indexPath.row];
        }
    }
    @catch (NSException *exception) {
        value = nil;
        DLog(@"\n exception:%@", NSStringFromSelector(_cmd));
    }
    
    return value;
}

@end


