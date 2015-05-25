//
//  UITableView+DDTableView.m
//  WenStore
//
//  Created by ccxdd on 14-7-19.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "UITableView+DDTableView.h"
#import "DDDataSource.h"

@implementation UITableView (DDTableView)

- (DDDataSource *)tableViewDS
{
    id ds = self.dataSource;
    
    if ([ds isKindOfClass:[DDDataSource class]]) {
        return ds;
    } else {
        DLog(@"************DataSource is not DDDateSource!!!************");
        return nil;
    }
}

#pragma mark - multipleSelection

- (void)multipleSelection:(BOOL)multipleSelection
{
    self.allowsMultipleSelection = multipleSelection;
    
    DDDataSource *ds = [self tableViewDS];
    
    if (ds) {
        ds.isAllowEdit = multipleSelection;
        self.editing = multipleSelection;
    }
}

#pragma mark - selectedRowValueWithSectionKey:rowKey:

- (id)selectedRowValueWithSectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey
{
    return [[self tableViewDS] itemAtIndexPath:self.indexPathForSelectedRow sectionKey:sectionKey rowKey:rowKey];
}

#pragma mark - selectedRowsValuesWithSectionKey:rowKey:

- (NSMutableArray *)selectedRowsValuesWithSectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey
{
    DDDataSource *ds = [self tableViewDS];
    
    if (ds) {
        NSArray *indexPaths = self.indexPathsForSelectedRows;
        NSMutableArray *values = [NSMutableArray array];
        for (NSIndexPath *indexPath in indexPaths) {
            [values addObject:[ds itemAtIndexPath:indexPath sectionKey:sectionKey rowKey:rowKey]];
        }
        
        return [values count] ? values : nil;
    }
    
    return nil;
}

#pragma mark - selectedRowsForArray:key:targetKey:

- (void)selectedRowsForArray:(NSArray *)array key:(NSString *)key targetKey:(NSString *)targetKey
{
    DDDataSource *ds = [self tableViewDS];
    
    if (ds && self.allowsMultipleSelection) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *keyValue = [NSString stringWithFormat:@"%@", key ? obj[key] : obj];
            [ds.tableData enumerateObjectsUsingBlock:^(id tableDataObj, NSUInteger idx, BOOL *stop) {
                NSString *targetValue = [NSString stringWithFormat:@"%@", targetKey?tableDataObj[targetKey]:tableDataObj];
                if ([keyValue isEqualToString:targetValue]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [self selectRowAtIndexPath:indexPath
                                      animated:NO
                                scrollPosition:UITableViewScrollPositionNone];
                }
            }];
        }];
    }
}

- (CGFloat)heightForCellWithIdentifier:(NSString *)identifier configuration:(void(^)(id cell))configuration
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    [cell prepareForReuse];
    
    if (configuration) {
        configuration(cell);
    }
    
    for (id item in cell.getPropertyObjects.allValues) {
        if ([item isKindOfClass:[UILabel class]]) {
            UILabel *lab = item;
            lab.preferredMaxLayoutWidth = lab.width - 1;
        }
    }
    
    CGSize fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
    }
    
    return fittingSize.height + 1;
}

- (void)registerCellWithNibArray:(NSArray *)nibArray
{
    for (NSString *identifier in nibArray) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:identifier];
    }
}

@end
