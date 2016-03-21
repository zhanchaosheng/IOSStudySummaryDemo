//
//  KTCollectionViewCell.m
//  mCloud_iPhone
//
//  Created by Cusen on 15/11/9.
//  Copyright (c) 2015年 epro. All rights reserved.
//

#import "KTCollectionViewCell.h"
@implementation KTCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.thumbView = [[UIImageView alloc] initWithFrame:self.bounds];
        //self.thumbView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.thumbView];
        
        self.livePhotoBadgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        //self.livePhotoBadgeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.livePhotoBadgeImageView];
    }
    return self;
}

@end
