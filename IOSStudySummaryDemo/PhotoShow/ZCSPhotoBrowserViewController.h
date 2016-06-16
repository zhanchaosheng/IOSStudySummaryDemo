//
//  ZCSPhotoBrowserViewController.h
//  IOSStudySummaryDemo
//
//  Created by zcs on 16/6/16.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STATE_BAR_HEIGHT (20.1)
#define PADDING  20
//iOS7
#define isiOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)
//iOS8
#define isiOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)
//iOS9
#define isiOS9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)

//tabBar高度
#define kBarHeight ((iPhone6)?58.0f:((iPhone6Plus)?60.0f:51.0f))

//做iphone4屏幕适配
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//做iphone5屏幕适配
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//做iphone6屏幕适配
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//做iphone6+屏幕适配
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define KMainColor [UIColor colorWithRed:(CGFloat)31/255 green:(CGFloat)123/255 blue:(CGFloat)238/255 alpha:1]

@interface ZCSPhotoBrowserViewController : UIViewController
- (instancetype)initWithImagesSource:(NSArray *)images andStartAtIndex:(NSUInteger)index;
@end
