//
//  CoreTextData.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/9.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "CoreTextData.h"

@implementation CoreTextData

- (void)setCtFrame:(CTFrameRef)ctFrame
{
    if (_ctFrame != ctFrame)
    {
        if (_ctFrame != nil)
        {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)dealloc
{
    if (_ctFrame != nil)
    {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

@end
