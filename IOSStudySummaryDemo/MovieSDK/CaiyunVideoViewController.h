//
//  CaiyunVideoViewController.h
//  CaiyunPlayer
//
//  Created by XB  on 13-4-1.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPVolumeView.h>
#import "XBQualityBtnView.h"
#import "XBSpeakerView.h"
#import "CaiyunFileFunctionDelegate.h"

//自动隐藏控制界面的时间，单位：秒
#define autoHiddenTimeout 3

/**
 是否自动显示状态栏
 0：始终隐藏
 1：全屏播放时，随着其他工具栏（播放控制条、标题栏等）一同显示或隐藏
 */
#define autoShowStatusBar 0

@interface CaiyunVideoViewController : UIViewController
{
    @private
    //文件类型：
    XBCaiyunFileType fileType;
    
    //是iPad还是iPhone
    BOOL isPad;

    //屏幕尺寸
    CGSize screenSize;
    //屏幕scale
    CGFloat scale;
    
    //控制操作界面
    UIView *controlView;
    //播放按钮界面
    UIImageView *playBtnView;
    //播放按钮界面
    UIImageView *pauseBtnView;
    //喇叭
    XBSpeakerView * speakerView;
    //清晰度按钮
    UILabel *qualityBtnView;
    //当前清晰度
    XBCaiyunVideoQuality currentQuality;
    //清晰度按钮右侧的箭头图标
    UIImageView *qualityArrowView;
    //清晰度列表
    UIView *qualityListView;

    //显示播放时间的文字标签
    UILabel *timeLabel;
    //总播放时长的文字标签
    UILabel *totalTimeLabel;
    //播放进度条
    UISlider *playerSlider;
    //播放进度条的长度
    CGFloat playerSliderWidth;

    //音量调节进度条
    UIView *volumeSliderView;
    UISlider *volumeSlider;
    CGFloat volumeSliderWidth;
    CGFloat startSliderValue;
    
    //信息窗口
    UIImageView *infoView;
    
    //等待图标
    UIActivityIndicatorView *activityView;
    //视频播放器
    MPMoviePlayerController *myPlayer;
    
    //视频播放地址
    NSString *videoUrlHigh, *videoUrlMedium, *videoUrlLow, *videoUrlLocal;
    
    //播放计时器
    NSTimer *playerTimer;
    
    //自动隐藏控制操作界面计时器
    NSTimer *hiddenTimer;

    //检测播放超时的计时器
    NSTimer *stalledTimer;
    
    //拖动时的当前点
    CGPoint startPoint;
    
    //拖动模式
    NSInteger dragMode;
    
    //拖动进度条时暂停
    BOOL pausedForDrag;
    
    //进入播放器时，状态条是否为隐藏
    BOOL initinalStatusBarHidden;
    //进入播放器时的音量，离开时恢复
    CGFloat initinalValume;
    //是否静音
    BOOL isMuted;
    //静音前音量
    CGFloat beforeMutedValume;
    //当前的耳机插拔事件
    XBCaiyunHeadphoneEvent currentHeadphoneEvent;
    
    float systemVersion;
    
    //播放暂停时位于屏幕中央的播放按钮
    UIImageView *centerPlayBtn;
}

//当前播放状态
@property (nonatomic, assign) XBCaiyunPlayState currentState;

//物理文件ID
@property (nonatomic, strong) NSString *fileId;

//播放暂停时位于屏幕中央的播放按钮
@property (nonatomic, strong) UIImageView *pCenterPlayBtn;

//信息窗口
@property (nonatomic, strong) UIImageView *pInfoView;

//清晰度列表
@property (nonatomic, strong) UIView *pQualityListView;

//控制操作界面
@property (nonatomic, strong) UIView *pControlView;

//播放按钮界面
@property (nonatomic, strong) UIImageView *pPlayBtnView;

//暂停按钮界面
@property (nonatomic, strong) UIImageView *pPauseBtnView;

