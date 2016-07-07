//
//  CaiyunMusicViewController.h
//  CaiyunPlayer
//
//  Created by youcan on 13-11-29.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPVolumeView.h>

#import "CaiyunFileFunctionDelegate.h"
#import "XBMusicFile.h"
#import "XBSpeakerView.h"

#define XBTagMusicPlayerMainView 3000

@interface CaiyunMusicViewController : UIViewController
{
    @private
    //CaiyunFileFunctionDelegate
    id delegate;

    //文件类型：
//    XBCaiyunFileType fileType;

    BOOL isPad;
    
    BOOL isPlaying;
    BOOL isFunctionViewOut;
    //屏幕尺寸
    CGSize screenSize;
    //屏幕scale
    CGFloat scale;

    //控制操作界面
    UILabel *titleLabel, *musicTitleLabel, *musicSingerLabel;
//    UIView *controlView;
    //播放按钮界面
    UIImageView *playBtnView;
    //播放按钮界面
    UIImageView *pauseBtnView;
    //喇叭
    XBSpeakerView * speakerView;

    //显示播放时间的文字标签
    UILabel *timeLabel;
    //总播放时长的文字标签
    UILabel *totalTimeLabel;
    //播放进度条
    UISlider *playerSlider;
    //音量调节进度条
    UISlider *volumeSlider;
    //等待图标
    UIActivityIndicatorView *activityView;
    //音乐播放器
    MPMoviePlayerController *myPlayer;
    
    UIImageView *functionView;
    UIImageView *handlerView;
    
    //视频播放地址
    XBMusicFile *musicFile;

    //播放计时器
    NSTimer *playerTimer;

    //自动隐藏控制操作界面计时器
//    NSTimer *hiddenTimer;
    
    //拖动时的当前点
    CGPoint startPoint;
    
    //拖动模式
    NSInteger dragMode;
    
    BOOL pausedForDrag;
}

/**
 初始化
 frame: 窗口大小
 */
- (id)initWithFame:(CGRect)frame;

/**
 CaiyunVideoViewDelegate
 */
- (void)setDelegate:(id)fileDelegate;

/**
 播放音乐
 file：音乐文件对象
 */
- (void)play:(XBMusicFile *)file;

@end
