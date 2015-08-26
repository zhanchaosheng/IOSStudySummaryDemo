//
//  ZCSViewCallBackProtocol.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/21.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZCSViewCallBackProtocol <NSObject>

- (void)showStartEvent;
- (void)showEndEvent;
- (void)showMoveEvent;
@end
