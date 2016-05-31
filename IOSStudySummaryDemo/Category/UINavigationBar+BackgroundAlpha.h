//
//  UINavigationBar+BackgroundAlpha.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 16/6/1.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundAlpha)

/**
 *  设置导航栏透明度
 *
 *  @param alpha
 */
- (void)zcs_setBackgroundAlpha:(CGFloat)alpha;

/**
 *  设置导航栏背景颜色
 *
 *  @param color
 */
- (void)zcs_setBackgroundColor:(UIColor *)color;

/**
 *  重置导航栏的状态，恢复到初始时的状态
 */
- (void)zcs_reset;

@end
