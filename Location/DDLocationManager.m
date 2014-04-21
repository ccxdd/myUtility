//
//  DDLocationManager.m
//  aDiningHall
//
//  Created by ccxdd on 14-3-2.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDLocationManager.h"
#import "TransformCorrdinate.h"

@interface DDLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation        *currentLocation;
@property (nonatomic, strong) CLGeocoder        *geocoder;
@property (nonatomic, copy  ) NSString          *currentAddress;

@property (nonatomic, copy) void(^startCompleteBlock)(NSDictionary *addressDictionary);

@end

@implementation DDLocationManager

+ (instancetype)ddLocationManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager                 = [[CLLocationManager alloc] init];
        self.geocoder                        = [[CLGeocoder alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate        = self;
        self.locationManager.distanceFilter  = 30.0f;
    }
    return self;
}

#pragma mark - start

- (void)start:(void(^)(NSDictionary *addressDictionary))completeBlock
{
    self.startCompleteBlock = completeBlock;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - stop

- (void)stop
{
    [self.locationManager stopUpdatingLocation];
}

- (CLLocation *)location
{
    return self.currentLocation;
}

- (NSString *)address
{
    return self.currentAddress;
}

- (CLLocationDegrees)latitude
{
    return self.currentLocation.coordinate.latitude;
}

- (CLLocationDegrees)longitude
{
    return self.currentLocation.coordinate.longitude;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    if (location) {
        [self geocoderFromLocation:location complete:^{
            [self stop];
        }];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error domain] == kCLErrorDomain)
    {
        switch ([error code])
        {
            case kCLErrorDenied:
            {
                [manager stopUpdatingLocation];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位未开启" message:@"请在 设置->隐私->定位服务 里开启" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                if (self.startCompleteBlock) {
                    self.startCompleteBlock(@{@"error": error});
                }
            }
                
                break;
            case kCLErrorLocationUnknown:
                break;
            default:
                break;
        }
    }
}

#pragma mark - geoCodeFromCoordinate

- (void)geocoderFromLocation:(CLLocation *)location complete:(void(^)())completeBlock
{
    CLLocationCoordinate2D fixCoordinate = [TransformCorrdinate GPSLocToGoogleLoc:location.coordinate];
    self.currentLocation = [[CLLocation alloc] initWithLatitude:fixCoordinate.latitude longitude:fixCoordinate.longitude];
    [self.geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks firstObject];
            if (self.startCompleteBlock) {
                DLog(@"placemark = %@", placemark.addressDictionary);
                DLog(@"地址 = %@", placemark.addressDictionary[@"Name"]);
                self.currentAddress = placemark.addressDictionary[@"Name"];
                self.startCompleteBlock(placemark.addressDictionary);
            }
        } else {
            DLog(@"error = %@", error);
            if (self.startCompleteBlock) {
                self.startCompleteBlock(@{@"error": error});
            }
        }
        //block
        if (completeBlock) {
            completeBlock();
        }
    }];
}

@end
