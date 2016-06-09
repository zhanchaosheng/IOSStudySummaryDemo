//
//  ZCSReadWriteLock.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 16/6/9.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "ZCSReadWriteLock.h"

@interface ZCSReadWriteLock()
@property (nonatomic, ZCSDispatchQueueSetterSementics) dispatch_queue_t barrierQueue;
@end

@implementation ZCSReadWriteLock

- (instancetype)init {
    self = [super init];
    if (self) {
        _barrierQueue = dispatch_queue_create("com.cusen.ZCSReadWriteLock", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc {
    ZCSDispatchQueueRelease(_barrierQueue);
}

- (void)write:(operationBlock)writeBlock asynchronous:(BOOL)async {
    if (writeBlock) {
        if (async) {
            dispatch_barrier_async(self.barrierQueue, writeBlock);
        }
        else {
            dispatch_barrier_sync(self.barrierQueue, writeBlock);
        }
    }
}

- (void)read:(operationBlock)readBlock asynchronous:(BOOL)async {
    if (readBlock) {
        if (async) {
            dispatch_async(self.barrierQueue, readBlock);
        }
        else {
            dispatch_sync(self.barrierQueue, readBlock);
        }
    }
}
@end
