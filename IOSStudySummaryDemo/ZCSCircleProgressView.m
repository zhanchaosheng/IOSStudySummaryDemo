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
//    self.progressPath = [UIBezierPath bezierPathWithArcCenter:self.center
//                                                   radius:(self.bounds.size.width - self.progressWidth)/ 2
//                                               startAngle:- M_PI_2
//                                                 endAngle:(M_PI * 2) * self.progress - M_PI_2
//                                                clockwise:YES];
    self.progressPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                       radius:(self.bounds.size.width - self.progressWidth)/ 2
                                                   startAngle:-M_PI
                                                     endAngle:M_PI
                                                    clockwise:YES];
    
    self.progressLayer.path = self.progressPath.CGPath;
    self.progressLayer.strokeEnd = 0.f;
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
//    [self setProgress];
    self.progressLayer.strokeEnd = progress;
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    //self.progress = progress;
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(self.progressLayer.strokeEnd);
        animation.toValue = @(progress);
        animation.duration = 1.f;
        animation.autoreverses = NO;
        animation.delegate = self;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        [self.progressLayer addAnimation:animation forKey:nil];
    }
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        if ([anim isKindOfClass:[CABasicAnimation class]])
        {
            CABasicAnimation *basicAnimation = (CABasicAnimation *)anim;
            self.progress = [basicAnimation.toValue floatValue];
        }
    }
}


@end
