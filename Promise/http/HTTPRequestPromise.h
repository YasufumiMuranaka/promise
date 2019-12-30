//
//  RequestWithPromise.h
//  CL_SMART_0007
//
//  Created by Yasufumi Muranaka on 2019/02/15.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import "Promise.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPRequestPromise : NSObject

+ (Promise *)getURL:(NSURL *)url;
+ (Promise *)postURL:(NSURL *)url postParameters:(NSArray *)postParameters;

@end

NS_ASSUME_NONNULL_END
