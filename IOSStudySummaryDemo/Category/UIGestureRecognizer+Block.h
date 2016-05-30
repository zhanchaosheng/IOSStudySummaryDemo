//
//  UIGestureRecognizer+Block.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 16/5/28.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZCSGestureBlock)(id sender);

@interface UIGestureRecognizer (Block)

+ (instancetype)zcs_gestureRecognizerWithActionBlock:(ZCSGestureBlock)block;

@end
