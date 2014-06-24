//
//  DDTextField.m
//  IndividuationLogin
//
//  Created by ccxdd on 13-12-24.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "DDTextField.h"

static NSNumber *superViewProperty;

@interface DDTextField () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    id confirmField;
}

@property (nonatomic, strong) UIBarButtonItem *previousBarButton;
@property (nonatomic, strong) UIBarButtonItem *nextBarButton;
@property (nonatomic, strong) UIToolbar       *toolbar;
@property (nonatomic, strong) NSMutableArray  *textFields;
@property (nonatomic, assign) NSInteger       textFieldsIndex;
//
@property (nonatomic, strong) UIPickerView    *pickerView;
@property (nonatomic, strong) UIDatePicker    *datePicker;
@property (nonatomic, strong) UIImageView     *activeImageView;

@end

@implementation DDTextField

- (void)awakeFromNib
{
    [self configDDTextField];
    self.required = YES;
    self.fieldType = DDTextField_TYPE_DEFAULT;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configDDTextField];
    }
    return self;
}

#pragma mark - configDDTextField

- (void)configDDTextField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:)
                                                 name:UITextFieldTextDidEndEditingNotification object:self];
    
    self.hitMessage = self.placeholder;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
    // set style
    [self.toolbar setBarStyle:UIBarStyleDefault];
    
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"上一个" style:UIBarButtonItemStyleBordered target:self action:@selector(previousButtonIsClicked:)];
    self.nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"下一个" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonIsClicked:)];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonIsClicked:)];
    
    NSArray *barButtonItems = @[self.previousBarButton, self.nextBarButton, flexBarButton, doneBarButton];
    
    self.toolbar.items = barButtonItems;
    
    _textFields = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
}

+ (instancetype)DDTextFieldWithFrame:(CGRect)frame
                           fieldType:(DDTextField_TYPE)fieldType
                            required:(BOOL)required
                          hitMessage:(NSString *)hitMessage
{
    DDTextField *ddf = [[DDTextField alloc] initWithFrame:frame];
    ddf.fieldType = fieldType;
    ddf.required = required;
    ddf.hitMessage = hitMessage;
    ddf.placeholder = hitMessage;
    ddf.borderStyle = UITextBorderStyleRoundedRect;
    ddf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    return ddf;
}

+ (instancetype)DDPickerFieldWithFrame:(CGRect)frame
                             fieldType:(DDTextField_TYPE)fieldType
                              required:(BOOL)required
                            hitMessage:(NSString *)hitMessage
                                  data:(NSArray *)data
                               keyName:(NSString *)keyName
                             valueName:(NSString *)valueName
                         selectedBlock:(void(^)(NSInteger index, id rowObject))selectedBlock
{
    DDTextField *ddf = [[DDTextField alloc] initWithFrame:frame];
    ddf.fieldType = fieldType;
    ddf.required = required;
    ddf.hitMessage = hitMessage;
    ddf.placeholder = hitMessage;
    ddf.borderStyle = UITextBorderStyleRoundedRect;
    ddf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    ddf.keyName = keyName;
    ddf.valueName = valueName;
    ddf.pickerData = data;
    
    return ddf;
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(NSNotification *)notification
{
    DDTextField *textField = (DDTextField*)[notification object];
    
    [self setInputAccessoryView:self.toolbar];
    self.activeImageView.hidden = NO;
    
    //调整坐标
    CGFloat y = 0;
    float keyboardHeight = 215;
    float space = kSCREEN_HEIGHT - keyboardHeight - textField.frame.size.height - 44;
    
    if ([[textField superview] isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollView = (UIScrollView *)[textField superview];
        float max_offset_y = scrollView.contentSize.height - scrollView.frame.size.height;
        CGPoint fieldPoint = [scrollView convertPoint:textField.frame.origin toView:nil];
        if (!superViewProperty) {
            superViewProperty = [NSNumber numberWithFloat:scrollView.contentSize.height];
        }
        
        if (fieldPoint.y > space)
        {
            y = fieldPoint.y - space + scrollView.contentOffset.y;
            if (y > max_offset_y) {
                [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.contentSize.height+(y-max_offset_y))];
            }
            [UIView animateWithDuration:0.5 animations:^{
                [scrollView setContentOffset:CGPointMake(0, y)];
            }];
        }
    } else if ([[textField superview] isKindOfClass:[UIView class]]) {
        
        UIView *superView = [textField superview];
        CGPoint fieldPoint = [superView convertPoint:textField.frame.origin toView:nil];
//        if (!superViewProperty) {
//            superViewProperty = [NSNumber numberWithFloat:superView.frame.origin.y];
//        }
        
        if (fieldPoint.y > space)
        {
            UIView *fullView = [self superFullScreenView:textField];
            if (!superViewProperty) {
                superViewProperty = [NSNumber numberWithFloat:fullView.frame.origin.y];
            }
            y = fieldPoint.y - space;
            [UIView animateWithDuration:0.5 animations:^{
                fullView.frame = CGRectMake(fullView.frame.origin.x,
                                            fullView.frame.origin.y - y - 10,
                                            fullView.frame.size.width,
                                            fullView.frame.size.height);
            }];
        }
    }
    
    if (![_textFields count] > 0) {
        __block NSInteger index = 0;
        [[[textField superview] subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[DDTextField class]]) {
                [obj setTextFieldsIndex:index++];
                [_textFields addObject:obj];
            }
        }];
        
        //DLog(@"_textFields = %@", _textFields);
    }
    
    [self setBarButtonNeedsDisplayAtTag:textField.textFieldsIndex];
    
}

