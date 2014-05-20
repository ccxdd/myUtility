//
//  ParentViewController.m
//  Trafish
//
//  Created by ccxdd on 13-11-14.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.viewWillAppearBlock) {
        self.viewWillAppearBlock(self);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.viewWillDisappearBlock) {
        self.viewWillDisappearBlock(self);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.viewDidAppearBlock) {
        self.viewDidAppearBlock(self);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.viewDidDisappearBlock) {
        self.viewDidDisappearBlock(self);
    }
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


@end