//播放进度条
@property (nonatomic, strong) UISlider *pPlayerSlider;

//显示播放时间的文字标签
@property (nonatomic, strong) UILabel *pTimeLabel;

//总播放时长的文字标签
@property (nonatomic, strong) UILabel *pTotalTimeLabel;

//清晰度按钮
@property (nonatomic, strong) UILabel *pQualityBtnView;

//清晰度按钮右侧的箭头图标
@property (nonatomic, strong) UIImageView *pQualityArrowView;

//喇叭
@property (nonatomic, strong) XBSpeakerView *pSpeakerView;

//音量调节进度条
@property (nonatomic, strong) UIView *pVolumeSliderView;

//音量调节进度条
@property (nonatomic, strong) UISlider *pVolumeSlider;

//视频标题
@property (nonatomic, strong) NSString *videoTitle;

//网络超时时间
@property (nonatomic, assign) NSInteger networkTimeout;

//工具栏界面
@property (nonatomic, strong) UIView *functionView;

/**
 CaiyunVideoViewDelegate
 */
@property (nonatomic, weak) id<CaiyunFileFunctionDelegate> delegate;

/**
 初始化
 fileId: 物理文件ID
 title: 名称
 type: 文件类型
 */
- (id)initWithFileId:(NSString *)fileId title:(NSString *)title fileType:(XBCaiyunFileType)type;

/**
 添加视频播放URL地址
 url：播放地址
 quality：kVIDEO_QUALITY_HIGH/kVIDEO_QUALITY_MEDIUM/kVIDEO_QUALITY_LOW
 */
- (void)setVideoUrl:(NSString *)urlString forQuality:(NSInteger)quality;

/**
 准备播放器
 这一阶段进行播放器的初始化操作，之后可显示播放界面
 */
- (void)prepare;

/**
 切换全屏和窗口模式
 isFullscreen：是否全屏
 */
//- (void)switchFullscreen:(BOOL)isFullscreen;

/**
 切换视频播放质量
 quality:kVIDEO_QUALITY_HIGH/kVIDEO_QUALITY_MEDIUM/kVIDEO_QUALITY_LOW
 info:切换视频时的提示信息
 */
- (void)switchVideoQuality:(NSInteger)quality info:(NSString *)info;

/**
 显示消息窗口
 needPause:是否需要暂停，YES时并且当前播放器正在播放或正在加载数据则暂停播放
 */
- (void)showInfo:(NSString *)msg withPause:(BOOL)needPause;

/**
 关闭消息窗口
 needPlay:是否需要播放，YES表示开始恢复播放
 */
- (void)hideInfoAndPlay:(BOOL)needPlay;

- (BOOL)checkMuted;

//暂停
-(void)doPause;

//点击分享按钮暂停
- (void)doPauseForShare;

/**
 播放完成通知
 
 1. 视频播放结束后，客户端调用了播放器的
 -(void)playbackDidFinish:(NSNotification*)notification
 方法，需要将该方法放到CaiyunVideoViewController.h头文件中。
 */
-(void)playbackDidFinish:(NSNotification*)notification;

/**
 播放器切换到前台
 
 2.彩云客户端有密码锁功能，如果用户打开了该设置，则从程序从后台切换到前台时，客户端会在顶层弹出密码锁，这时，视频播放器不宜继续播放。
 
 所以CaiyunVideoViewController取消直接监听系统前后台切换广播的办法，并增加方法
 -(void)onEnterForeground;
 -(void)onEnterBackground;
 
 客户端相关容器会通过调用上述方法来转发系统前后台切换消息。
 其中，
 监听到切换后台后，会调用onEnterBackground
 切换到前台时，会在密码锁解锁完成后/或者不存在密码锁时，调用onEnterForegroud
 */
-(void)onEnterForeground;

/**
 播放器切换到后台
 */
-(void)onEnterBackground;

-(void)WaitingForGetURLFromCloud;

@end
