//
//  ZCSPhotoShowView.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/9/25.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "ZCSPhotoShowView.h"

@interface ZCSPhotoShowView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ZCSPhotoShowView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
        [self setMaximumZoomScale:5.0];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self isZoomed] == NO && CGRectEqualToRect([self bounds], [_imageView frame]) == NO)
    {
        [_imageView setFrame:[self bounds]];
    }
}

- (void)setImage:(UIImage *)newImage
{
    self.imageView.image = newImage;
}

- (BOOL)isZoomed
{
    return !([self zoomScale] == [self minimumZoomScale]);
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)zoomToLocation:(CGPoint)location
{
    float newScale;
    CGRect zoomRect;
    if ([self isZoomed])
    {
        zoomRect = [self bounds];
    }
    else
    {
        newScale = [self maximumZoomScale];
        zoomRect = [self zoomRectForScale:newScale withCenter:location];
    }
    
    [self zoomToRect:zoomRect animated:YES];
}

- (void)turnOffZoom
{
    if ([self isZoomed])
    {
        [self zoomToLocation:CGPointZero];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self && [touch tapCount] == 2)
    {
        [self zoomToLocation:[touch locationInView:self]];
    }
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    
//    if ([touch view] == self && [touch tapCount] == 1)
//    {
//    }
//}

#pragma mark UIScrollViewDelegate Methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
