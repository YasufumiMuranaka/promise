//
//  Promise.h
//
//  Created by Yasufumi Muranaka on 2019/02/13.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Promise;
typedef void (^PromiseBlock)(Promise * _Nonnull promise);
typedef void (^PromiseVoidBlock)(void);
typedef Promise * _Nullable (^PromiseResolveBlock)(id result);
typedef void (^PromiseRejectBlock)(NSError *error);
typedef Promise * _Nonnull (^PromiseThenBlock)(PromiseResolveBlock resolveBlock);
typedef Promise * _Nonnull (^PromiseCatchBlock)(PromiseRejectBlock rejectBlock);
typedef void (^PromiseFinallyBlock)(PromiseVoidBlock voidBlock);

@interface Promise : NSObject
@property (weak, nonatomic) PromiseThenBlock then;
@property (weak, nonatomic) PromiseCatchBlock catch;
@property (weak, nonatomic) PromiseFinallyBlock finally;

- (instancetype)initWithHandler:(PromiseBlock)block;
- (void)resolve:(id)result;
- (void)reject:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
