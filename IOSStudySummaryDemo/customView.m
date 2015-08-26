//
//  customView.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/20.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "customView.h"

@implementation customView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//平移变换
//-(void)drawRect:(CGRect)rect
//{
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGRect rectangle = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
//    
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(100.0f, 50.0f);
//    
//    
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGPathAddRect(path, &transform, rectangle);
//    CGContextAddPath(currentContext, path);
//    [[UIColor brownColor] setStroke];
//    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setFill];
//    CGContextSetLineWidth(currentContext, 1.0f);
//    CGContextDrawPath(currentContext, kCGPathFillStroke);
//    CGPathRelease(path);
//}

//平移变换图形上下文
-(void)drawRect:(CGRect)rect
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(showStartEvent)])
    {
        [self.delegate showStartEvent];
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rectangle = CGRectMake(10.0f, 10.0f, 200.0f, 300.0f);
    CGPathAddRect(path, NULL, rectangle);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    
    CGContextTranslateCTM(currentContext, 100.0f, 40.0f);
    
    CGContextAddPath(currentContext, path);
    [[UIColor colorWithRed:0.20f green:0.6f blue:0.8f alpha:1.0f] setFill];
    [[UIColor brownColor] setStroke];
    
    CGContextSetLineWidth(currentContext, 5.0f);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    CGPathRelease(path);
    
    CGContextRestoreGState(currentContext);
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(showEndEvent)])
    {
        [self.delegate showEndEvent];
    }
    
}
@end
