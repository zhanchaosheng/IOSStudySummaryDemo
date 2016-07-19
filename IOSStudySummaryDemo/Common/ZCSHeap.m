//
//  ZCSHeap.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 16/7/18.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "ZCSHeap.h"

@interface ZCSHeap() {
    BOOL bHeapCreated; //堆是否已经创建
}

@property (nonatomic, strong) NSMutableArray *heapData; // 用来存放堆的数组,从编号1开始为有效元素
@property (nonatomic, assign) NSUInteger heapLength; // 用来存储堆中元素的个数，也就是堆的大小
@property (nonatomic, assign) ZCSHeapType heapType; //堆类型：最小堆or最大堆
@property (nonatomic, strong) ZCSHeapComparator comparator; //堆元素比较器

@end


@implementation ZCSHeap

- (instancetype)initWithHeapData:(NSArray *)data
                      comparator:(ZCSHeapComparator)comparator {
    self = [super init];
    if (self) {
        _heapData = [NSMutableArray arrayWithCapacity:1];
        [_heapData addObject:[NSNull null]];
        [_heapData addObjectsFromArray:data];
        _heapLength = data.count;
        _heapType = ZCSHeapTypeMin;
        _comparator = comparator;
    }
    return self;
}

// 交换函数，用来交换堆中的两个元素的值
- (void)swapObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    
    [self.heapData exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

// 向下调整函数, 传入一个需要向下调整的结点编号index，即从堆中该结点开始向下调整
- (void)siftDownForObjectAtIndex:(NSUInteger)index {
    
    NSUInteger t;
    BOOL next = YES; // 用来标记是否需要继续向下调整
    
    // 当index结点有儿子的时候（其实是至少有左儿子的情况下）并且有需要继续调整的时候循环执行
    while (index * 2 <= self.heapLength && next) {
        
        BOOL bRetLeft;
        if (self.heapType == ZCSHeapTypeMin) {
            bRetLeft = self.comparator(self.heapData[index], self.heapData[index * 2]) > 0;
        }
        else {
            bRetLeft = self.comparator(self.heapData[index], self.heapData[index * 2]) < 0;
        }
        
        // 首先判断他和他左儿子的关系，并用t记录值较小(最小堆)或值较大(最大堆)的结点编号
        if (bRetLeft) {
            t = index * 2;
        }
        else {
            t = index;
        }
        
        // 如果他有右儿子的情况下，再对右儿子进行讨论
        if (index * 2 + 1 <= self.heapLength) {
            
            BOOL bRetRight;
            if (self.heapType == ZCSHeapTypeMin) {
                bRetRight = self.comparator(self.heapData[t], self.heapData[index * 2 + 1]) > 0;
            }
            else {
                bRetRight = self.comparator(self.heapData[t], self.heapData[index * 2 + 1]) < 0;
            }
            
            // 如果右儿子的值更小(最小堆)或值更大(最大堆)，更新较小的结点编号
            if (bRetRight) {
                t = index * 2 + 1;
            }
        }
        
        // 如果发现最小或最大的结点编号不是自己，说明子结点中有比父结点更小或更大的
        if (t != index) {
            [self swapObjectAtIndex:t withObjectAtIndex:index]; // 交换它们
            index = t; // 更新index为刚才与它交换的儿子结点的编号，便于接下来继续向下调整
        }
        else {
            next = NO; //否则说明不需要在进行调整了
        }
    }
}

// 建立堆
- (void)createHeap {
    
    if (!bHeapCreated) {
        //从最后一个非叶结点到第1个结点依次进行向上调整
        for (NSUInteger i = self.heapLength / 2; i >= 1; i--) {
            [self siftDownForObjectAtIndex:i];
        }
        bHeapCreated = YES;
    }
}

- (NSArray *)fetchHeapWithType:(ZCSHeapType)type {
    
    //如果还没有按指定类型建好堆，则创建堆
    if (!(self.heapType == type && bHeapCreated)) {
        self.heapType = type;
        bHeapCreated = NO;
        [self createHeap];
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.heapLength)];
    
    return [self.heapData objectsAtIndexes:indexSet];
}

- (NSArray *)heapSortWithOption:(ZCSHeapSortOption)option {
    
    ZCSHeapType oldHeapType = self.heapType;
    
    if (option == ZCSHeapSortOptionAsc) {
        self.heapType = ZCSHeapTypeMax;
    }
    else {
        self.heapType = ZCSHeapTypeMin;
    }
    
    //如果还没有按指定类型建好堆，则创建堆
    if (!(self.heapType == oldHeapType && bHeapCreated)) {
        bHeapCreated = NO;
        [self createHeap];
    }

    while (self.heapLength > 1) {
        [self swapObjectAtIndex:1 withObjectAtIndex:self.heapLength];
        self.heapLength--;
        [self siftDownForObjectAtIndex:1];
    }
    
    //恢复堆元素个数
    self.heapLength = self.heapData.count - 1;
    bHeapCreated = NO;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.heapLength)];
    
    return [self.heapData objectsAtIndexes:indexSet];
}

- (id)fetchObjectAtIndexOfLargest:(NSUInteger)index {
    
    if (index == 0 || index > self.heapLength) {
        return nil;
    }
    
    if (index == self.heapLength) {
        //即取最小的
        return [self fetchObjectAtIndexOfLeast:1];
    }
    
    if (index > self.heapLength / 2) {
        //转为取第（heapLength+1-index）小的
        return [self fetchObjectAtIndexOfLeast:self.heapLength+1-index];
    }
    
    //如果还没有建好最大堆，则创建
    if (!(self.heapType == ZCSHeapTypeMax && bHeapCreated)) {
        self.heapType = ZCSHeapTypeMax;
        bHeapCreated = NO;
        [self createHeap];
    }
    
    //排序并获取第index大数
    id result = nil;
    NSUInteger icount = 0; //获取次数，取到第index为止
    
    while (self.heapLength > 1) {
        
        result = self.heapData[1];
        
        icount++;
        if (icount == index) {
            break;
        }
        
        [self swapObjectAtIndex:1 withObjectAtIndex:self.heapLength];
        self.heapLength--;
        [self siftDownForObjectAtIndex:1];
    }
    
    //恢复堆元素个数
    self.heapLength = self.heapData.count - 1;
    bHeapCreated = NO;
    
    return result;
}

- (id)fetchObjectAtIndexOfLeast:(NSUInteger)index {
	
    if (index == 0 || index > self.heapLength) {
        return nil;
    }
    
    if (index == self.heapLength) {
        //即取最大的
        return [self fetchObjectAtIndexOfLargest:1];
    }
    
    if (index > self.heapLength / 2) {
        //转为取第（heapLength+1-index）大的
        return [self fetchObjectAtIndexOfLargest:self.heapLength+1-index];
    }
    
    //如果还没有建好最小堆，则创建
    if (!(self.heapType == ZCSHeapTypeMin && bHeapCreated)) {
        self.heapType = ZCSHeapTypeMin;
        bHeapCreated = NO;
        [self createHeap];
    }
    
    //排序并获取第index小数
    id result = nil;
    NSUInteger icount = 0; //获取次数，取到第index为止
    
    while (self.heapLength > 1) {
        
        result = self.heapData[1];
        
        icount++;
        if (icount == index) {
            break;
        }
        
        [self swapObjectAtIndex:1 withObjectAtIndex:self.heapLength];
        self.heapLength--;
        [self siftDownForObjectAtIndex:1];
    }
    
    //恢复堆元素个数
    self.heapLength = self.heapData.count - 1;
    bHeapCreated = NO;
    
    return result;
}


@end
