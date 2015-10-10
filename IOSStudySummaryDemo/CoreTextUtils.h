//
//  CoreTextUtils.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/10.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"

@interface CoreTextUtils : NSObject

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
