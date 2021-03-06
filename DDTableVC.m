//
//  DDTableVC.m
//  WenStore
//
//  Created by ccxdd on 14-6-20.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDTableVC.h"

@interface DDTableVC ()

@end

@implementation DDTableVC

- (void)awakeFromNib
{
    self.cellClassName = self.cellClassName.length > 0 ? self.cellClassName : @"UITableViewCell";
    self.rowHeight     = self.rowHeight == 0 ? 44 : self.rowHeight;
    
    _tableDataDS = [[DDDataSource alloc] initWithTableData:nil
                                            cellIdentifier:self.cellClassName
                                     cellForRowAtIndexPath:nil];
    [_tableDataDS setDidSelectRowAtIndexPath:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (instancetype)viewWithTitle:(NSString *)title
                  cellClassName:(NSString *)cellClassName
                          isNib:(BOOL)isNib
                      tableData:(NSArray *)tableData
                      rowHeight:(CGFloat)rowHeight
          cellForRowAtIndexPath:(void(^)(UITableViewCell *cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath
        didSelectRowAtIndexPath:(void(^)(NSIndexPath *indexPath, id item))didSelectRowAtIndexPath
{
    DDTableVC *stvc = [[DDTableVC alloc] init];
    stvc.title         = title;
    stvc.cellClassName = cellClassName;
    stvc.rowHeight     = rowHeight;
    stvc.isNib         = isNib;
    
    stvc.tableDataDS = [[DDDataSource alloc] initWithTableData:tableData
                                                cellIdentifier:cellClassName
                                         cellForRowAtIndexPath:cellForRowAtIndexPath];
    [stvc.tableDataDS setDidSelectRowAtIndexPath:didSelectRowAtIndexPath];
    
    stvc.tableView = [[UITableView alloc] initWithFrame:stvc.view.bounds
                                                  style:UITableViewStylePlain];
    [stvc.tableView setDelegate:stvc.tableDataDS];
    [stvc.tableView setDataSource:stvc.tableDataDS];
    [stvc.tableView setBackgroundColor:[UIColor clearColor]];
    [stvc.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [stvc.tableView setRowHeight:stvc.rowHeight];
    if (stvc.isNib) {
        [stvc.tableView registerNib:[UINib nibWithNibName:stvc.cellClassName bundle:nil]
             forCellReuseIdentifier:stvc.cellClassName];
    } else {
        [stvc.tableView registerClass:NSClassFromString(stvc.cellClassName)
               forCellReuseIdentifier:stvc.cellClassName];
    }
    
    [stvc.view addSubview:stvc.tableView];
    
    return stvc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kVcBackgroundColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setRowHeight:

- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    self.tableView.rowHeight = rowHeight;
}

@end
