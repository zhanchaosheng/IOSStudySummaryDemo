//
//  PlayBtnView.m
//  CaiyunPlayer
//
//  Created by youcan on 13-11-14.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import "XBPlayBtnView.h"
#define LINE_WIDTH 4.0
#define ANGLE_WIDTH 0.4
//#define XB_AB 30.0
//#define XB_AH 22.0

@implementation XBPlayBtnView

@synthesize playing = _playing;
@synthesize pressed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _playing = NO;
        pressed = NO;
    }
    return self;
}

- (void)setPlaying:(BOOL)playing
{
    _playing = playing;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGSize s = self.frame.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, pressed?0.6:1.0);
    CGContextSetLineWidth(context, LINE_WIDTH/66.0*s.width);
    CGContextAddArc(context, s.width/2, s.height/2, s.width/2 - LINE_WIDTH, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    if (_playing) {
        //显示暂停按钮
        UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:pressed?0.6:1.0];
        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
        CGContextAddRect(context,CGRectMake(s.width*(1-ANGLE_WIDTH)/2, s.height*(1-ANGLE_WIDTH)/2, s.width*ANGLE_WIDTH, 4));//画方框
        CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
        CGContextAddRect(context,CGRectMake(s.width*(1-ANGLE_WIDTH)/2, s.height*(1-ANGLE_WIDTH)/2+12, s.width*ANGLE_WIDTH, 4));//画方框
        CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    } else {
        //显示播放按钮
        UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:pressed?0.6:1.0];
        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
        CGPoint sPoints[3];//坐标点
        sPoints[0] =CGPointMake(26.0/66.0*s.width, 18.0/66.0*s.height);//坐标1
        sPoints[1] =CGPointMake(48.0/66.0*s.width, s.height/2);//坐标2
        sPoints[2] =CGPointMake(26.0/66.0*s.width, 48.0/66.0*s.height);//坐标3
//        sPoints[0] =CGPointMake((s.width - XB_AH/66.0*s.width)/2, (s.height - XB_AB/66.0*s.height)/2);//坐标1
//        sPoints[1] =CGPointMake((s.width + XB_AH/66.0*s.width)/2, s.height/2);//坐标2
//        sPoints[2] =CGPointMake((s.width - XB_AH/66.0*s.width)/2, (s.height + XB_AB/66.0*s.height)/2);//坐标3
        CGContextAddLines(context, sPoints, 3);//添加线
        CGContextClosePath(context);//封起来
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }
}

@end
