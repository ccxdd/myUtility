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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (instancetype)simpleWithTitle:(NSString *)title
                    cellXibName:(NSString *)cellXibName
                      tableData:(NSArray *)tableData
                      rowHeight:(CGFloat)rowHeight
          cellForRowAtIndexPath:(void(^)(UITableViewCell *cell, NSIndexPath *indexPath, id item))cellForRowAtIndexPath
        didSelectRowAtIndexPath:(void(^)(NSIndexPath *indexPath))didSelectRowAtIndexPath
{
    DDSimpleTableViewController *stvc = [[DDSimpleTableViewController alloc] init];
    stvc.title       = title;
    stvc.cellXibName = cellXibName;
    stvc.rowHeight   = rowHeight;
    
    stvc.tableDataDS = [[DDDataSource alloc] initWithTableData:tableData
                                                cellIdentifier:cellXibName
                                         cellForRowAtIndexPath:cellForRowAtIndexPath];
    [stvc.tableDataDS setDidSelectRowAtIndexPath:didSelectRowAtIndexPath];
    
    return stvc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kVcBackgroundColor;
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kSCREEN_HEIGHT)
                                              style:UITableViewStylePlain];
    [_tableView setDelegate:_tableDataDS];
    [_tableView setDataSource:_tableDataDS];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setRowHeight:_rowHeight];
    [_tableView registerNib:[UINib nibWithNibName:self.cellXibName bundle:nil]
     forCellReuseIdentifier:self.cellXibName];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
