//
//  AppDelegate.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/20.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCSAnimatorTransitioning.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZCSAnimatorTransitioning *animatorTransitioning;//自定义viewcontroller转场动画
@property (assign, nonatomic) BOOL isTransform;//是否支持转屏

@end

