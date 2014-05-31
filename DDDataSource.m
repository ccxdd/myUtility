//
//  DDDataSource.m
//  Zhaoing
//
//  Created by ccxdd on 14-4-25.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDDataSource.h"

@interface DDDataSource ()

@property (nonatomic, copy  ) NSString                    *cellIdentifier;
@property (nonatomic, copy  ) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation DDDataSource

- (id)initWithTableData:(NSArray *)tableData
         cellIdentifier:(NSString *)cellIdentifier
     configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
{
    self = [super init];
    
    if (self) {
        self.tableData          = [NSMutableArray arrayWithArray:tableData];
        self.cellIdentifier     = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
        self.isAllowEdit = NO;
    }
    
    return self;
}

- (void)setTableData:(NSMutableArray *)tableData
{
    _tableData = [NSMutableArray arrayWithArray:tableData];
}

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSUInteger)[self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, self.tableData[indexPath.row]);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.isAllowEdit;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableData[indexPath.row];
}

@end
