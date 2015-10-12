//
//  CTFrameParserConfig.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/9.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (id)init
{
    self = [super init];
    if (self)
    {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}

@end
