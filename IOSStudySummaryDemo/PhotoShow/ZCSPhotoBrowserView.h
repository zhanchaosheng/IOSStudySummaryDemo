//
//  ZCSPhotoBrowserView.h
//  IOSStudySummaryDemo
//
//  Created by zcs on 16/4/12.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

// browser背景颜色
#define ZCSPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define ZCSPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define ZCSPhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define ZCSPhotoBrowserHideImageAnimationDuration 0.4f

@class ZCSPhotoBrowserView;
@protocol ZCSPhotoBrowserViewDelegate <NSObject>
@required
// 获取默认图
- (UIImage *)placeholderImageWithIndex:(NSInteger)index forPhotoBrowser:(ZCSPhotoBrowserView *)browser;

@optional
// 获取高清图
- (NSURL *)highQualityImageURLWithIndex:(NSInteger)index forPhotoBrowser:(ZCSPhotoBrowserView *)browser;

// 将图片原视图中的Rect映射到photoBrowserView中
- (UIView *)sourceImageViewWihtIndex:(NSInteger)index forPhotoBrowser:(ZCSPhotoBrowserView *)browser;
@end


@interface ZCSPhotoBrowserView : UIView

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, weak) id<ZCSPhotoBrowserViewDelegate> delegate;

- (void)show;

@end
