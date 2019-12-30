//
//  ChooseColorPromise.h
//
//  Created by Yasufumi Muranaka on 2019/05/15.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promise.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseColorPromise : Promise

- (instancetype)initWithPresent:(UIViewController *)parent
                     sourceView:(UIView *)sourceView
                      direction:(UIPopoverArrowDirection)direction
                          color:(UIColor *)color
                         titile:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
