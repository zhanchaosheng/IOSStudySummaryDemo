//
//  ZCSHeap.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 16/7/18.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

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
typedef NSInteger(^ZCSHeapComparator)(id objc1, id objc2);

typedef NS_ENUM(NSUInteger, ZCSHeapType) {
    ZCSHeapTypeMin, //最小堆
    ZCSHeapTypeMax, //最大堆
};

typedef NS_ENUM(NSUInteger, ZCSHeapSortOption) {
    ZCSHeapSortOptionAsc, //升序
    ZCSHeapSortOptionDesc, //降序
};

@interface ZCSHeap : NSObject

/**
 *  初始化堆
 *
 *  @param data       堆元素数组
 *  @param type       堆类型：最小堆/最大堆
 *  @param comparator 堆元素比较函数，1：大于，0：等于，-1：小于
 *
 *  @return 堆处理对象
 */
- (instancetype)initWithHeapData:(NSArray *)data
                      comparator:(ZCSHeapComparator)comparator;

/**
 *  获取指定类型的堆
 *
 *  @param type 堆类型
 *
 *  @return 按指定类型创建好的堆
 */
- (NSArray *)fetchHeapWithType:(ZCSHeapType)type;

/**
 *  堆排序(最小堆排序后元素为从大到小，最大堆排序后元素为从小到大)
 *
 *  @param option 升序/降序
 *
 *  @return 排好序的元素数组
 */
- (NSArray *)heapSortWithOption:(ZCSHeapSortOption)option;

/**
 *  获取堆中第index大的元素
 *
 *  @param index 第index大
 *
 *  @return 堆中第index大的元素
 */
- (id)fetchObjectAtIndexOfLargest:(NSUInteger)index;

/**
 *  获取堆中第index小的元素
 *
 *  @param index 弟index小
 *
 *  @return 堆中第index小的元素
 */
- (id)fetchObjectAtIndexOfLeast:(NSUInteger)index;

@end
