//
//  PhoneContact.m
//  ZH_iOS
//
//  Created by ccxdd on 15/7/13.
//  Copyright (c) 2015年 上海佐昊网络科技有限公司. All rights reserved.
//

#import "PhoneContact.h"
@import AddressBook;
@import AddressBookUI;

@interface PhoneContact () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, copy) void(^completionBlock)(NSString *name, NSString *phone);
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) ABPeoplePickerNavigationController *peoplePicker;

@end

@implementation PhoneContact

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (void)selectedWithCompletion:(void(^)(NSString *name, NSString *phone))completion
{
    void(^openContactBlock)() = ^{
        PhoneContact *phoneContact = [PhoneContact sharedInstance];
        phoneContact.completionBlock = [completion copy];
        phoneContact.currentVC = [UIViewController currentVC];
        phoneContact.peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        phoneContact.peoplePicker.peoplePickerDelegate = phoneContact;
        NSArray *displayItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],nil];
        phoneContact.peoplePicker.displayedProperties=displayItems;
        [phoneContact.currentVC presentViewController:phoneContact.peoplePicker animated:YES completion:nil];
    };
    
    ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        //如果该应用从未申请过权限，申请权限
        ABAddressBookRequestAccessWithCompletion(abRef, ^(bool granted, CFErrorRef error) {
            //根据granted参数判断用户是否同意授予权限
            !granted ?: openContactBlock();
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        //如果权限已经被授予
        openContactBlock();
    } else {
        //如果权限被收回，只能提醒用户去系统设置菜单中打开
        if (iOS8_OR_LATER) {
            [BMWaitVC showAlertMessage:@"点击［确定］将打开通讯录设置界面" title:@"通讯录未授权" buttonTitles:@[@"取消", @"确定"] alertBlock:^(NSInteger buttonIndex) {
                if (buttonIndex) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通讯录未授权" message:@"请在 设置->隐私->通讯录 里开启授权" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

#pragma mark - iOS 8 -

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName == nil) {
        firstName = @"";
    }
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName == nil) {
        lastName = @"";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:identifier];
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            !_completionBlock ?: _completionBlock([NSString stringWithFormat:@"%@%@", firstName, lastName], phone);
        }];
    }
    CFRelease(phoneMulti);
}

#pragma mark - iOS 7 -

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName == nil) {
        firstName = @"";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName == nil) {
        lastName = @"";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:identifier];
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            !_completionBlock ?: _completionBlock([NSString stringWithFormat:@"%@%@", firstName, lastName], phone);
        }];
    }
    CFRelease(phoneMulti);
    
    return NO;
}

@end
