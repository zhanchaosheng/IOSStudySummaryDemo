//
//  ZCSHeap.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 16/7/18.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger(^ZCSHeapComparator)(id objc1, id objc2);
/*
ZCSHeapComparator comparator = ^NSInteger(id objc1, id objc2) {
    NSUInteger value1 = [objc1 unsignedIntegerValue];
    NSUInteger value2 = [objc2 unsignedIntegerValue];
    if (value1 > value2) {
        return 1;
    }
    else if (value1 == value2) {
        return 0;
    }
    else {
        return -1;
    }
}
 */

typedef NS_ENUM(NSUInteger, ZCSHeapType) {
    ZCSHeapTypeMin,
    ZCSHeapTypeMax,
};

@interface ZCSHeap : NSObject

- (instancetype)initWithHeapData:(NSArray *)data
                        heapType:(ZCSHeapType)type
                      comparator:(ZCSHeapComparator)comparator;

- (NSArray *)heapSort;

@end
