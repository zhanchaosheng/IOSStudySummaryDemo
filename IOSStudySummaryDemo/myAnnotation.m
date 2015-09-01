//
//  myAnnotation.m
//  myDmeo
//
//  Created by Eddy on 15-6-19.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "myAnnotation.h"

@implementation myAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    return self;
}
@end
