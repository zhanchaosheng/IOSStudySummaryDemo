//
//  customView.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/20.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCSViewCallBackProtocol.h"

@interface customView : UIView
@property (strong, nonatomic) id<ZCSViewCallBackProtocol> delegate;
@end
