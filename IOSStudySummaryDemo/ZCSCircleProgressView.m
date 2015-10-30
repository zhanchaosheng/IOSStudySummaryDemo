//
//  ZCSCircleProgressView.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/30.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "ZCSCircleProgressView.h"

@implementation ZCSCircleProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _trackLayer = [[CAShapeLayer alloc] init];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = self.bounds;
        [self.layer addSublayer:_trackLayer];
        
        _progressLayer = [[CAShapeLayer alloc] init];
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;
        [self.layer addSublayer:_progressLayer];
        
        //默认5
        self.progressWidth = 5;
    }
    return self;
}

- (void)setTrack
{
    self.trackPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                radius:(self.bounds.size.width - self.progressWidth) / 2
                                            startAngle:0
                                              endAngle:M_PI * 2
                                             clockwise:YES];
    self.trackLayer.path = self.trackPath.CGPath;
}

- (void)setProgress
{
    self.progressPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                   radius:(self.bounds.size.width - self.progressWidth)/ 2
                                               startAngle:- M_PI_2
                                                 endAngle:(M_PI * 2) * self.progress - M_PI_2
                                                clockwise:YES];
    self.progressLayer.path = self.progressPath.CGPath;
}


- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    self.trackLayer.lineWidth = _progressWidth;
    self.progressLayer.lineWidth = _progressWidth;
    
    [self setTrack];
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    [self setProgress];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    self.progress = progress;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
