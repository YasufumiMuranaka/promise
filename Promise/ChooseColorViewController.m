//
//  CLChooseColorViewController.m
//
//  Created by Yasufumi Muranaka on 2019/02/04.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import "ChooseColorViewController.h"

typedef NS_ENUM(NSInteger, CLChooseColorViewTrait) {
    CLChooseColorViewTraitDec = 0,
    CLChooseColorViewTraitHex
};

@interface ChooseColorViewController ()

@property (assign, nonatomic) CLChooseColorViewTrait chooseColorViewTrait;

@end

@implementation ChooseColorViewController

- (void)refreshView {
    [self rSliderValueChanged:nil];
    [self gSliderValueChanged:nil];
    [self bSliderValueChanged:nil];
}

- (IBAction)rSliderValueChanged:(id)sender {
//    NSLog(@"slide %f", self.rSlider.value);
    self.popoverPresentationController.backgroundColor = [UIColor colorWithRed:self.rSlider.value
                                                                         green:self.gSlider.value
                                                                          blue:self.bSlider.value
                                                                         alpha:1.0];
    self.view.backgroundColor = [UIColor  colorWithRed:self.rSlider.value
                                                 green:self.gSlider.value
                                                  blue:self.bSlider.value
                                                 alpha:1.0];
    NSInteger i = (NSInteger)round(self.rSlider.value * 255);
    self.rField.text =  [NSString stringWithFormat:self.traitSegmented.selectedSegmentIndex == CLChooseColorViewTraitDec ? @"%ld": @"%lX", (long)i];
}

- (IBAction)gSliderValueChanged:(id)sender {
//    NSLog(@"slide %f", self.gSlider.value);
    self.popoverPresentationController.backgroundColor = [UIColor colorWithRed:self.rSlider.value
                                                                         green:self.gSlider.value
                                                                          blue:self.bSlider.value
                                                                         alpha:1.0];
    self.view.backgroundColor = [UIColor  colorWithRed:self.rSlider.value
                                                 green:self.gSlider.value
                                                  blue:self.bSlider.value
                                                 alpha:1.0];
    NSInteger i = (NSInteger)round(self.gSlider.value * 255);
    self.gField.text =  [NSString stringWithFormat:self.traitSegmented.selectedSegmentIndex == CLChooseColorViewTraitDec ? @"%ld": @"%lX", (long)i];
}

- (IBAction)bSliderValueChanged:(id)sender {
//    NSLog(@"slide %f", self.bSlider.value);
    self.popoverPresentationController.backgroundColor = [UIColor colorWithRed:self.rSlider.value
                                                                         green:self.gSlider.value
                                                                          blue:self.bSlider.value
                                                                         alpha:1.0];
    self.view.backgroundColor = [UIColor  colorWithRed:self.rSlider.value
                                                 green:self.gSlider.value
                                                  blue:self.bSlider.value
                                                 alpha:1.0];
    NSInteger i = (NSInteger)round(self.bSlider.value * 255);
    self.bField.text =  [NSString stringWithFormat:self.traitSegmented.selectedSegmentIndex == CLChooseColorViewTraitDec ? @"%ld": @"%lX", (long)i];
}

- (IBAction)okButtonTouchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(okButtonTouchUpInside:)]) {
        [self.delegate okButtonTouchUpInside:self];
    }
}

- (IBAction)cancelButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)traitSegmentedValueChanged:(UISegmentedControl *)traitSegmented {
    [self rSliderValueChanged:nil];
    [self gSliderValueChanged:nil];
    [self bSliderValueChanged:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    CLChooseColorViewTrait trait = self.traitSegmented.selectedSegmentIndex == 0 ? CLChooseColorViewTraitDec: CLChooseColorViewTraitHex;
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length == 0) {
        newText = @"0";
    } if (newText.length > (trait == CLChooseColorViewTraitDec ? 3: 2)) {
        return NO;
    } else if (trait == CLChooseColorViewTraitDec && newText.intValue > 255) {
        return NO;
    }
    NSString* regexpPattern = trait == CLChooseColorViewTraitDec ? @"[0-9]": @"[0-9a-fA-F]";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexpPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:newText options:0 range:NSMakeRange(0, newText.length)];
    if (matches.count != newText.length) {
        return NO;
    }
    UISlider *slider = textField == self.rField ? self.rSlider: textField == self.gField ? self.gSlider: self.bSlider;
    unsigned int value = 0;
    if (trait == CLChooseColorViewTraitDec) {
        value = newText.intValue;
    } else {
        [[NSScanner scannerWithString:newText] scanHexInt:&value];
    }
    slider.value = value / 255.0;
    self.view.backgroundColor = [UIColor colorWithRed:self.rSlider.value
                                                green:self.gSlider.value
                                                 blue:self.bSlider.value
                                                alpha:1.0];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
