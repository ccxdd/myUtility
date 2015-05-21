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

@property (nonatomic, copy) void(^startCompleteBlock)(CLPlacemark *placemark);

@end

@implementation DDLocationManager

+ (instancetype)shareInstance
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
        self.locationManager.distanceFilter  = 10.0f;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

#pragma mark - start

+ (void)start:(void(^)(CLPlacemark *placemark))completeBlock
{
    [DDLocationManager shareInstance].startCompleteBlock = [completeBlock copy];
    [[DDLocationManager shareInstance].locationManager startUpdatingLocation];
}

#pragma mark - stop

+ (void)stop
{
    [[DDLocationManager shareInstance].locationManager stopUpdatingLocation];
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
    CLLocation *location = [locations lastObject];
    if (location) {
        [self geocoderFromLocation:location complete:^{
            [DDLocationManager stop];
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
                if (iOS8_OR_LATER) {
                    [BMWaitVC showAlertMessage:@"点击［确定］将打开定位设置界面" title:@"定位服务未开启" buttonTitles:@[@"取消", @"确定"] alertBlock:^(NSInteger buttonIndex) {
                        if (buttonIndex) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                    }];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在 设置->隐私->定位服务 里开启定位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
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

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (iOS8_OR_LATER) {
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManager startUpdatingLocation];
        }
    } else {
        if (status == kCLAuthorizationStatusAuthorized) {
            [self.locationManager startUpdatingLocation];
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
                DLog(@"地址 = %@", placemark.name);
                self.currentAddress = placemark.name;
                self.startCompleteBlock(placemark);
            }
        } else {
            DLogError(@"error = %@", error);
        }
        //block
        !completeBlock ?: completeBlock();
    }];
}

+ (void)placeNameWithLocation:(CLLocation *)location completion:(void(^)(CLPlacemark *placemark))completeBlock
{
    [DDLocationManager shareInstance].startCompleteBlock = [completeBlock copy];
    [[DDLocationManager shareInstance] geocoderFromLocation:location complete:nil];
}

@end
