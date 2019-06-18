//
//  XMLParserRequestPromise.m
//
//  Created by Yasufumi Muranaka on 2019/02/16.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import "XMLParserRequestPromise.h"
#import "XMLReader.h"

@implementation XMLParserRequestPromise

+ (Promise *)start:(NSData *)data {
    return [[Promise alloc] initWithHandler:^(Promise * _Nonnull promise) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *utf8str = [[NSString alloc] initWithData:data encoding:NSShiftJISStringEncoding];
            NSData *newData = [NSMutableData dataWithData:[utf8str dataUsingEncoding:NSUTF8StringEncoding]];
#if DEBUG
            NSLog(@"%@", [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding]);
#endif
            NSError *error = nil;
            NSDictionary *result = [XMLReader dictionaryForXMLData:newData options:0 error:&error];
            if (error) {
                [promise reject:[NSError errorWithDomain:@"Parser" code:error.code userInfo:nil]];
            } else {
                NSString *status = result[@"response"][@"status"][@"code"];
                if ([status isEqualToString:@"0"]) {
                    [promise resolve:result[@"response"][@"body"]];
                } else {
                    [promise reject:[NSError errorWithDomain:@"Parser" code:[status integerValue] userInfo:nil]];
                }
            }
        });
    }];
}

@end
