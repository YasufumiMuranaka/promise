//
//  XMLParserRequestPromise.h
//  CL_SMART_0007
//
//  Created by Yasufumi Muranaka on 2019/02/16.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Promise.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMLParserRequestPromise : NSObject
+ (Promise *)start:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
