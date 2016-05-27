//
//  ZCSWaterWaveView.m
//  IOSStudySummaryDemo
//
//  Created by zcs on 16/5/27.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "ZCSWaterWaveView.h"

#define pathPadding 30

@interface ZCSWaterWaveView()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer  *waveLayer;
@property (nonatomic, strong) CAShapeLayer  *waveLayer1;
@property (nonatomic, assign) CGFloat waterWaveWidth;
@property (nonatomic, assign) CGFloat waterWaveHeight;

@end

@implementation ZCSWaterWaveView {
    
    CGFloat offsetX;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor clearColor];    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds  = YES;
    _waterWaveHeight = self.frame.size.height / 2;
    _waterWaveWidth  = self.frame.size.width;
    _waveColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
    
    _waveLayer = [CAShapeLayer layer];
    _waveLayer.fillColor = [_waveColor colorWithAlphaComponent:0.5].CGColor;
    [self.layer addSublayer:_waveLayer];
    
    _waveLayer1 = [CAShapeLayer layer];
    _waveLayer1.fillColor = _waveColor.CGColor;
    [self.layer addSublayer:_waveLayer1];
}

- (void)setWaveColor:(UIColor *)waveColor {
    _waveColor = waveColor;
    _waveLayer.fillColor = waveColor.CGColor;
    _waveLayer1.fillColor = [waveColor colorWithAlphaComponent:0.5].CGColor;
}

- (void)setWaterWaveHeightRatio:(CGFloat)waterWaveHeightRatio {
    
    if (waterWaveHeightRatio >= 0 && waterWaveHeightRatio <= 1) {
        _waterWaveHeightRatio = waterWaveHeightRatio;
        _waterWaveHeight = self.frame.size.height * (1 - waterWaveHeightRatio);
    }
}

- (void)wave {
    
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

/**
     正弦型函数解析式：y=Asin（ωx+φ）+h
     各常数值对函数图像的影响：
     φ（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
     ω：决定周期（最小正周期T=2π/|ω|）
     A：决定峰值（即纵向拉伸压缩的倍数）
     h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
 */
- (void)getCurrentWave:(CADisplayLink *)displayLink {
    
    offsetX += self.waveSpeed;
    
    //第一条波形
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, _waterWaveHeight);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  _waterWaveWidth ; x++) {
        //y = _waveAmplitude* sinf((360/_waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + _waterWaveHeight;
        y = _waveAmplitude* sinf((2* M_PI * x / _waterWaveWidth) + offsetX * M_PI / _waterWaveWidth) + _waterWaveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    _waveLayer.path = path;
    CGPathRelease(path);
    
    //第二条波形
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, nil, 0, _waterWaveHeight);
    CGFloat y1 = 0.0f;
    for (float x = 0.0f; x <=  _waterWaveWidth ; x++) { //
        y1 = _waveAmplitude* sinf((2* M_PI * x / _waterWaveWidth) + offsetX * M_PI / _waterWaveWidth + M_PI/2) + _waterWaveHeight;
        CGPathAddLineToPoint(path1, nil, x, y1);
    }
    CGPathAddLineToPoint(path1, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path1, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path1);
    _waveLayer1.path = path1;
    CGPathRelease(path1);
}

- (void)stop {
    [self.waveDisplaylink invalidate];
    self.waveDisplaylink = nil;
}

@end
