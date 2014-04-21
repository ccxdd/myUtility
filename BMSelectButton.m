//
//  BMSelectButton.m
//  WanYueHui
//
//  Created by ccxdd on 13-5-26.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "BMSelectButton.h"

#define dBG_NAME            @"downArrow"
#define dPicker_Height      (IOS7_OR_LATER ? 216 : 216)
#define dActionSheet_Height (dPicker_Height+40)

@interface BMSelectButton ()

@property (copy) SelectCompleteBlock selectCompleteBlock;

@end

@implementation BMSelectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectBtn];
        
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width-17-5, frame.size.height)];
        [titleLab setFont:[UIFont systemFontOfSize:16]];
        [titleLab setMinimumFontSize:9];
        titleLab.adjustsFontSizeToFitWidth = YES;
        titleLab.contentMode = UIViewContentModeScaleToFill;
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setTextColor:[UIColor whiteColor]];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLab];
        titleValue = @"";
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"" style: UIBarButtonItemStylePlain target: nil action: nil];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStyleDone target: self action: @selector(done)];
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleBordered target: self action: @selector(doCancel)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, titleButton,fixedButton, rightButton, nil];
        [toolBar setItems: array];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title data:(NSArray *)data mode:(SelectBtnMode)mode selectCompleteBlock:(SelectCompleteBlock)selectCompleteBlock
{
    self = [self initWithFrame:frame];
    titleLab.text = title;
    dataArr = [NSMutableArray arrayWithArray:data];
    self.selectBtnMode = mode;
    self.selectCompleteBlock = selectCompleteBlock;
    
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title data:(NSArray *)data mode:(SelectBtnMode)mode
            keyName:(NSString *)keyName valueName:(NSString *)valueName selectCompleteBlock:(SelectCompleteBlock)selectCompleteBlock
{
    self = [self initWithFrame:frame];
    titleLab.text = title;
    dataArr = [NSMutableArray arrayWithArray:data];
    self.keyName = keyName;
    self.valueName = valueName;
    self.selectBtnMode = mode;
    self.selectCompleteBlock = selectCompleteBlock;
    
    return self;
}

- (void)setSelectBtnMode:(SelectBtnMode)selectBtnMode
{
    _selectBtnMode = selectBtnMode;
    
    switch (selectBtnMode) {
        case SelectPickerMode:
        {
            if (!pickerView) {
                pickerView  = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, dPicker_Height)];
                pickerView.backgroundColor = [UIColor whiteColor];
                pickerView.showsSelectionIndicator = YES;
                pickerView.delegate = self;
                pickerView.dataSource = self;
                [actionSheet addSubview:pickerView];
                [actionSheet addSubview:toolBar];
                [actionSheet setTitle:@" "];
            } else {
                [actionSheet bringSubviewToFront:pickerView];
            }
            
        }
            break;
            
        case SelectDatePickerDateMode:
        {
            if (!datePicker) {
                datePicker  = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, dPicker_Height)];
                datePicker.datePickerMode = UIDatePickerModeDate;
                datePicker.backgroundColor = [UIColor whiteColor];
                [actionSheet addSubview:datePicker];
                [actionSheet addSubview:toolBar];
                [actionSheet setTitle:@" "];
            } else {
                [actionSheet bringSubviewToFront:datePicker];
            }
        }
            break;
            
        case SelectDatePickerDateTimeMode:
        {
            if (!datePicker) {
                datePicker  = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, dPicker_Height)];
                datePicker.datePickerMode = UIDatePickerModeTime;
                datePicker.backgroundColor = [UIColor whiteColor];
                [actionSheet addSubview:datePicker];
                [actionSheet addSubview:toolBar];
                [actionSheet setTitle:@" "];
            } else {
                [actionSheet bringSubviewToFront:datePicker];
            }
        }
            break;
            
        case SelectActionSheetMode:
        {
            for (int i = 0; i < [dataArr count]; i++) {
                if ([dataArr[i] isKindOfClass:[NSDictionary class]])
                {
                    if (self.keyName) {
                        [actionSheet addButtonWithTitle:dataArr[i][self.keyName]];
                    } else {
                        DLog(@"SelectActionSheetMode:key is none!");
                    }
                } else {
                    [actionSheet addButtonWithTitle:dataArr[i]];
                }
            }
            
            [actionSheet addButtonWithTitle:@"取消"];
            [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
            [actionSheet setDestructiveButtonIndex:actionSheet.numberOfButtons-1];
            
        }
            break;
            
        default:
            break;
    }
    
    
}

