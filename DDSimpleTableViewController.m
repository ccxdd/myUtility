//
//  DDSimpleTableViewController.m
//  WenStore
//
//  Created by ccxdd on 14-6-20.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDSimpleTableViewController.h"

@interface DDSimpleTableViewController ()

@end

@implementation DDSimpleTableViewController

- (void)awakeFromNib
{
    self.isNib         = NO;
    self.cellClassName = @"UITableViewCell";
    self.rowHeight     = 44;
    
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

+ (instancetype)simpleWithTitle:(NSString *)title
                  cellClassName:(NSString *)cellClassName
                          isNib:(BOOL)isNib
                      tableData:(NSArray *)tableData
                      rowHeight:(CGFloat)rowHeight
          cellForRowAtIndexPath:(void(^)(UITableViewCell *cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath
        didSelectRowAtIndexPath:(void(^)(NSIndexPath *indexPath, id item))didSelectRowAtIndexPath
{
    DDSimpleTableViewController *stvc = [[DDSimpleTableViewController alloc] init];
    stvc.title         = title;
    stvc.cellClassName = cellClassName;
    stvc.rowHeight     = rowHeight;
    stvc.isNib         = isNib;
    
    stvc.tableDataDS = [[DDDataSource alloc] initWithTableData:tableData
                                                cellIdentifier:cellClassName
                                         cellForRowAtIndexPath:cellForRowAtIndexPath];
    [stvc.tableDataDS setDidSelectRowAtIndexPath:didSelectRowAtIndexPath];
    
    stvc.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kSCREEN_HEIGHT)
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

#pragma mark - allowsMultipleSelection

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    _tableDataDS.isAllowEdit = _allowsMultipleSelection;
    _tableView.editing = _allowsMultipleSelection;
    _tableView.allowsMultipleSelection = _allowsMultipleSelection;
}

#pragma mark - selectedRowValueWithSectionKey:rowKey:

- (id)selectedRowValueWithSectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey
{
    return [self.tableDataDS itemAtIndexPath:_tableView.indexPathForSelectedRow sectionKey:sectionKey rowKey:rowKey];
}

#pragma mark - selectedRowsValuesWithSectionKey:rowKey:

- (NSArray *)selectedRowsValuesWithSectionKey:(NSString *)sectionKey rowKey:(NSString *)rowKey
{
    NSArray *indexPaths = _tableView.indexPathsForSelectedRows;
    NSMutableArray *values = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths) {
        [values addObject:[self.tableDataDS itemAtIndexPath:indexPath sectionKey:sectionKey rowKey:rowKey]];
    }
    
    return values;
}

#pragma mark - selectedRowsForArray:key:targetKey:

- (void)selectedRowsForArray:(NSArray *)array key:(NSString *)key targetKey:(NSString *)targetKey
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *keyValue = [NSString stringWithFormat:@"%@", key ? obj[key] : obj];
        [self.tableDataDS.tableData enumerateObjectsUsingBlock:^(id tableDataObj, NSUInteger idx, BOOL *stop) {
            NSString *targetValue = [NSString stringWithFormat:@"%@", targetKey?tableDataObj[targetKey]:tableDataObj];
            if ([keyValue isEqualToString:targetValue]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
            }
        }];
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
