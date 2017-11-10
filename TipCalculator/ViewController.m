//
//  ViewController.m
//  TipCalculator
//
//  Created by Daniel Grosman on 2017-11-10.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (nonatomic,strong) NSString *convertedPercentage;
@property (nonatomic) BOOL keyboardIsShown;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.billAmountTextField.delegate = self;
    [self.billAmountTextField becomeFirstResponder];
    
    self.sliderLabel.text = @"Tip: 0 %";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillHide:(NSNotification *) sender {
    CGRect viewFrame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view setFrame:viewFrame];
}

- (void)keyboardWillShow:(NSNotification *)sender {
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect viewFrame = CGRectMake(0, -keyboardSize.height, self.view.frame.size.width, self.view.frame.size.height);
    [self.view setFrame:viewFrame];
}

- (void) convertPercentage {
    float tipPercentage = self.tipSlider.value * 0.01;
    self.convertedPercentage = [NSString stringWithFormat:@"%f",tipPercentage];
}

- (IBAction)sliderChanged:(id)sender {
    int sliderValue;
    sliderValue = roundf(self.tipSlider.value);
    [self.tipSlider setValue:sliderValue animated:YES];
    self.sliderLabel.text = [NSString stringWithFormat:@"Tip: %g %%",self.tipSlider.value];
    [self calculateTip];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.billAmountTextField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self calculateTip];
}

- (void) calculateTip {
    NSDecimalNumber *billAmount = [NSDecimalNumber decimalNumberWithString:self.billAmountTextField.text];
    [self convertPercentage];
    NSDecimalNumber *tipAmount = [NSDecimalNumber decimalNumberWithString:self.convertedPercentage];
    NSDecimalNumber *result = [billAmount decimalNumberByMultiplyingBy:tipAmount];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.tipAmountLabel.text = [NSString stringWithFormat:@"The tip amount is: %@", [numberFormatter stringFromNumber:result]];
}



@end
