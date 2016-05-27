//
//  ZCSWaterWaveView.h
//  IOSStudySummaryDemo
//
//  Created by zcs on 16/5/27.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSWaterWaveView : UIView
/**
 *  波浪的快慢
 */
@property (nonatomic,assign) CGFloat waveSpeed;

/**
 *  波浪的震荡幅度
 */
@property (nonatomic,assign) CGFloat waveAmplitude;

/**
 *  波浪的高度比例，即波浪高度占容器高度的比例 0.0 ~ 1.0
 */
@property (nonatomic, assign) CGFloat waterWaveHeightRatio;

/**
 *  波浪颜色
 */
@property (nonatomic,strong) UIColor *waveColor;
/**
 *  开始波浪
 */
-(void)wave;

/**
 *  停止波浪
 */
-(void)stop;

@end
