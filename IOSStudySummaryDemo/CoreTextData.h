//
//  CoreTextData.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/9.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreText/CoreText.h"

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *linkArray;

@end


//图片信息
@interface CoreTextImageData : NSObject

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger position;
@property (assign, nonatomic) CGRect imagePosition;

@end


//连接信息
@interface CoreTextLinkData : NSObject

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * url;
@property (assign, nonatomic) NSRange range;

@end