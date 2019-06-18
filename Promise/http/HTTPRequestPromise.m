//
//  HTTPRequestWithPromise.m
//
//  Created by Yasufumi Muranaka on 2019/02/15.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import "HTTPRequestPromise.h"
//#import "Reachability.h"

@interface HTTPRequestPromise ()
@end

@implementation HTTPRequestPromise

#pragma mark - Server Connect Methods

+ (Promise *)getURL:(NSURL *)url {
    return [[Promise alloc] initWithHandler:^(Promise * _Nonnull promise) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([HTTPRequestPromise isNetworkConnectEnable] == NO) {
                [promise reject:[NSError errorWithDomain:@"isNetworkConnectEnable" code:0 userInfo:nil]];
            }
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            [urlRequest setHTTPMethod:@"GET"];
//        if ([UIApplication sharedApplication].networkActivityIndicatorVisible == NO) {
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        }
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            sessionConfiguration.timeoutIntervalForRequest = 30;
            sessionConfiguration.timeoutIntervalForResource = 60;
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
#ifdef DEBUG
            NSLog(@"Request:%@", urlRequest);
#endif
            NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        [session finishTasksAndInvalidate];
//                                                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                        if (error) {
                                                            if (error.code == NSURLErrorTimedOut) {
                                                                [promise reject:[NSError errorWithDomain:@"NSURLError" code:error.code userInfo:nil]];
                                                            } else {
                                                                NSInteger httpStatus = [(NSHTTPURLResponse *)response statusCode];
                                                                [promise reject:[NSError errorWithDomain:@"NSURLError" code:httpStatus userInfo:nil]];
                                                            }
                                                        } else {
                                                            [promise resolve:data];
                                                        }
                                                    }];
            [task resume];
        });
    }];
}

+ (Promise *)postURL:(NSURL *)url postParameters:(NSArray *)postParameters {
    return [[Promise alloc] initWithHandler:^(Promise * _Nonnull promise) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([HTTPRequestPromise isNetworkConnectEnable] == NO) {
                [promise reject:[NSError errorWithDomain:@"isNetworkConnectEnable" code:0 userInfo:nil]];
                return;
            }
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            [urlRequest setHTTPMethod:@"POST"];
            NSString *utf8_post_str = [NSString stringWithString:[postParameters componentsJoinedByString:@"&"]];
            [urlRequest setHTTPBody:[utf8_post_str dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            sessionConfiguration.timeoutIntervalForRequest = 30;
            sessionConfiguration.timeoutIntervalForResource = 60;
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
#ifdef DEBUG
            NSLog(@"Request:%@", urlRequest);
#endif
            NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        [session finishTasksAndInvalidate];
                                                        if (error) {
                                                            if (error.code == NSURLErrorTimedOut) {
                                                                [promise reject:[NSError errorWithDomain:@"NSURLError" code:error.code userInfo:nil]];
                                                            } else {
                                                                NSInteger httpStatus = [(NSHTTPURLResponse *)response statusCode];
                                                                [promise reject:[NSError errorWithDomain:@"NSURLError" code:httpStatus userInfo:nil]];
                                                            }
                                                        } else {
                                                            [promise resolve:data];
                                                        }
                                                    }];
            [task resume];
        });
    }];
}

#pragma mark - Reachability

+ (BOOL)isNetworkConnectEnable {
    /*
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable: // 圏外
            return NO;
        case ReachableViaWWAN: // 3G/LTE
        case ReachableViaWiFi: // WiFi
            return YES;
        default:
            break;
    }
     return NO;
     */
    return YES;
}

@end
