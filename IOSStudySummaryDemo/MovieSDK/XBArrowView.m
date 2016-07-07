//
//  XBArrowView.m
//  CaiyunPlayer
//
//  Created by youcan on 13-11-18.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import "XBArrowView.h"

@implementation XBArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextBeginPath(context);
    //28x116、44x99、47x102、35x116、47x130、44x133
    CGContextMoveToPoint(context, 14, 58);
    CGContextAddLineToPoint(context, 22, 49.5);
    CGContextAddLineToPoint(context, 23.5, 51);
    CGContextAddLineToPoint(context, 17.5, 58);
    CGContextAddLineToPoint(context, 23.5, 65);
    CGContextAddLineToPoint(context, 22, 66.5);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
}

@end
