//
//  CaiyunFileFunctionDelegate.h
//  CaiyunPlayer
//
//  Created by youcan on 13-11-29.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XBCaiyunVideoQuality) {
    //本地视频
    kVIDEO_QUALITY_LOCAL = 0,
    
    //流畅，低码流
    kVIDEO_QUALITY_LOW = 1,
    
    //标清，中间码流
    kVIDEO_QUALITY_MEDIUM = 2,
    
    //高清，高码流
    kVIDEO_QUALITY_HIGH = 3,
};

typedef NS_ENUM(NSInteger, XBPlayCompletedState) {
    //文件正常播放完成；
    kPlayCompletedStateNormal = 0,
    
    //文件正常播放完成；
    kPlayCompletedStateUserClose = 1,
    
    //URL地址错误，不可用或不可到达；
    kPlayCompletedStateUrlError = 2,
    
    //网络中断；
    kPlayCompletedStateNetworkError = 3,
};

typedef NS_ENUM(NSInteger, XBCaiyunFileType) {
    //常规文件类型，用户自己的、网盘上的视频文件
    kCaiyunFileTypeNormal = 0,
    
    //分享的文件
    kCaiyunFileTypeShare = 1,
    
    //下载到本地的文件
    kCaiyunFileTypeLocal = 2
};

typedef NS_ENUM(NSInteger, XBCaiyunPlayState) {
    kPlayStateInit = 0,
    kPlayStateLoading = 1,
    kPlayStatePlaying = 2,
    kPlayStatePausedUser = 3,
    kPlayStatePausedDrag = 4,
    kPlayStateCompletedNormal = 5,
    kPlayStateCompletedError = 6,
    kPlayStatePausedSystem = 7,
    kPlayStateInterrupted = 8,
    //拔掉耳机时自动暂停
    kPlayStatePausedUnplugHeadphone = 9
};

//插拔耳机的动作
typedef NS_ENUM(NSInteger, XBCaiyunHeadphoneEvent) {
    //没有耳机动作
    kHeadphoneEventNone = 0,
    
    //插上耳机
    kHeadphoneEventPlug = 1,
    
    //拔掉耳机
    kHeadphoneEventUnplug = 2
};

/**
 播放器的回调接口，彩云客户端应用需要实现该接口，并在初始化播放器后通过setDelegate方法把实现传递进去
 当用户在播放界面点击删除、分享、下载等按钮时，播放器会通知彩云客户端进行相应的操作
 **/
@protocol CaiyunFileFunctionDelegate <NSObject>
/**
 视频播放完成
 fileId：物理文件ID
 state：结束状态，XBPlayCompletedState
 0：文件正常播放完成；
 1：用户停止播放；
 2：URL地址错误；
 3：网络中断；
 ……
 */
- (void)didMediaPlayCompleted:(NSString *)fileId withState:(XBPlayCompletedState)state;

@optional
/**
 上一个文件（用于音乐播放器）
 */
- (void)willPlayPrev:(NSString *)fileId;

/**
 下一个文件（用于音乐播放器）
 */
- (void)willPlayNext:(NSString *)fileId;

/**
 用户点击了标题栏右侧的按钮（音乐播放器）
 */
- (void)didMenuClicked:(NSString *)fileId;

- (void)didReceiveMemoryWarning:(UIViewController *)controller;
@end
