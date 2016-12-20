//
//  ZCRunLoopManager.m
//  ZCRunLoopDemo
//
//  Created by Cusen on 2016/12/17.
//  Copyright © 2016年 Zcoder. All rights reserved.
//

#import "ZCRunLoopManager.h"

typedef void (^runLoopObserverHandler)(CFRunLoopObserverRef observer, CFRunLoopActivity activity);
void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);
CFDataRef MessagePortCallback(CFMessagePortRef port, SInt32 messageID, CFDataRef data, void *info);
void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
void RunLoopSourceCancelRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
void RunLoopSourcePerformRoutine(void *info);

@interface ZCRunLoopManager ()<NSPortDelegate> {
    CFRunLoopRef _workThreadRunLoop;
    CFRunLoopSourceRef _customSource;
    CFRunLoopTimerRef _timerSource;
    NSPort *_localPort;
    NSPort *_distantPort;
}

@end

@implementation ZCRunLoopManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 工作线程
/**
 创建工作线程
 */
- (NSThread *)workThread {
    if (_workThread == nil) {
        _workThread = [[NSThread alloc] initWithTarget:self
                                              selector:@selector(workThreadEntryPoint:)
                                                object:nil];
        [_workThread start];
    }
    return _workThread;
}

/**
 工作线程入口函数
 */
- (void)workThreadEntryPoint:(id) __unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"ZCWorkThread"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        _workThreadRunLoop = [runLoop getCFRunLoop];
        
        // 创建了一个新的 NSMachPort 添加进去了，让 RunLoop 不至于退出
        // 当需要这个工作线程执行任务时，通过调用 [NSObject performSelector:onThread:..] 将这个任务扔到了工作线程的 RunLoop 中
        // 例如：
        // [self performSelector:@selector(doSomething) onThread:self.workThread withObject:nil waitUntilDone:NO modes:NSDefaultRunLoopMode];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        
        // 添加Observe
        [self setupObserverHandlerForWorkThread];
        
        // 添加Source0
        [self setupCustomSource];
        
        [runLoop run];
    }
}

#pragma mark - 观察者
/**
 监控RunLoop
 kCFRunLoopEntry          // 即将进入Loop
 kCFRunLoopBeforeTimers   // 即将处理 Timer
 kCFRunLoopBeforeSources  // 即将处理 Source
 kCFRunLoopBeforeWaiting  // 即将进入休眠
 kCFRunLoopAfterWaiting   // 刚从休眠中唤醒
 kCFRunLoopExit           // 即将退出Loop
 */
- (void)setupObserverHandlerForWorkThread {
    
//    CFRunLoopObserverContext context = {0, NULL, NULL, NULL, NULL};
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
//                                                            kCFRunLoopAllActivities,
//                                                            YES,
//                                                            0,
//                                                            &runLoopObserverCallBack,
//                                                            &context);

    runLoopObserverHandler observerHandler = ^(CFRunLoopObserverRef observer,
                                               CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"------>RunLoopEntry");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"------>RunLoopBeforeTimers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"------>RunLoopBeforeSources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"------>RunLoopBeforeWaiting");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"------>RunLoopAfterWaiting");
                break;
            case kCFRunLoopExit:
                NSLog(@"------>RunLoopExit");
                break;
            default:
                break;
        }
    };
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                                       kCFRunLoopAllActivities,
                                                                       YES,
                                                                       0,
                                                                       observerHandler);
    if (observer) {
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    }
}

#pragma mark - 定时源
//创建定时源有两种方式，一种是使用NSTimer对象创建，一种是使用CFRunLoopTimerRef对象创建

- (void)createAndScheduleTimerToRunLoopUsingNSTimer {
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    // 可以配置到当前线程RunLoop的不同模式
    NSDate *futureDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
    NSTimer *myTimer = [[NSTimer alloc] initWithFireDate:futureDate
                                                interval:2.0
                                                  target:self
                                                selector:@selector(timerFireMethod:)
                                                userInfo:nil
                                                 repeats:YES];
    [runLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
    
    // 自动添加到当前线程RunLoop的NSDefaultRunLoopMode下
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)timerFireMethod:(NSTimer *)timer {
    
}

- (void)createAndScheduleTimerToRunLoopUsingCFRunLoopTimerRef {
    
//    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
//    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 0.3, 0, 0, &TimerCallBack, &context);
    
    _timerSource = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, 0.1, 2.0, 0, 0, ^(CFRunLoopTimerRef timer) {
        NSLog(@"------>timer fire");
        // 调用CFRunLoopTimerIsValid/CFRunLoopRemoveTimer可以移除timer
    });
    
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), _timerSource, kCFRunLoopCommonModes);
}

