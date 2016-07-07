//
//  XBBackBtnView.m
//  CaiyunPlayer
//
//  Created by youcan on 14-7-22.
//  Copyright (c) 2014年 mac . All rights reserved.
//

#import "XBBackBtnView.h"

@implementation XBBackBtnView

- (id)initWithFrame:(CGRect)frame isPad:(BOOL)isPad
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat l = 19.0f;
        CGFloat titleFontSize = 16.0f;
        UIImage *backImage;
        if (isPad) {
            backImage = [UIImage imageNamed:[@"XBBack" stringByAppendingString:@"-iPad"]];
        } else {
            backImage = [UIImage imageNamed:@"XBBack"];
        }
        UIImageView *backBtnView = [[UIImageView alloc] initWithImage:backImage];
        [backBtnView setCenter:CGPointMake([backImage size].width/2.0f+l, frame.size.height/2.0f)];
        [self addSubview:backBtnView];
        backBtnView = nil;
        l+=[backImage size].width + 6.0;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(l, (frame.size.height - titleFontSize)/2, frame.size.width - l, titleFontSize)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor= [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:titleFontSize];
        titleLabel.text = @"";
        [self addSubview:titleLabel];
        titleLabel = nil;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
