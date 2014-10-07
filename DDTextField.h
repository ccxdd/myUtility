//
//  DDTextField.h
//  IndividuationLogin
//
//  Created by ccxdd on 13-12-24.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,DDTextField_TYPE) {
    DDTextField_TYPE_DEFAULT,
    DDTextField_TYPE_MOBILE,
    DDTextField_TYPE_NUM,
    DDTextField_TYPE_DATE,
    DDTextField_TYPE_CONFIRM,
    DDTextField_TYPE_EMAIL,
    DDTextField_TYPE_PWD,
    DDTextField_TYPE_PWD_NUM,
    DDTextField_TYPE_PICKER,
};

@interface DDTextField : UITextField

@property (nonatomic, copy            ) NSString         *hitMessage;   //提示信息
@property (nonatomic, assign, readonly) BOOL             isValid;       //是否有效
@property (nonatomic, assign          ) BOOL             required;      //是否必填
@property (nonatomic, assign          ) DDTextField_TYPE fieldType;     //输入框类型
@property (nonatomic, copy            ) NSString         *textValue;
@property (nonatomic, strong          ) UIImage          *activeBackgroundImage;
@property (nonatomic, assign)           CGFloat          keyboardOffset;
@property (nonatomic, copy) void(^didEndEditingBlock)(DDTextField *, BOOL);
//
@property (nonatomic, copy  ) NSString *keyName;
@property (nonatomic, copy  ) NSString *valueName;
@property (nonatomic, strong) NSArray  *pickerData;
@property (nonatomic, copy) void(^pickerSelectedBlock)(NSInteger index, id rowObject);

+ (instancetype)DDTextFieldWithFrame:(CGRect)frame
                           fieldType:(DDTextField_TYPE)fieldType
                            required:(BOOL)required
                          hitMessage:(NSString *)hitMessage;

+ (instancetype)DDPickerFieldWithFrame:(CGRect)frame
                             fieldType:(DDTextField_TYPE)fieldType
                              required:(BOOL)required
                            hitMessage:(NSString *)hitMessage
                                  data:(NSArray *)data
                               keyName:(NSString *)keyName
                             valueName:(NSString *)valueName
                         selectedBlock:(void(^)(NSInteger index, id rowObject))selectedBlock;

- (void)setConfirmField:(id)field;
- (void)doneButtonIsClicked:(id)sender;

@end
