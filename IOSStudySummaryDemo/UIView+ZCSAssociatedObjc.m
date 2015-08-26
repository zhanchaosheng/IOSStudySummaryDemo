//
//  UIView+ZCSAssociatedObjc.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/21.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "UIView+ZCSAssociatedObjc.h"
#import <objc/runtime.h>

static char associatedStringKey;

@implementation UIView (ZCSAssociatedObjc)

- (NSString *)associatedString
{
    return objc_getAssociatedObject(self, &associatedStringKey);
}

- (void)setAssociatedString:(NSString *)associatedString
{
    objc_setAssociatedObject(self, &associatedStringKey, associatedString, OBJC_ASSOCIATION_RETAIN);
}

@end
