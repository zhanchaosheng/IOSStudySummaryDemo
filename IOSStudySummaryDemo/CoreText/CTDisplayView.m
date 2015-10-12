//
//  CTDisplayView.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/9.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextUtils.h"

@implementation CTDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //得到当前绘制画布的上下文，用于后续将内容绘制在画布上
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将坐标系上下翻转。对于底层的绘制引擎来说，屏幕的左下角是（0, 0）坐标。
    //而对于上层的 UIKit 来说，左上角是 (0, 0) 坐标。所以我们为了之后的坐标系描述按 UIKit 来做，
    //所以先在这里做一个坐标系的上下翻转操作。翻转之后，底层和上层的 (0, 0) 坐标就是重合的了。
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data)
    {
        CTFrameDraw(self.data.ctFrame, context);
    }
    
    //绘制图片
    for (CoreTextImageData *imagedata in self.data.imageArray)
    {
        UIImage *image = [UIImage imageNamed:imagedata.name];
        CGContextDrawImage(context, imagedata.imagePosition, image.CGImage);
    }
    
}

//添加点击支持,除了下面的方法也可以增加UITapGestureRecognizer手势实现
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.data == nil)
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    //检测是否点中图片
    for (CoreTextImageData * imageData in self.data.imageArray)
    {
        // 翻转坐标系，因为 imageData 中的坐标是 CoreText 的坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        // 检测点击位置 Point 是否在 rect 之内
        if (CGRectContainsPoint(rect, touchPoint))
        {
            // 在这里处理点击后的逻辑
            NSLog(@"图片%@被点击了",imageData.name);
            break;
        }
    }
    
    //检测是否点中连接
    CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self atPoint:touchPoint data:self.data];
    if (linkData)
    {
        NSLog(@"连接被点击了:%@",linkData.url);
    }
}

@end
