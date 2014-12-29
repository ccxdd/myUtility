//
//  DDImageSelector.m
//  WenStore
//
//  Created by ccxdd on 14/12/22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDImageSelector.h"

@interface DDImageSelector () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, copy) void(^imageSelectorCompletion)(UIImage *image);

@end

@implementation DDImageSelector

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (void)imageModalVC:(UIViewController *)fromVC allowsEditing:(BOOL)allowsEditing completion:(void(^)(UIImage *image))completion
{
    [DDImageSelector sharedInstance].allowsEditing = allowsEditing;
    [DDImageSelector sharedInstance].imageSelectorCompletion = completion;
    [DDImageSelector sharedInstance].fromVC = fromVC;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = allowsEditing;
    picker.delegate = [DDImageSelector sharedInstance];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [fromVC presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:self.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    [self.fromVC dismissViewControllerAnimated:YES completion:^{
        if (self.imageSelectorCompletion) {
            self.imageSelectorCompletion(image);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.fromVC dismissViewControllerAnimated:YES completion:^{
        if (self.imageSelectorCompletion) {
            self.imageSelectorCompletion(nil);
        }
    }];
}

@end
