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

@end



@interface CoreTextImageData : NSObject

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger position;
@property (assign, nonatomic) CGRect imagePosition;

@end