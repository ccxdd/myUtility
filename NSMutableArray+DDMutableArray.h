//
//  NSMutableArray+DDMutableArray.h
//  WenStore
//
//  Created by ccxdd on 14-6-22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (DDMutableArray)

- (void)addUniqueObject:(id)object;

- (void)addSafeObject:(id)object;

@end
