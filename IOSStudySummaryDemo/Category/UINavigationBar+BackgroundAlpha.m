//
//  UINavigationBar+BackgroundAlpha.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 16/6/1.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "UINavigationBar+BackgroundAlpha.h"
#import <objc/runtime.h>

@interface UINavigationBar ()

@property (nonatomic, assign) BOOL     zcsOriginIsTranslucent;
@property (nonatomic, strong) UIImage *zcsOriginBackgroundImage;
@property (nonatomic, strong) UIImage *zcsOriginShadowImage;
@property (nonatomic, strong) UIView  *zcsBackgroundView;

@end

@implementation UINavigationBar (BackgroundAlpha)

- (void)zcs_setBackgroundAlpha:(CGFloat)alpha{
    [self zcs_setBackgroundColor:[self.barTintColor colorWithAlphaComponent:alpha]];
}

- (void)zcs_setBackgroundColor:(UIColor *)color{
    if (!self.zcsBackgroundView) {
        self.zcsOriginBackgroundImage = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
        self.zcsOriginShadowImage     = self.shadowImage;
        self.zcsOriginIsTranslucent   = self.translucent;
        
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:nil];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        bgView.userInteractionEnabled = NO;
        [self insertSubview:bgView atIndex:0];
        
        self.zcsBackgroundView = bgView;
        self.translucent       = YES;
        
    }
    self.zcsBackgroundView.backgroundColor = color;
    
}

- (void)zcs_reset{
    [self setBackgroundImage:self.zcsOriginBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:self.zcsOriginShadowImage];
    [self setTranslucent:self.zcsOriginIsTranslucent];
    
    [self.zcsBackgroundView removeFromSuperview];
    self.zcsOriginBackgroundImage = nil;
    self.zcsOriginShadowImage     = nil;
    self.zcsBackgroundView        = nil;
}

#pragma mark- getters & setters

- (UIImage *)zcsOriginBackgroundImage{
    return objc_getAssociatedObject(self, @selector(zcsOriginBackgroundImage));
}
- (void)setZcsOriginBackgroundImage:(UIImage *)zcsOriginBackgroundImage{
    objc_setAssociatedObject(self, @selector(zcsOriginBackgroundImage), zcsOriginBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)zcsOriginShadowImage{
    return objc_getAssociatedObject(self, @selector(zcsOriginShadowImage));
}
- (void)setZcsOriginShadowImage:(UIImage *)zcsOriginShadowImage{
    objc_setAssociatedObject(self, @selector(zcsOriginShadowImage), zcsOriginShadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)zcsBackgroundView{
    return objc_getAssociatedObject(self, @selector(zcsBackgroundView));
}
- (void)setZcsBackgroundView:(UIView *)zcsBackgroundView{
    objc_setAssociatedObject(self, @selector(zcsBackgroundView), zcsBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)zcsOriginIsTranslucent{
    return [objc_getAssociatedObject(self, @selector(zcsOriginIsTranslucent)) boolValue];
}
- (void)setZcsOriginIsTranslucent:(BOOL)zcsOriginIsTranslucent{
    objc_setAssociatedObject(self, @selector(zcsOriginIsTranslucent), @(zcsOriginIsTranslucent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
