//
//  QualityBtnView.m
//  CaiyunPlayer
//
//  Created by youcan on 13-11-14.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import "XBQualityBtnView.h"
#define ANGLE_WIDTH 10.0
@implementation XBQualityBtnView

@synthesize title;
@synthesize pressed;
@synthesize quality;
@synthesize fontSize;

- (id)initWithFrame:(CGRect)frame isBox:(BOOL)mode forPad:(BOOL)pad
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        pressed = NO;
        self.title = @"未知";
        isBox = mode;
        isPad = pad;
    }
    return self;
}

- (void)dealloc
{
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, pressed?0.6:1.0);
//    CGContextSetLineWidth(context, isPad?3.0:2.0);
    CGSize s = self.frame.size;
//    CGContextAddRect(context, CGRectMake(0, 0, s.width, s.height));
//    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, pressed?0.6:1.0);
    UIFont  *font = [UIFont fontWithName:@"Heiti SC" size:fontSize];
    CGFloat tx = isBox ? (s.width - (isPad?9.0:5.5) - fontSize*2)/2 : (s.width - fontSize*2)/2;
    [title drawInRect:CGRectMake(tx, (s.height - fontSize)/2, fontSize*2, fontSize) withFont:font];

//    if (isBox) {
//        //三角：79，21，17x15
//        //三角：39.5，10.5，8.5x7.5
//        UIColor *color = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:pressed?0.6:1.0];
//        CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
//        [color release];
//        CGPoint sPoints[3];//坐标点
//        if (isPad) {
//            /**
//             
//             iPad
//             1753,1419,136x70
//             边框宽度：6
//             标清文字：字号36，位置1771,1436,69x33
//             三角：1846,1444,24x20
//93,25,24x20
//46.5,12.5,12x10
//             */
//            sPoints[0] =CGPointMake(46.5, 12.5);//坐标1
//            sPoints[1] =CGPointMake(58.5, 12.5);//坐标2
//            sPoints[2] =CGPointMake(52.5, 22.5);//坐标3
//        } else {
//            sPoints[0] =CGPointMake(39.5, 10.5);//坐标1
//            sPoints[1] =CGPointMake(48.0, 10.5);//坐标2
//            sPoints[2] =CGPointMake(44.75, 18.0);//坐标3
//        }
//        CGContextAddLines(context, sPoints, 3);//添加线
//        CGContextClosePath(context);//封起来
//        CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
//    }
}


@end
