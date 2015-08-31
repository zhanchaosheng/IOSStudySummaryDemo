//
//  ZCSAnimatorTransitioning.m
//  IOSStudySummaryDemo
//  实现viewController转场动画
//  Created by Cusen on 15/8/25.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "ZCSAnimatorTransitioning.h"

@implementation ZCSAnimatorTransitioning


#pragma mark - UINavigationControllerDelegate
//实现交互式转场动画
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransitionController;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        return self;//返回实现了UIViewControllerAnimatedTransitioning协议的实例
    }
    else if (operation == UINavigationControllerOperationPop)
    {
        return self;
    }
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning
//定义了动画的持续时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8;
}

//描述整个动画的执行效果
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];//更新viewcontroller的状态
        
    }];
    
}

//转场完成
- (void)animationEnded:(BOOL) transitionCompleted
{
    if (transitionCompleted)
    {
        NSLog(@"ViewController transitionCompleted !");
    }
}


@end
