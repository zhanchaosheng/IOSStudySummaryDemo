//
//  ZCSReadWriteLock.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 16/6/9.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  OS_OBJECT_USE_OBJC如果为1,那么ARC会自动管理dispatch_queue_t对象(适用于ios6以上)，
 *  但是对于ios6.0以下需要手动管理
 */
#if OS_OBJECT_USE_OBJC
#undef ZCSDispatchQueueRelease
#undef ZCSDispatchQueueSetterSementics
#define ZCSDispatchQueueRelease(q)
#define ZCSDispatchQueueSetterSementics strong
#else
#undef ZCSDispatchQueueRelease
#undef ZCSDispatchQueueSetterSementics
#define ZCSDispatchQueueRelease(q) (dispatch_release(q))
#define ZCSDispatchQueueSetterSementics assign
#endif

/**
 *  一个简单的读写锁，读操作并列执行，写操作同步执行
 */

typedef void(^operationBlock)(void);

@interface ZCSReadWriteLock : NSObject

/**
 *  写操作
 *
 *  @param writeBlock 写操作
 *  @param async      是否异步调用
 */
- (void)write:(operationBlock)writeBlock asynchronous:(BOOL)async;

/**
 *  读操作
 *
 *  @param readBlock 读操作
 *  @param async     是否异步调用
 */
- (void)read:(operationBlock)readBlock asynchronous:(BOOL)async;

@end
