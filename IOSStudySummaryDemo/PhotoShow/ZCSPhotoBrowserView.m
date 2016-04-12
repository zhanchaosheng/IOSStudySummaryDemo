//
//  ZCSPhotoBrowserView.m
//  IOSStudySummaryDemo
//
//  Created by zcs on 16/4/12.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "ZCSPhotoBrowserView.h"
#import "ZCSPhotoShowView.h"

@interface ZCSPhotoBrowserView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *photoBrowser;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, assign) BOOL willDisappear;
@property (nonatomic, assign) BOOL hasShowedFistView;

@end

@implementation ZCSPhotoBrowserView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ZCSPhotoBrowserBackgrounColor;
    }
    return self;
}

- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self
                                                     forKeyPath:@"frame"];
}

- (void)didMoveToSuperview {
    [self setupScrollView];
    [self setupToolbars];
}

- (void)setupScrollView {
    if (_photoBrowser) {
        return;
    }
    _photoBrowser = [[UIScrollView alloc] initWithFrame:self.bounds];
    _photoBrowser.delegate = self;
    _photoBrowser.showsHorizontalScrollIndicator = NO;
    _photoBrowser.showsVerticalScrollIndicator = NO;
    _photoBrowser.pagingEnabled = YES;
    [self addSubview:_photoBrowser];
    
    for (int i = 0; i < self.imageCount; i++) {
        ZCSPhotoShowView *imageShowView = [[ZCSPhotoShowView alloc] initWithFrame:self.bounds];
        imageShowView.tag = i;
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        [imageShowView addGestureRecognizer:singleTap];
        [_photoBrowser addSubview:imageShowView];
    }
    
    [self loadImageOfPhotoShowViewWithIndex:self.currentImageIndex];
}

- (void)setupToolbars {
    if (_indexLabel) {
        return;
    }
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:20];
    _indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _indexLabel.layer.cornerRadius = _indexLabel.bounds.size.height * 0.5;
    _indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        _indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    [self addSubview:_indexLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += ZCSPhotoBrowserImageViewMargin * 2;
    
    _photoBrowser.bounds = rect;
    _photoBrowser.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _photoBrowser.frame.size.width - ZCSPhotoBrowserImageViewMargin * 2;
    CGFloat h = _photoBrowser.frame.size.height;
    
    [_photoBrowser.subviews enumerateObjectsUsingBlock:^(ZCSPhotoShowView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = ZCSPhotoBrowserImageViewMargin + idx * (ZCSPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _photoBrowser.contentSize = CGSizeMake(_photoBrowser.subviews.count * _photoBrowser.frame.size.width, 0);
    _photoBrowser.contentOffset = CGPointMake(self.currentImageIndex * _photoBrowser.frame.size.width, 0);
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 35);
}

// 加载图片
- (void)loadImageOfPhotoShowViewWithIndex:(NSInteger)index
{
    ZCSPhotoShowView *imageView = [_photoBrowser.subviews objectAtIndex:index];
    if (imageView) {
        self.currentImageIndex = index;
        if ([self highQualityImageURLForIndex:index]) {
            [imageView setImageWithURL:[self highQualityImageURLForIndex:index]
                      placeholderImage:[self placeholderImageForIndex:index]];
        }
        else {
            [imageView setImage:[self placeholderImageForIndex:index]];
        }
    }
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        ZCSPhotoShowView *currentImageView = [_photoBrowser.subviews objectAtIndex:self.currentImageIndex];
        if (currentImageView &&
            [currentImageView isKindOfClass:[ZCSPhotoShowView class]]) {
            [currentImageView turnOffZoom];
        }
    }
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer {
    self.willDisappear = YES;
    
    ZCSPhotoShowView *currentImageView = (ZCSPhotoShowView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = [self sourceImageViewWihtIndex:currentIndex];
    if (sourceView == nil) {
        [self removeFromSuperview];
    }
    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:self];
    
    UIImage *tempImage = currentImageView.imageView.image;
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = tempImage;
    CGFloat h = (self.bounds.size.width / tempImage.size.width) * tempImage.size.height;
    
    if (!tempImage) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    [UIView animateWithDuration:ZCSPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        _indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showFirstImage
{
    UIView *sourceView = [self sourceImageViewWihtIndex:self.currentImageIndex];
    if (sourceView == nil) {
        return;
    }
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    CGRect targetTemp = [_photoBrowser.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    tempView.contentMode = [_photoBrowser.subviews[self.currentImageIndex] contentMode];
    _photoBrowser.hidden = YES;
    
    
    [UIView animateWithDuration:ZCSPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _photoBrowser.hidden = NO;
    }];
}

#pragma mark - ZCSPhotoBrowserViewDelegate

- (UIImage *)placeholderImageForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(placeholderImageWithIndex:forPhotoBrowser:)]) {
        return [self.delegate placeholderImageWithIndex:index forPhotoBrowser:self];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(highQualityImageURLWithIndex:forPhotoBrowser:)]) {
        return [self.delegate highQualityImageURLWithIndex:index forPhotoBrowser:self];
    }
    return nil;
}

- (UIView *)sourceImageViewWihtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(sourceImageViewWihtIndex:)]) {
        return [self.delegate sourceImageViewWihtIndex:index forPhotoBrowser:self];
    }
    return nil;
}

#pragma mark - UIScrollviewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _photoBrowser.bounds.size.width * 0.5) / _photoBrowser.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        ZCSPhotoShowView *imageView = [_photoBrowser.subviews objectAtIndex:index];
        if (imageView) {
            [imageView turnOffZoom];
        }
    }
    
    if (!self.willDisappear) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self loadImageOfPhotoShowViewWithIndex:index];
}
@end
