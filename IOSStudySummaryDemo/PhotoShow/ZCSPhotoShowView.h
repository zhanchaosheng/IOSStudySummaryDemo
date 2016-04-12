//
//  ZCSPhotoShowView.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/9/25.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSPhotoShowView : UIScrollView

@property (strong, nonatomic) UIImageView *imageView;

- (BOOL)isZoomed;
- (void)turnOffZoom;
- (void)setImage:(UIImage *)newImage;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
