//
//  ViewController.m
//  Promise
//
//  Created by Yasufumi Muranaka on 2019/06/18.
//  Copyright © 2019 Yasufumi Muranaka. All rights reserved.
//

#import "ViewController.h"
#import "ChooseColorPromise.h"

@interface ViewController ()
@property (strong, nonatomic) Promise *promise;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *barColor;
@property (strong, nonatomic) UIColor *titleColor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = self.backgroundColor;
}

- (IBAction)changeBackgroundAndCorporateColor:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIColor *backgroundColorNow = self.backgroundColor;
    UIColor *barColorNow = self.barColor;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.promise = [[ChooseColorPromise alloc] initWithPresent:weakSelf
                                                            sourceView:weakSelf.changeButton
                                                             direction:UIPopoverArrowDirectionDown
                                                                 color:weakSelf.backgroundColor
                                                                titile:@"Background"];
        weakSelf.promise.then((PromiseResolveBlock)^(UIColor *result) {
            weakSelf.backgroundColor = result;
            weakSelf.promise = [[ChooseColorPromise alloc] initWithPresent:weakSelf
                                                                sourceView:weakSelf.navigationController.navigationBar
                                                                 direction:UIPopoverArrowDirectionUp
                                                                     color:weakSelf.barColor
                                                                    titile:@"Bar"];
            return weakSelf.promise;
        }).then((PromiseResolveBlock)^(UIColor *result) {
            weakSelf.barColor = result;
            weakSelf.promise = [[ChooseColorPromise alloc] initWithPresent:weakSelf
                                                                sourceView:weakSelf.navigationController.navigationBar
                                                                 direction:UIPopoverArrowDirectionUp
                                                                     color:weakSelf.titleColor
                                                                    titile:@"Title"];
            return weakSelf.promise;
        }).then((PromiseResolveBlock)^(UIColor *result) {
            weakSelf.titleColor = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UINavigationBar appearance] setBarTintColor:weakSelf.barColor];
                [[UINavigationBar appearance] setTintColor:weakSelf.titleColor];
                [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:weakSelf.titleColor}];
                [weakSelf effectColors];
            });
            return weakSelf.promise;
        }).catch((PromiseRejectBlock)^(NSError *error) {
            self.backgroundColor = backgroundColorNow;
            self.barColor = barColorNow;
        })/*.finally((PromiseVoidBlock)^(void) { // finallyを使う場合は活かす
           NSLog(@"finally:%s", __PRETTY_FUNCTION__);
           })*/;
    });
}

- (void)effectColors {
    [UIApplication sharedApplication].keyWindow.rootViewController = nil;
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
}

- (void)setBackgroundColor:(UIColor *)color {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:color requiringSecureCoding:NO error:nil]  forKey:@"backgroundColor"];
    
}

- (UIColor *)backgroundColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"backgroundColor"];
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:data error:nil];
}

- (void)setBarColor:(UIColor *)color {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:color requiringSecureCoding:NO error:nil]  forKey:@"barColor"];
    
}

- (UIColor *)barColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"barColor"];
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:data error:nil];
}

- (void)setTitleColor:(UIColor *)color {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:color requiringSecureCoding:NO error:nil]  forKey:@"titleColor"];
}

- (UIColor *)titleColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"titleColor"];
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:data error:nil];
}

@end
