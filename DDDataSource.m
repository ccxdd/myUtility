//
//  DDDataSource.m
//  Zhaoing
//
//  Created by ccxdd on 14-4-25.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDDataSource.h"

@interface DDDataSource ()

@property (nonatomic, copy  ) NSString                   *cellIdentifier;

@end

@implementation DDDataSource

- (id)initWithTableData:(NSArray *)tableData
         cellIdentifier:(NSString *)cellIdentifier
  cellForRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath
{
    self = [super init];
    
    if (self) {
        self.tableData          = [NSMutableArray arrayWithArray:tableData];
        self.cellIdentifier     = cellIdentifier;
        self.cellForRowAtIndexPath = cellForRowAtIndexPath;
        self.isAllowEdit = NO;
    }
    
    return self;
}

- (void)setTableData:(NSMutableArray *)tableData
{
    _tableData = [NSMutableArray arrayWithArray:tableData];
}

#pragma mark - TableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.numberOfSectionsInTableView) {
        return self.numberOfSectionsInTableView();
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numberOfRowsInSection) {
        return self.numberOfRowsInSection(section);
    } else {
        return [self.tableData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id cellItem;
    
    @try {
        if (!self.cellForIndexPath) {
            cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
            if (!cell) {
                cell = self.cellForIndexPath(indexPath);
            }
        }
    }
    @catch (NSException *exception) {
        DLog(@"\n exception:%@", NSStringFromSelector(_cmd));
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:self.cellIdentifier];
    }
    
    cellItem = [self itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:nil];
    
    if (self.cellForRowAtIndexPath) {
        self.cellForRowAtIndexPath(cell, indexPath, cellItem);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id item = [self itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:nil];
        [self.tableData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.deleteRowAtIndexPath) {
            self.deleteRowAtIndexPath(indexPath, item);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.isAllowEdit;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.titleForHeaderInSection) {
        return self.titleForHeaderInSection(section);
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.titleForFooterInSection) {
        return self.titleForFooterInSection(section);
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (self.heightForHeaderInSection) {
        return self.heightForHeaderInSection(section);
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.heightForFooterInSection) {
        return self.heightForFooterInSection(section);
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.viewForHeaderInSection) {
        return self.viewForHeaderInSection(section);
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.viewForFooterInSection) {
        return self.viewForFooterInSection(section);
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
    
    cellItem = [self itemAtIndexPath:indexPath sectionKey:self.sectionKey rowKey:self.rowKey];
    
    if (self.didSelectRowAtIndexPath) {
        self.didSelectRowAtIndexPath(indexPath, cellItem);
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editingStyleForRowAtIndexPath) {
        return self.editingStyleForRowAtIndexPath(indexPath);
    }
    else if (self.isAllowEdit && tableView.allowsMultipleSelection) {
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.sectionIndexTitlesForTableView) {
        return self.sectionIndexTitlesForTableView();
    }
    
    return nil;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath sectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey
{
    id value;
    
    @try {
        if (self.numberOfSectionsInTableView) {
            if (sectionKey && rowKey) {
                value = self.tableData[indexPath.section][sectionKey][indexPath.row][rowKey];
            } else if (sectionKey) {
                value = self.tableData[indexPath.section][sectionKey][indexPath.row];
            } else if (rowKey) {
                value = self.tableData[indexPath.section][indexPath.row][rowKey];
            } else {
                value = self.tableData[indexPath.section][indexPath.row];
            }
        } else if (rowKey) {
            value = self.tableData[indexPath.row][rowKey];
        } else {
            value = self.tableData[indexPath.row];
        }
    }
    @catch (NSException *exception) {
        value = nil;
        DLog(@"\n exception:%@", NSStringFromSelector(_cmd));
    }
    
    return value;
}

@end
