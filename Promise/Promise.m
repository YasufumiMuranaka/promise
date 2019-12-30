//
//  Promise.m
//
//  Created by Yasufumi Muranaka on 2019/02/13.
//  Copyright © 2019 Yasufumi Muranaka All rights reserved.
//

//#define DEBUG_PROMISE

#import "Promise.h"

@interface Promise ()

@property (copy, atomic) PromiseResolveBlock resolveBlock;
@property (copy, atomic) PromiseRejectBlock rejectBlock;
@property (weak, atomic) Promise *nextPromise;
@property (strong, atomic) dispatch_semaphore_t resolveSemaphore;
@property (strong, atomic) dispatch_semaphore_t rejectSemaphore;
@property (strong, atomic) dispatch_semaphore_t thenSemaphore;
@property (strong, atomic) dispatch_semaphore_t catchSemaphore;
@property (strong, atomic) dispatch_semaphore_t thenOrCatchInSemaphore;
@property (assign, atomic) NSInteger thenNestCount;
@property (assign, atomic) BOOL fireCatch;

@end

@implementation Promise

- (void)dealloc {
#ifdef DEBUG_PROMISE
    NSLog(@"%s dealloc", __PRETTY_FUNCTION__);
#endif
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.resolveSemaphore = dispatch_semaphore_create(0);
        self.rejectSemaphore = dispatch_semaphore_create(0);
        self.thenSemaphore = dispatch_semaphore_create(0);
        self.catchSemaphore = dispatch_semaphore_create(0);
        self.thenOrCatchInSemaphore = dispatch_semaphore_create(0);
        self.nextPromise = self;
    }
    return self;
}

- (instancetype)initWithHandler:(PromiseBlock)block {
    self = [self init];
    if (self) {
        if (block) {
            block(self);
        }
    }
    return self;
}

- (PromiseThenBlock)then {
#ifdef DEBUG_PROMISE
    NSLog(@"%s then start", __PRETTY_FUNCTION__);
#endif
    @synchronized (self) {
        self.thenNestCount++;
    }
    dispatch_semaphore_signal(self.thenOrCatchInSemaphore);
    __weak typeof(self) weakSelf = self;
    PromiseThenBlock block = ^Promise * _Nonnull (PromiseResolveBlock resolveBlock) {
        if (!weakSelf.fireCatch) {
            weakSelf.resolveBlock = resolveBlock;
            dispatch_semaphore_signal(weakSelf.thenSemaphore);
            dispatch_semaphore_wait(weakSelf.resolveSemaphore, DISPATCH_TIME_FOREVER);
            weakSelf.resolveBlock = nil;
        }
        @synchronized (weakSelf) {
            weakSelf.thenNestCount--;
            return weakSelf.nextPromise;
        }
    };
#ifdef DEBUG_PROMISE
    NSLog(@"%s then end", __PRETTY_FUNCTION__);
#endif
    return block;
}

- (PromiseCatchBlock)catch {
#ifdef DEBUG_PROMISE
    NSLog(@"%s catch start", __PRETTY_FUNCTION__);
#endif
    dispatch_semaphore_signal(self.thenOrCatchInSemaphore);
    __weak typeof(self) weakSelf = self;
    PromiseCatchBlock block = ^Promise * _Nonnull (PromiseRejectBlock rejectBlock) {
        if (!weakSelf.fireCatch) {
            weakSelf.rejectBlock = rejectBlock;
            dispatch_semaphore_signal(weakSelf.catchSemaphore);
            dispatch_semaphore_wait(weakSelf.rejectSemaphore, DISPATCH_TIME_FOREVER);
            weakSelf.rejectBlock = nil;
        }
        return weakSelf;
    };
#ifdef DEBUG_PROMISE
    NSLog(@"%s catch end", __PRETTY_FUNCTION__);
#endif
    return block;
}

- (PromiseFinallyBlock)finally {
    @synchronized (self) {
        PromiseFinallyBlock block = ^void (PromiseVoidBlock finallyBlock) {
            finallyBlock();
        };
        return block;
    }
}

- (void)resolve:(id)result {
    dispatch_semaphore_signal(self.rejectSemaphore);
    dispatch_semaphore_wait(self.thenSemaphore, DISPATCH_TIME_FOREVER);
    @synchronized (self) {
        if (self.resolveBlock) {
            @synchronized (self) {
                self.nextPromise = self.resolveBlock(result);
            }
            dispatch_semaphore_signal(self.resolveSemaphore);
            self.resolveBlock = nil;
        }
    }
}

- (void)reject:(NSError *)error {
#ifdef DEBUG_PROMISE
    NSLog(@"%s %d", __PRETTY_FUNCTION__, 1);
#endif
    dispatch_semaphore_wait(self.thenOrCatchInSemaphore, DISPATCH_TIME_FOREVER);
    for (; self.thenNestCount; ) {
        dispatch_semaphore_signal(self.resolveSemaphore);
        dispatch_semaphore_wait(self.thenOrCatchInSemaphore, DISPATCH_TIME_FOREVER);
    }
#ifdef DEBUG_PROMISE
    NSLog(@"%s %d", __PRETTY_FUNCTION__, 2);
#endif
    dispatch_semaphore_wait(self.catchSemaphore, DISPATCH_TIME_FOREVER);
    @synchronized (self) {
        self.fireCatch = YES;
        if (self.rejectBlock) {
            self.rejectBlock(error);
            dispatch_semaphore_signal(self.rejectSemaphore);
#ifdef DEBUG_PROMISE
            NSLog(@"%s %d", __PRETTY_FUNCTION__, 3);
#endif
        }
    }
}

@end
