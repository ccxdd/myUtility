//
//  DDLocationManager.h
//  aDiningHall
//
//  Created by ccxdd on 14-3-2.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DDLocationManager : NSObject

@property (nonatomic, readonly) CLLocation        *location;
@property (nonatomic, readonly) NSString          *address;
@property (nonatomic, readonly) CLLocationDegrees latitude;
@property (nonatomic, readonly) CLLocationDegrees longitude;

+ (void)start:(void(^)(NSDictionary *addressInfo))completeBlock;

+ (void)stop;

@end