- (void)textFieldDidEndEditing:(NSNotification *)notification
{
    DDTextField *textField = (DDTextField*)[notification object];
    BOOL isValid = [self isValid];
    
    self.activeImageView.hidden = YES;
    [textField resignFirstResponder];
    
    if (self.didEndEditingBlock) {
        self.didEndEditingBlock(self, isValid);
    }
    
}

- (void)setConfirmField:(id)field
{
    confirmField = field;
    self.keyboardType = [confirmField keyboardType];
    [self setFieldType:DDTextField_TYPE_CONFIRM];
}

- (void)nextButtonIsClicked:(id)sender
{
    NSInteger textFieldsIndex = self.textFieldsIndex;
    DDTextField *textField =  [self.textFields objectAtIndex:++textFieldsIndex];
    
    while (!textField.isEnabled && textFieldsIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:++textFieldsIndex];
    
    [self becomeActive:textField];
}

- (void)previousButtonIsClicked:(id)sender
{
    NSInteger textFieldsIndex = self.textFieldsIndex;
    DDTextField *textField =  [self.textFields objectAtIndex:--textFieldsIndex];
    
    while (!textField.isEnabled && textFieldsIndex < [self.textFields count])
        textField = [self.textFields objectAtIndex:--textFieldsIndex];
    
    [self becomeActive:textField];
}

- (void)becomeActive:(UITextField*)textField
{
    [self resignFirstResponder];
    [textField becomeFirstResponder];
}

- (void)setBarButtonNeedsDisplayAtTag:(NSInteger)textFieldsIndex
{
    BOOL previousBarButtonEnabled = NO;
    BOOL nexBarButtonEnabled = NO;
    
    for (int index = 0; index < [self.textFields count]; index++) {
        
        UITextField *textField = [self.textFields objectAtIndex:index];
        
        if (index < textFieldsIndex)
            previousBarButtonEnabled |= textField.isEnabled;
        else if (index > textFieldsIndex)
            nexBarButtonEnabled |= textField.isEnabled;
    }
    
    self.previousBarButton.enabled = previousBarButtonEnabled;
    self.nextBarButton.enabled = nexBarButtonEnabled;
}

- (void)doneButtonIsClicked:(id)sender
{
    if (superViewProperty) {
        if ([[self superview] isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)[self superview];
            [UIView animateWithDuration:0.5 animations:^{
                scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, [superViewProperty floatValue]);
                superViewProperty = nil;
            }];
        } else if ([[self superview] isKindOfClass:[UIView class]]) {
            UIView *superView = [self superFullScreenView:self];
            [UIView animateWithDuration:0.5 animations:^{
                superView.frame = CGRectMake(superView.frame.origin.x,
                                             [superViewProperty floatValue],
                                             superView.frame.size.width,
                                             superView.frame.size.height);
                superViewProperty = nil;
            }];
        }
    }
    
    if (self.fieldType == DDTextField_TYPE_PICKER) {
        [self pickerView:_pickerView didSelectRow:[_pickerView selectedRowInComponent:0] inComponent:0];
    } else if (self.fieldType == DDTextField_TYPE_DATE) {
        self.text = [Utility dateToString:[sender date]];
    }
    
    [self resignFirstResponder];
    
}

#pragma mark - setFieldType

