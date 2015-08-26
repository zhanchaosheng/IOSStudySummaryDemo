//
//  ZCSAnimatorTransitioning.h
//  IOSStudySummaryDemo
//  实现viewController转场动画
//  Created by Cusen on 15/8/25.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZCSAnimatorTransitioning : NSObject
<UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>
//交互式转场控制器
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransitionController;

@end
