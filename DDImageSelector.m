//
//  DDImageSelector.m
//  WenStore
//
//  Created by ccxdd on 14/12/22.
//  Copyright (c) 2014年 ccxdd. All rights reserved.
//

#import "DDImageSelector.h"

@interface DDImageSelector () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) float scale;
@property (nonatomic, assign) float maxWidth;
@property (nonatomic, assign) float maxHeight;

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

+ (void)imageModalVC:(UIViewController *)fromVC
       allowsEditing:(BOOL)allowsEditing
               scale:(float)scale
          completion:(void(^)(UIImage *image))completion
{
    [self configIPCWithFromVC:fromVC allowsEditing:allowsEditing scale:scale maxWidth:0 maxHeight:0 completion:completion];
}

+ (void)imageModalVC:(UIViewController *)fromVC
       allowsEditing:(BOOL)allowsEditing
            maxWidth:(float)maxWidth
          completion:(void(^)(UIImage *image))completion
{
    [self configIPCWithFromVC:fromVC allowsEditing:allowsEditing scale:0 maxWidth:maxWidth maxHeight:0 completion:completion];
}

+ (void)imageModalVC:(UIViewController *)fromVC
       allowsEditing:(BOOL)allowsEditing
           maxHeight:(float)maxHeight
          completion:(void(^)(UIImage *image))completion
{
    [self configIPCWithFromVC:fromVC allowsEditing:allowsEditing scale:0 maxWidth:0 maxHeight:maxHeight completion:completion];
}

+ (void)imageModalVC:(UIViewController *)fromVC
       allowsEditing:(BOOL)allowsEditing
            maxWidth:(float)maxWidth
           maxHeight:(float)maxHeight
          completion:(void(^)(UIImage *image))completion
{
    [self configIPCWithFromVC:fromVC allowsEditing:allowsEditing scale:0 maxWidth:maxWidth maxHeight:maxHeight
                   completion:completion];
}

+ (void)configIPCWithFromVC:(UIViewController *)fromVC
              allowsEditing:(BOOL)allowsEditing
                      scale:(float)scale
                   maxWidth:(float)maxWidth
                  maxHeight:(float)maxHeight
                 completion:(void(^)(UIImage *image))completion
{
    [DDImageSelector sharedInstance].imageSelectorCompletion = completion;
    [DDImageSelector sharedInstance].fromVC = fromVC;
    [DDImageSelector sharedInstance].scale = scale;
    [DDImageSelector sharedInstance].maxWidth = maxWidth;
    [DDImageSelector sharedInstance].maxHeight = maxHeight;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = allowsEditing;
    picker.delegate = [DDImageSelector sharedInstance];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[DDImageSelector sharedInstance].fromVC presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    UIImage *result;
    
    if (self.scale > 0) {
        result = [image withScale:self.scale];
    }
    else if (self.maxWidth > 0 && self.maxHeight > 0) {
        result = [image scaleToSize:CGSizeMake(self.maxWidth, self.maxHeight)];
    }
    else if (self.maxWidth > 0) {
        result = [image scaleToWidth:self.maxWidth];
    }
    else if (self.maxHeight > 0) {
        result = [image scaleToWidth:self.maxHeight];
    }
    else {
        result = image;
    }
    
    [self.fromVC dismissViewControllerAnimated:YES completion:^{
        if (self.imageSelectorCompletion) {
            self.imageSelectorCompletion(result);
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
