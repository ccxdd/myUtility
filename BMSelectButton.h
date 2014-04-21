//
//  BMSelectButton.h
//  WanYueHui
//
//  Created by ccxdd on 13-5-26.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCompleteBlock)(NSInteger index, id rowObject);

typedef enum {
    SelectPickerMode,
    SelectDatePickerDateMode,
    SelectDatePickerDateTimeMode,
    SelectActionSheetMode,
} SelectBtnMode;

@interface BMSelectButton : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>
{
    UIActionSheet *actionSheet;
    UIPickerView *pickerView;
    UIDatePicker *datePicker;
    UIToolbar *toolBar;
    UIButton *selectBtn;
    UILabel *titleLab;
    NSMutableArray *dataArr;
    NSString *titleValue;   //数据对象为NSDictionary时返回字典中的指定key值
    NSInteger selectIndex;
}

@property (nonatomic, copy  ) NSString      *keyName;
@property (nonatomic, copy  ) NSString      *valueName;
@property (nonatomic, assign) SelectBtnMode selectBtnMode;

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
               data:(NSArray *)data
               mode:(SelectBtnMode)mode
selectCompleteBlock:(SelectCompleteBlock)selectCompleteBlock;

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
               data:(NSArray *)data
               mode:(SelectBtnMode)mode
            keyName:(NSString *)keyName
          valueName:(NSString *)valueName
selectCompleteBlock:(SelectCompleteBlock)selectCompleteBlock;

- (void)textAlignment:(NSTextAlignment)textAlignment;

- (NSString *)title;
- (void)setTitle:(NSString *)str;

- (void)setTextColor:(UIColor *)color;

- (NSString *)titleValue;
- (void)setTitleValue:(NSString *)str;

//返回data选中的index
- (NSInteger)selectIndex;

//设置数据源
- (void)setDatas:(NSArray *)datas;

//设置背景图
- (void)setBackgroundImage:(UIImage *)image;

- (void)setEnabled:(BOOL)enabled;

@end
