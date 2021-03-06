//
//  AppDelegate.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/20.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "AppDelegate.h"
#import "firstViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //配置应用后台运行
    if ([UIDevice currentDevice].multitaskingSupported)//该设备是否支持多任务
    {
        NSError *setError = nil;
        NSError *activeError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setError];
        [[AVAudioSession sharedInstance] setActive:YES error:&activeError];
    }
    
    
    UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:[[firstViewController alloc] init]];
    //是否启用滑动返回功能
    rootController.interactivePopGestureRecognizer.enabled = YES;
    
    //实现UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning协议，自定义viewcontroller转场动画
    self.animatorTransitioning = [[ZCSAnimatorTransitioning alloc] init];
    rootController.delegate = self.animatorTransitioning;
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //设置永久后台运行
    __block UIBackgroundTaskIdentifier backgrouondTaskId;
    backgrouondTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (backgrouondTaskId != UIBackgroundTaskInvalid) {
            backgrouondTaskId = UIBackgroundTaskInvalid;
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isTransform) {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
