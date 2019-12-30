//
//  ChooseColorViewController.h
//
//  Created by Yasufumi Muranaka on 2019/02/04.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChooseColorViewController;

@protocol ChooseColorViewControllerDelegate <NSObject>

- (void)okButtonTouchUpInside:(ChooseColorViewController*)chooseColorViewController;

@end

@interface ChooseColorViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *rSlider;
@property (weak, nonatomic) IBOutlet UISlider *gSlider;
@property (weak, nonatomic) IBOutlet UISlider *bSlider;
@property (weak, nonatomic) IBOutlet UITextField *rField;
@property (weak, nonatomic) IBOutlet UITextField *gField;
@property (weak, nonatomic) IBOutlet UITextField *bField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *traitSegmented;
@property (assign, nonatomic) id<ChooseColorViewControllerDelegate> delegate;

- (void)refreshView;

@end

NS_ASSUME_NONNULL_END
