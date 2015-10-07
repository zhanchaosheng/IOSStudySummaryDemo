//
//  PictureCollectionViewCell.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/6.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect rect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height - 15);
        //图片
        self.imageView = [[UIImageView alloc] initWithFrame:rect];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
        
        //图片名
        rect = CGRectMake(self.bounds.origin.x, self.bounds.size.height - 14, self.bounds.size.width, 12);
        self.nameLabel = [[UILabel alloc] initWithFrame:rect];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end