#pragma mark - 自定义输入源
//CFRunLoopSourceRef 是事件产生的地方。Source有两个版本：Source0 和 Source1。
//• Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。
//• Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程

/**
 创建自定义输入源source0
 */
- (void)setupCustomSource {
    
    CFRunLoopSourceContext context = { 0, NULL, NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleRoutine,
        &RunLoopSourceCancelRoutine,
        &RunLoopSourcePerformRoutine };
    
    _customSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    if (_customSource) {
        CFRunLoopAddSource(CFRunLoopGetCurrent(), _customSource, kCFRunLoopCommonModes);
    }
}

- (void)fireCustomSource {
    if (_customSource) {
        CFRunLoopSourceSignal(_customSource);
        CFRunLoopWakeUp(_workThreadRunLoop);
    }
}

#pragma mark - 基于端口的输入源(NSMessagePort)

- (void)setupPortSource {
    _localPort = [NSMachPort port];
    if (_localPort) {
        _localPort.delegate = self;
        [[NSRunLoop currentRunLoop] addPort:_localPort forMode:NSDefaultRunLoopMode];
    }
}

- (void)handlePortMessage:(NSPortMessage *)message {
//    uint32_t mssgId = [message msgid];
//    NSPort *distantPort = nil;
//    
//    if(message == kCheckinMessage) {
//        _distantPort = [message sendPort];
//    }
//    else {
//    }
}

#define kMessageId  0x1000
- (void)sendPortMessageToWorkThread {
//    NSPort *myPort = [NSMachPort port];
//    [myPort setDelegate:self];
//    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
//
//    NSPortMessage* messageObj = [[NSPortMessage alloc] initWithSendPort:outPort
//                                                            receivePort:myPort components:nil];
//    if (messageObj) {
//        //完成配置消息并立即将其发送
//        [messageObj setMsgId:kMessageId];
//        [messageObj sendBeforeDate:[NSDate date]];
//    }
}

- (void)setupMessagePortSource {
    CFMessagePortRef localPort = CFMessagePortCreateLocal(nil,
                                                          CFSTR("com.example.app.port"),
                                                          MessagePortCallback,
                                                          nil,
                                                          nil);
    
    CFRunLoopSourceRef runLoopSource = CFMessagePortCreateRunLoopSource(nil, localPort, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
}

- (void)sendToMessagePort {
    CFDataRef data;
    SInt32 messageID = 0x1111; // Arbitrary
    CFTimeInterval timeout = 10.0;
    
    CFMessagePortRef remotePort = CFMessagePortCreateRemote(nil,
                                                            CFSTR("com.example.app.port"));
    
    SInt32 status = CFMessagePortSendRequest(remotePort,
                                             messageID,
                                             data,
                                             timeout,
                                             timeout,
                                             NULL,
                                             NULL);
    if (status == kCFMessagePortSuccess) {
        // ...
    }
}

@end


void runLoopObserverCallBack(CFRunLoopObserverRef observer,
                             CFRunLoopActivity activity,
                             void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            printf("------>RunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            printf("------>RunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            printf("------>RunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            printf("------>RunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            printf("------>RunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            printf("------>RunLoopExit");
            break;
        default:
            break;
    }
}

CFDataRef MessagePortCallback(CFMessagePortRef port, SInt32 messageID, CFDataRef data, void *info) {
    // ...
    return NULL;
}

// 当source添加进runloop的时候，调用此回调方法 (CFRunLoopAddSource(runLoop, source, mode))
void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode) {
    printf("------>RunLoopSourceScheduleRoutine");
}

// 在输入源被告知（signal source）时，调用此回调方法 (CFRunLoopSourceSignal(source);CFRunLoopWakeUp(runLoop))
void RunLoopSourceCancelRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode) {
    printf("------>RunLoopSourceCancelRoutine");
}

// 当source 从runloop里删除的时候，调用此回调方法 (CFRunLoopSourceInvalidate/CFRunLoopRemoveSource)
void RunLoopSourcePerformRoutine(void *info) {
    printf("------>RunLoopSourcePerformRoutine");
}