- (NSString *)title
{
    return titleLab.text;
}

- (void)setTitle:(NSString *)str
{
    titleLab.text = str;
}

- (NSString *)titleValue
{
    return titleValue;
}

- (void)setTitleValue:(NSString *)str
{
    titleValue = str;
}

- (void)textAlignment:(NSTextAlignment)textAlignment
{
    [titleLab setTextAlignment:textAlignment];
}

- (void)selectAction:(id)sender
{
    [actionSheet showInView:self];
    
    if (self.selectBtnMode != SelectActionSheetMode) {
        [UIView animateWithDuration:.3 animations:^{
            actionSheet.frame = CGRectMake(0, kSCREEN_HEIGHT-dActionSheet_Height, 320, dActionSheet_Height);
        }];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didSelectRow:(NSInteger)row valueAlias:(id)alias
{
    selectIndex = row;
    
    if ([dataArr[selectIndex] isKindOfClass:[NSDictionary class]]) {
        titleLab.text = dataArr[selectIndex][self.keyName];
        titleValue = dataArr[selectIndex][self.valueName];
    } else {
        titleLab.text = alias;
        titleValue = [NSString stringWithFormat:@"%ld", (long)row];
    }
    
    if (self.selectCompleteBlock) {
        self.selectCompleteBlock(row, dataArr[row]);
    }
}

- (NSInteger)selectIndex {
    return selectIndex;
}

- (void)setDatas:(NSArray *)datas
{
    dataArr = [NSMutableArray arrayWithArray:datas];
}

#pragma mark ------------UIActionSheetDelegate---------------

- (void)actionSheet:(UIActionSheet *)actionSht clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < actionSht.numberOfButtons-1) {
        [self actionSheet:actionSht didSelectRow:buttonIndex valueAlias:dataArr[buttonIndex]];
    }
}

#pragma mark - DatePickerActionSheetDelegate

- (NSString *)selectedDate:(NSDate *)date
{
    NSString *formatStr;
    
    if (self.selectBtnMode == SelectDatePickerDateMode) {
        formatStr = @"yyyy-MM-dd";
    } else if (self.selectBtnMode == SelectDatePickerDateTimeMode) {
        formatStr = @"HH:mm";
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:formatStr];
    
    return [df stringFromDate:date];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [selectBtn setImage:image forState:UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled
{
    [selectBtn setEnabled:enabled];
    [titleLab setEnabled:enabled];
}

- (void)setTextColor:(UIColor *)color
{
    titleLab.textColor = color;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataArr count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([dataArr[row] isKindOfClass:[NSDictionary class]])
    {
        if (self.keyName) {
            return  dataArr[row][self.keyName];
        } else {
            DLog(@"%@", @"key is none!");
            return @"";
        }
        
    } else {
        
        return dataArr[row];
    }
}

- (void)done
{
    if (self.selectBtnMode == SelectDatePickerDateMode || self.selectBtnMode == SelectDatePickerDateTimeMode) {
        
        [self actionSheet:actionSheet didSelectRow:0 valueAlias:[self selectedDate:datePicker.date]];
        
    } else {
        
        NSInteger row = [pickerView selectedRowInComponent:0];
        NSString *categoryName = [dataArr[row] isKindOfClass:[NSDictionary class]] ? dataArr[row][self.keyName] : dataArr[row];
        [self actionSheet:actionSheet didSelectRow:row valueAlias:categoryName];
    }

    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)doCancel
{
	[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
