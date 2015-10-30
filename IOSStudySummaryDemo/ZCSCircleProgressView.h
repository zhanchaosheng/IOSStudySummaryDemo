//
//  ZCSCircleProgressView.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/30.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSCircleProgressView : UIView

@property (strong, nonatomic) CAShapeLayer *trackLayer;
@property (strong, nonatomic) UIBezierPath *trackPath;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) UIBezierPath *progressPath;

@property (strong, nonatomic) UIColor *trackColor;
@property (strong, nonatomic) UIColor *progressColor;
@property (assign, nonatomic) float progress;//0~1之间的数
@property (assign, nonatomic) float progressWidth;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
