//
//  XBSpeakerView.m
//  CaiyunPlayer
//
//  Created by youcan on 13-11-15.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import "XBSpeakerView.h"

@implementation XBSpeakerView

@synthesize volume = _volume;
@synthesize silent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        silent = NO;
        _volume = 0.8;
        currentTag = kSPEAKER_TAG_ZERO;
    }
    return self;
}

- (void)setImage:(UIImage *)image ForTag:(NSInteger)tag
{
    UIImageView * view = [[UIImageView alloc]initWithImage:image];
    view.tag = tag;
    view.hidden = YES;
    [self addSubview:view];
}

- (void)setVolume:(CGFloat)volume
{
    UIView *btnView = [self viewWithTag:currentTag];
    if (btnView)btnView.hidden = YES;
    _volume = volume;
    if (_volume == 0) {
        currentTag = kSPEAKER_TAG_SILENT;
//    } else if (_volume <= 0.1) {
//        currentTag = kSPEAKER_TAG_ZERO;
    } else if (_volume <= 0.3) {
        currentTag = kSPEAKER_TAG_LOW;
    } else if (_volume <= 0.7) {
        currentTag = kSPEAKER_TAG_MIDDLE;
    } else if (_volume <= 1.0) {
        currentTag = kSPEAKER_TAG_FULL;
    }
    btnView = [self viewWithTag:currentTag];
    if (btnView)btnView.hidden = NO;
}

@end
