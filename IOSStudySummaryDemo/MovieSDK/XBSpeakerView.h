//
//  XBSpeakerView.h
//  CaiyunPlayer
//
//  Created by youcan on 13-11-15.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, XBSpeakerTag) {
    kSPEAKER_TAG_ZERO = 200,
    kSPEAKER_TAG_LOW = 201,
    kSPEAKER_TAG_MIDDLE = 202,
    kSPEAKER_TAG_FULL = 203,
    kSPEAKER_TAG_SILENT = 204
};

@interface XBSpeakerView : UIView
{
    NSInteger currentTag;
}
@property (assign, nonatomic) CGFloat volume;
@property (assign, nonatomic) BOOL silent;

- (void)setImage:(UIImage *)image ForTag:(NSInteger)tag;
@end
