//
//  DDDataSource.m
//  Zhaoing
//
//  Created by ccxdd on 14-4-25.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDDataSource.h"

@interface DDDataSource ()

@property (nonatomic, strong) NSArray                     *tableData;
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
        self.tableData          = tableData;
        self.cellIdentifier     = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
    }
    
    return self;
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

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableData[indexPath.row];
}

@end
