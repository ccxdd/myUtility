//
//  ParentViewController.h
//  Trafish
//
//  Created by ccxdd on 13-11-14.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewController : UIViewController

@property (nonatomic, copy) void(^viewDidAppearBlock)(UIViewController *selfVC);
@property (nonatomic, copy) void(^viewDidDisappearBlock)(UIViewController *selfVC);
@property (nonatomic, copy) void(^viewWillAppearBlock)(UIViewController *selfVC);
@property (nonatomic, copy) void(^viewWillDisappearBlock)(UIViewController *selfVC);

@property (nonatomic, copy) void(^customHandleBlock)(UIViewController *selfVC, id parameter);

@end
