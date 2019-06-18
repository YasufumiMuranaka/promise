//
//  ChooseColorPromise.m
//
//  Created by Yasufumi Muranaka on 2019/05/15.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import "ChooseColorPromise.h"
#import "ChooseColorViewController.h"

@interface ChooseColorPromise ()<UIPopoverPresentationControllerDelegate, ChooseColorViewControllerDelegate>
@property (assign, nonatomic) BOOL isResolve;
@end

@implementation ChooseColorPromise

#pragma mark -  Method

- (instancetype)initWithPresent:(UIViewController *)parent
                     sourceView:(UIView *)sourceView
                      direction:(UIPopoverArrowDirection)direction
                          color:(UIColor *)color
                         titile:(NSString *)title {
    self = [self init];
    if (self) {
        __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                ChooseColorViewController *chooseColorViewController = [[UIStoryboard storyboardWithName:@"ChooseColor" bundle:nil] instantiateInitialViewController];
                chooseColorViewController.delegate = weakSelf;
                chooseColorViewController.modalPresentationStyle = UIModalPresentationPopover;
                chooseColorViewController.preferredContentSize = CGSizeMake(290.0, 185.0);
                UIPopoverPresentationController *presentationController = chooseColorViewController.popoverPresentationController;
                presentationController.delegate = weakSelf;
                presentationController.permittedArrowDirections = direction;
                presentationController.sourceView = sourceView;
                presentationController.sourceRect = sourceView.bounds;
                [parent presentViewController:chooseColorViewController animated:YES completion:^{
                    const CGFloat *components = CGColorGetComponents(color.CGColor);
                    chooseColorViewController.rSlider.value = components[0];
                    chooseColorViewController.gSlider.value = components[1];
                    chooseColorViewController.bSlider.value = components[2];
                    chooseColorViewController.titleLabel.text = title;
                    [chooseColorViewController refreshView];
                }];
            });
    }
    return self;
}

- (void)okButtonTouchUpInside:(ChooseColorViewController*)chooseColorViewController {
    self.isResolve = YES;
    [self resolve:[UIColor colorWithRed:chooseColorViewController.rSlider.value
                                  green:chooseColorViewController.gSlider.value
                                   blue:chooseColorViewController.bSlider.value
                                  alpha:1.0]];
    [chooseColorViewController dismissViewControllerAnimated:YES completion:nil];
    chooseColorViewController = nil;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    if (!self.isResolve) {
        [self reject:[NSError errorWithDomain:@"canceled" code:-1 userInfo:nil]];
    }
}

@end
