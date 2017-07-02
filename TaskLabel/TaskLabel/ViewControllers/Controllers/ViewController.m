//
//  ViewController.m
//  TaskLabel
//
//  Created by new on 30.06.17.
//  Copyright © 2017 Home. All rights reserved//
//

#import "ViewController.h"
#import "PickerLabelView.h"
#import "ColorPickerView.h"

typedef enum : NSUInteger {
    NoColor,
    BackgroundColor,
    TextColor,
} ColorType;


@interface ViewController () <UITextFieldDelegate, CAAnimationDelegate, ColorPickerViewDelegate>
@property ColorType colorType;

@property (nonatomic, strong) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIView *editColorTabView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editColorTabViewBottomConstraint;

@property (nonatomic, strong) PickerLabelView *pickerLabelView;
@property (nonatomic, strong) ColorPickerView *colorPickerView;
@property (weak, nonatomic) IBOutlet UIView *colorPickerBackgroundView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addnotification];
    [self configDefaultUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addnotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - UI methods
- (void)configDefaultUI {
    _pickerLabelView = [[PickerLabelView alloc] initWithParentView:self.actionView];
    [self.actionView addSubview:_pickerLabelView];
    
    [_txtField becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    __block CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    self.editColorTabViewBottomConstraint.constant = keyboardFrameBeginRect.size.height;
    [self.editColorTabView layoutIfNeeded];
}


#pragma mark - Action methods
- (IBAction)startButtonAction:(id)sender {
    [_pickerLabelView startCountingToValue:self.txtField.text];
}

- (IBAction)changeCollorAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    _colorType = (button.tag == 0) ? BackgroundColor : TextColor;
    _colorPickerView = [[ColorPickerView alloc] initWithFrame:_colorPickerBackgroundView.bounds];
    _colorPickerView.delegate = self;
    [_colorPickerBackgroundView addSubview:_colorPickerView];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 5 || returnKey;
    
    return YES;
}


#pragma mark - ColorPickerViewDelegate
- (void)pickerView:(ColorPickerView *)picker colorDidChange:(UIColor *)color {
    switch (_colorType) {
        case BackgroundColor:
            [_pickerLabelView setBackgroundColor:color];
            break;
        
        case TextColor:
            [_pickerLabelView setTextColor:color];
            break;
        
        default:
            break;
    }
}

- (void)pickerViewChangeEnded:(ColorPickerView *)picker {
    [picker removeFromSuperview];
}

@end