- (void)setFieldType:(DDTextField_TYPE)fieldType
{
    _fieldType = fieldType;
    
    switch (fieldType) {
            
        case DDTextField_TYPE_MOBILE:
        {
            self.keyboardType = UIKeyboardTypePhonePad;
        }
            break;
            
        case DDTextField_TYPE_NUM:
        {
            self.keyboardType = UIKeyboardTypeDecimalPad;
        }
            break;
            
        case DDTextField_TYPE_EMAIL:
        {
            self.keyboardType = UIKeyboardTypeEmailAddress;
        }
            break;
            
        case DDTextField_TYPE_PWD:
        {
            self.secureTextEntry = YES;
        }
            break;
            
        case DDTextField_TYPE_PWD_NUM:
        {
            self.secureTextEntry = YES;
            self.keyboardType = UIKeyboardTypeDecimalPad;
        }
            break;
            
        case DDTextField_TYPE_CONFIRM:
        {
            if (confirmField) {
                self.secureTextEntry = [confirmField isSecureTextEntry];
                self.keyboardType = [confirmField keyboardType];
            }
        }
            break;
            
        case DDTextField_TYPE_DATE:
        {
            if (!_datePicker) {
                _datePicker  = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
                _datePicker.datePickerMode = UIDatePickerModeDate;
                [_datePicker handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
                    self.text = [Utility dateToString:[sender date]];
                }];
                self.inputView = _pickerView;
            }
        }
            break;
            
        case DDTextField_TYPE_PICKER:
        {
            if (!_pickerView) {
                _pickerView  = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
                _pickerView.backgroundColor = [UIColor whiteColor];
                _pickerView.showsSelectionIndicator = YES;
                _pickerView.delegate = self;
                _pickerView.dataSource = self;
                self.inputView = _pickerView;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - valid

- (BOOL)isValid
{
    BOOL result = NO;
    
    switch (self.fieldType) {
            
        case DDTextField_TYPE_DEFAULT:
        case DDTextField_TYPE_PWD:
        {
            result = self.text.length > 0;
        }
            break;
            
        case DDTextField_TYPE_CONFIRM:
        {
            if ([self.text isEqualToString:[confirmField text]] && self.text.length > 0) {
                result = YES;
            }
        }
            break;
            
        case DDTextField_TYPE_DATE:
        {
            result = self.text.length > 0;
        }
            break;
            
        case DDTextField_TYPE_MOBILE:
        {
            if ([Utility validateUserPhone:self.text]) {
                result = YES;
            }
        }
            break;
            
        case DDTextField_TYPE_NUM:
        case DDTextField_TYPE_PWD_NUM:
        {
            if ([Utility isNumberic:self.text]) {
                result = YES;
            }
        }
            break;
            
        case DDTextField_TYPE_EMAIL:
        {
            if ([Utility validateEmail:self.text]) {
                result = YES;
            }
        }
            break;
        case DDTextField_TYPE_PICKER:
        {
            result = self.text.length > 0;
        }
            break;
            
        default:
            break;
    }
    
    if (!result && self.required) {
        
        self.layer.backgroundColor = kUIColorRGBA(180, 0, 0, 0.7).CGColor;
        
        if (self.hitMessage) {
            [BMWaitVC showMessage:self.hitMessage];
        }
        return NO;
    } else {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    return YES;
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([_pickerData[row] isKindOfClass:[NSDictionary class]])
    {
        if (self.keyName) {
            return  _pickerData[row][self.keyName];
        } else {
            DLog(@"%@", @"key is none!");
            return @"";
        }
        
    } else {
        
        return _pickerData[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_pickerData) {
        if ([_pickerData[row] isKindOfClass:[NSDictionary class]]) {
            self.text = [NSString stringWithFormat:@"%@", _pickerData[row][self.keyName]];
            self.textValue = [NSString stringWithFormat:@"%@", _pickerData[row][self.valueName]];
        } else {
            self.text = [NSString stringWithFormat:@"%@", _pickerData[row]];
        }
        
        if (self.pickerSelectedBlock) {
            self.pickerSelectedBlock(row, _pickerData[row]);
        }
    }
}

- (UIView *)superFullScreenView:(UIView *)subView
{
    UIView *superView = [subView superview];
    if (CGRectGetHeight(superView.frame) == kSCREEN_HEIGHT) {
        return superView;
    } else {
        superView = [self superFullScreenView:superView];
    }
    
    return superView;
}

- (void)setBackground:(UIImage *)background
{
    [super setBackground:background];
    self.borderStyle = UITextBorderStyleNone;
}

- (void)setActiveBackgroundImage:(UIImage *)activeBackgroundImage
{
    _activeBackgroundImage = activeBackgroundImage;
    
    if (!_activeImageView) {
        _activeImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _activeImageView.image = _activeBackgroundImage;
        _activeImageView.hidden = YES;
        [self addSubview:_activeImageView];
    } else {
        _activeImageView.image = _activeBackgroundImage;
    }
}

#pragma mark -

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 5);
}

//- (void)layoutSublayersOfLayer:(CALayer *)layer
//{
//    [super layoutSublayersOfLayer:layer];
//
//    [layer setBorderWidth: 0.8];
//    [layer setBorderColor: [UIColor colorWithWhite:0.1 alpha:0.2].CGColor];
//
//    [layer setCornerRadius:3.0];
//    [layer setShadowOpacity:1.0];
//    [layer setShadowColor:[UIColor redColor].CGColor];
//    [layer setShadowOffset:CGSizeMake(1.0, 1.0)];
//}

//- (void)drawPlaceholderInRect:(CGRect)rect {
//    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
//    [self.placeholder drawInRect:CGRectInset(rect, 5, 5) withAttributes:attributes];
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
