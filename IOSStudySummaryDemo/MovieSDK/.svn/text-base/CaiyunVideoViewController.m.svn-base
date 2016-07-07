//
//  CaiyunVideoViewController.m
//  CaiyunPlayer
//
//  Created by Feng  on 13-4-1.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import "CaiyunVideoViewController.h"
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "XBBackBtnView.h"

#define kTagPlayBtn 10000
#define kTagQualityBtn 10001
#define kTagSpeakerBtn 10002
#define kTagShareBtn 10003
#define kTagSaveBtn 10004
#define kTagDeleteBtn 10005
#define kTagDownloadBtn 10006
#define kTagResaveBtn 10007
#define kTagQualityListBtn 10008
#define kTagBackBtn 10009
#define kTagInfoLabel 10010
#define kTagInfoPanel 10011
#define kTagControlViewUserInteractivePart 10012

#define kDragModeNone 0
#define kDragModeHorizontal 1
#define kDragModeVertical 2

#define kDefaultNetworkTimeout 15

@implementation CaiyunVideoViewController
@synthesize fileId = _fileId;
@synthesize videoTitle = _videoTitle;
@synthesize delegate = _delegate;
@synthesize networkTimeout = _networkTimeout;
@synthesize currentState;
@synthesize functionView = _functionView;
@synthesize pCenterPlayBtn = centerPlayBtn;
@synthesize pInfoView = infoView;
@synthesize pQualityListView = qualityListView;
@synthesize pControlView = controlView;
@synthesize pPlayBtnView = playBtnView;
@synthesize pPauseBtnView = pauseBtnView;
@synthesize pPlayerSlider = playerSlider;
@synthesize pTimeLabel = timeLabel;
@synthesize pTotalTimeLabel = totalTimeLabel;
@synthesize pQualityBtnView = qualityBtnView;
@synthesize pQualityArrowView = qualityArrowView;
@synthesize pSpeakerView = speakerView;
@synthesize pVolumeSliderView = volumeSliderView;
@synthesize pVolumeSlider = volumeSlider;

- (void)dealloc
{
//    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange,
//                                                   muteListenerCallback,
//                                                   self);
    [self releasePlayer];
    //恢复音量
//    [[MPMusicPlayerController applicationMusicPlayer] setVolume:initinalValume];
}

- (id)initWithFileId:(NSString *)fileId title:(NSString *)title fileType:(XBCaiyunFileType)type;
{
    if (self = [super init]) {
        self.fileId = fileId;
        self.videoTitle = title;
        fileType = type;
        screenSize = [[UIScreen mainScreen] bounds].size;
        scale = [[UIScreen mainScreen] scale];
        CGFloat tmp = screenSize.height;
        screenSize.height = screenSize.width;
        screenSize.width = tmp;
        isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        currentState = kPlayStateInit;
        _networkTimeout = kDefaultNetworkTimeout;
    }
    return self;
}

- (void)setVideoUrl:(NSString *)urlString forQuality:(NSInteger)quality
{
    switch (quality) {
        case kVIDEO_QUALITY_LOW:
            videoUrlLow = [urlString copy];
            break;
        case kVIDEO_QUALITY_MEDIUM:
            videoUrlMedium = [urlString copy];
            break;
        case kVIDEO_QUALITY_HIGH:
            videoUrlHigh = [urlString copy];
            break;
        case kVIDEO_QUALITY_LOCAL:
            videoUrlLocal = [urlString copy];
            //只要设置了videoUrlLocal，就将fileType设置为kCaiyunFileTypeLocal
            fileType = kCaiyunFileTypeLocal;
            break;
        default:
            break;
    }
}

- (void)prepare
{
    if (activityView != nil)
    {
        [activityView stopAnimating];
        activityView = nil;
    }

    //创建播放器
    NSURL *url = nil;
    if (fileType == kCaiyunFileTypeLocal) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:videoUrlLocal])
        {
            url = [[NSURL alloc] initFileURLWithPath:videoUrlLocal];
        }
        else
        {
            url = [[NSURL alloc] initWithString:videoUrlLocal];
        }
        
        
    } else {
        if (videoUrlMedium) {
            url = [[NSURL alloc] initWithString:videoUrlMedium];
        } else if (videoUrlLow) {
            url = [[NSURL alloc] initWithString:videoUrlLow];
        } else if (videoUrlHigh) {
            url = [[NSURL alloc] initWithString:videoUrlHigh];
        } else {
            //没有设置URL地址，从调用端保证不会出现这种情况
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"common_prompt", nil)
                                            message:NSLocalizedString(@"video_set_network_or_loacl_url", nil)
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"video_know", nil)
                                  otherButtonTitles:nil];
            [alertView show];
        }
    }

    if (url) {
        myPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(playerLoadStateChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:myPlayer];
        [notificationCenter addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:myPlayer];
        [notificationCenter addObserver:self selector:@selector(playbackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:myPlayer];
        [notificationCenter addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        [notificationCenter addObserver:self selector:@selector(movieNaturalSizeAvailable:) name:MPMovieNaturalSizeAvailableNotification object:myPlayer];
        
        /**
         2014-02-24
         取消监听切换前台和后台，由宿主应用决定进入前台和后台
         */
//        [notificationCenter addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [notificationCenter addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
            [notificationCenter addObserver:self selector:@selector(didAudioSessionInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
            [notificationCenter addObserver:self selector:@selector(didAudioSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
        }

        [myPlayer.view setFrame: CGRectMake(0, 0, screenSize.width, screenSize.height)];
        [myPlayer setControlStyle:MPMovieControlStyleNone];
        [myPlayer setScalingMode:MPMovieScalingModeAspectFit];
        [self.view addSubview:myPlayer.view];
        [myPlayer setShouldAutoplay:YES];
        [myPlayer.view setUserInteractionEnabled:NO];
        [myPlayer prepareToPlay];

        [self setupControlView];
        [self showControllView];
        if (activityView == nil)
        {
            activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityView.center = CGPointMake(screenSize.width/2, screenSize.height/2);
            [self.view addSubview:activityView];
        }
        [activityView startAnimating];
//        OSStatus s = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
//                                                     muteListenerCallback,
//                                                     self);
//        if (s != kAudioSessionNoError) {
//            NSLog(@"s != kAudioSessionNoError");
//            AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange,
//                                                           muteListenerCallback,
//                                                           self);
//        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    initinalStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    systemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
    if((systemVersion>=7.0&&autoShowStatusBar)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        if (!initinalStatusBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
    }
}

- (void)releasePlayer
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (myPlayer) {
        [myPlayer.view removeFromSuperview];
//        if ([myPlayer playbackState] != MPMoviePlaybackStateStopped) {
            [myPlayer stop];
//        }
        myPlayer = nil;
    }
}

//设置界面
- (void)setupControlView
{
    //整个控制界面
    self.pControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];

    /**
     标题栏
     */
    CGFloat titleViewHeight = isPad?75.0:44.0;//标题栏高度
    CGFloat titleLabelLeft = isPad?37.5:61;//标题label的x坐标
    CGFloat titleFontSize = isPad?24.0:16.0;//标题字体大小
    CGFloat statusBarHeight = 0;
    if (systemVersion>=7.0&&autoShowStatusBar) {
        if (initinalStatusBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        }
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        if (statusBarHeight==0) {
            statusBarHeight=20.0;
        }
    }
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, screenSize.width, titleViewHeight)];
    titleView.tag = kTagControlViewUserInteractivePart;
    UIColor *color = [[UIColor alloc] initWithRed:0.0 green:0 blue:0 alpha:0.5];//标题栏颜色(RGB 0x000000，透明度50%)
    titleView.backgroundColor = color;
    XBBackBtnView *backBtnView = [[XBBackBtnView alloc] initWithFrame:CGRectMake(0, 0, titleLabelLeft, titleViewHeight) isPad:isPad];
    backBtnView.tag = kTagBackBtn;
    [titleView addSubview:backBtnView];
    backBtnView = nil;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelLeft/2+5, (titleViewHeight - titleFontSize)/2, screenSize.width - titleLabelLeft, titleFontSize)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor= [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:titleFontSize];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    titleLabel.text = _videoTitle;
    [titleView addSubview:titleLabel];
    [controlView addSubview:titleView];
    
    /**
     播放控制条
     */
    CGFloat controlBarViewHeight = isPad?75.0:48.0;//底部控制条整体背景的高度
    CGFloat playBtnLeft = isPad?14.0:18.0;//播放按钮x坐标
    UIView *controlBarView = [[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height - controlBarViewHeight, screenSize.width, controlBarViewHeight)];
    controlBarView.tag = kTagControlViewUserInteractivePart;
    color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    controlBarView.backgroundColor = color;
    //播放按钮
    self.pPlayBtnView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBPlay"]];
    [playBtnView setCenter:CGPointMake(playBtnLeft + playBtnView.frame.size.width/2, controlBarViewHeight/2)];
    playBtnView.tag = kTagPlayBtn;
    playBtnView.hidden = YES;
    playBtnView.userInteractionEnabled = YES;
    [controlBarView addSubview:playBtnView];
    
    self.pPauseBtnView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBPause"]];
    [pauseBtnView setCenter:CGPointMake(playBtnLeft + pauseBtnView.frame.size.width/2, controlBarViewHeight/2)];
    pauseBtnView.tag = kTagPlayBtn;
    pauseBtnView.hidden = NO;
    pauseBtnView.userInteractionEnabled = YES;
    [controlBarView addSubview:pauseBtnView];

    //SLIDE条
    playerSliderWidth = isPad?771.0:283.0 + (screenSize.width-480);//进度条的长度
    CGFloat playerSliderHeight = isPad?7.0:3.5;//进度条内拖动条的高度
    CGFloat playerSliderFrameHeight = isPad?18.5:15.0;//进度条的高度
    CGFloat playerSliderLeft = isPad?65.0:69.0;//进度条x坐标
    UIImage *thumbImage = [self imageNamed:@"XBSlideBtn"];
    self.pPlayerSlider = [[UISlider alloc] initWithFrame:CGRectMake(playerSliderLeft, (controlBarViewHeight - playerSliderFrameHeight)/2, playerSliderWidth, playerSliderFrameHeight)];
    playerSlider.value= 0.0;
    
    //SLIDE条，未播放的进度条
    CGRect rect = CGRectMake(0, 0, playerSliderWidth, playerSliderHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    color = [[UIColor alloc] initWithRed:187.0/255 green:187.0/255 blue:187.0/255 alpha:.5];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context,rect);
    CGContextDrawPath(context, kCGPathFill);
    UIImage *img_bg = UIGraphicsGetImageFromCurrentImageContext();
    //SLIDE条，已播放的进度条
    CGContextClearRect(context, rect);
    color = [[UIColor alloc] initWithRed:199.0/255 green:112.0/255 blue:246.0/255 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context,rect);//画方框
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    UIImage *img_fg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [playerSlider setMinimumTrackImage:img_fg forState:UIControlStateNormal];
    [playerSlider setMaximumTrackImage:img_bg forState:UIControlStateNormal];
    [playerSlider setThumbImage:thumbImage forState:UIControlStateNormal];
//    [playerSlider setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];

    //开始按下滑块，准备拖动时的事件
    [playerSlider addTarget:self action:@selector(willDragSlider:) forControlEvents:UIControlEventTouchDown];
    //滑块拖动时的事件
    [playerSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [playerSlider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [controlBarView addSubview:playerSlider];

    //时间标签
    CGFloat timeLabelFontSize = isPad?15.0:12.0;//时间标签的字体大小
    CGFloat timeLabelLeft = playerSliderLeft+playerSliderWidth-timeLabelFontSize*9;
    self.pTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelLeft, (controlBarViewHeight - playerSliderFrameHeight)/2-timeLabelFontSize, timeLabelFontSize * 4, timeLabelFontSize)];
    timeLabel.font =[UIFont fontWithName:@"Arial" size:timeLabelFontSize];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.text = @"00:00:00";
    [controlBarView addSubview:timeLabel];
    self.pTotalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelLeft+timeLabel.frame.size.width, (controlBarViewHeight - playerSliderFrameHeight)/2-timeLabelFontSize, timeLabelFontSize * 5, timeLabelFontSize)];
    totalTimeLabel.font =[UIFont fontWithName:@"Arial" size:timeLabelFontSize];
    totalTimeLabel.backgroundColor = [UIColor clearColor];
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.text = @"/00:00:00";
    [controlBarView addSubview:totalTimeLabel];
    
    //码流质量按钮
    CGFloat qualityBtnRight = isPad?66.0:60.0;//码流质量按钮右边距右侧距离
    CGFloat qualityBtnWidth = isPad?68.0:42.0;//码流质量按钮宽度
    CGFloat qualityBtnHeight = isPad?35.0:27.5;//码流质量按钮高度
    CGFloat qualityBtnFontSize = isPad?18.0:14.0;//码流质量按钮字体高度
    if (videoUrlMedium != nil || videoUrlLow != nil || videoUrlHigh != nil) {
//        qualityBtnView = [[XBQualityBtnView alloc] initWithFrame:CGRectMake(screenSize.width - qualityBtnWidth - qualityBtnRight, (controlBarViewHeight-qualityBtnHeight)/2, qualityBtnWidth, qualityBtnHeight) isBox:YES forPad:isPad];
        self.pQualityBtnView = [[UILabel alloc]initWithFrame:CGRectMake(screenSize.width - qualityBtnWidth - qualityBtnRight, (controlBarViewHeight-qualityBtnHeight)/2, qualityBtnWidth, qualityBtnHeight)];
        if (videoUrlMedium) {
            qualityBtnView.text = NSLocalizedString(@"video_standard_def", nil);
            currentQuality = kVIDEO_QUALITY_MEDIUM;
        } else if (videoUrlLow) {
            qualityBtnView.text = NSLocalizedString(@"video_fluent", nil);
            currentQuality = kVIDEO_QUALITY_LOW;
        } else if (videoUrlHigh) {
            qualityBtnView.text = NSLocalizedString(@"video_high_def", nil);
            currentQuality = kVIDEO_QUALITY_HIGH;
        } else {
            //没有设置URL地址，从调用端保证不会出现这种情况
        }
        [qualityBtnView setTextColor:[UIColor whiteColor]];
        [qualityBtnView setBackgroundColor:[UIColor clearColor]];
        qualityBtnView.font = [UIFont fontWithName:@"Heiti SC" size:qualityBtnFontSize];
        [qualityBtnView setTag:kTagQualityBtn];
        [qualityBtnView setUserInteractionEnabled:YES];
        [qualityBtnView setTextAlignment:NSTextAlignmentLeft];
        
        UIImage *qualityArrowImage = [self imageNamed:@"XBQualityUp"];
        self.pQualityArrowView = [[UIImageView alloc] initWithImage:qualityArrowImage highlightedImage:[self imageNamed:@"XBQualityDown"]];
        [qualityArrowView setCenter:CGPointMake(qualityBtnFontSize*2+3.0f+[qualityArrowImage size].width/2.0f, qualityBtnHeight/2.0f)];
        [qualityBtnView addSubview:qualityArrowView];
//        [qualityArrowImage release];
        [controlBarView addSubview:qualityBtnView];
    }

    //喇叭
    CGFloat speakerRight = isPad?20.0:13.0;//喇叭按钮x坐标
    UIImage * speakerFullImage = [self imageNamed:@"XBSpeaker-full"];
    self.pSpeakerView = [[XBSpeakerView alloc] initWithFrame:CGRectMake(screenSize.width - speakerFullImage.size.width - speakerRight, (controlBarViewHeight - speakerFullImage.size.height)/2, speakerFullImage.size.width, speakerFullImage.size.height)];
    [speakerView setImage:[self imageNamed:@"XBSpeaker-silent"] ForTag:kSPEAKER_TAG_ZERO];
    [speakerView setImage:[self imageNamed:@"XBSpeaker-low"] ForTag:kSPEAKER_TAG_LOW];
    [speakerView setImage:[self imageNamed:@"XBSpeaker-middle"] ForTag:kSPEAKER_TAG_MIDDLE];
    [speakerView setImage:speakerFullImage ForTag:kSPEAKER_TAG_FULL];
    [speakerView setImage:[self imageNamed:@"XBSpeaker-silent"] ForTag:kSPEAKER_TAG_SILENT];
    speakerView.silent = NO;
//    float volume = 0.0;
//    UInt32 dataSize = sizeof(float);
//    OSStatus status = AudioSessionGetProperty (kAudioSessionProperty_CurrentHardwareOutputVolume,
//                                               &dataSize,
//                                               &volume);
//    if (status == kAudioSessionNoError) {
//        
//    }
    speakerView.volume = initinalValume = [[MPMusicPlayerController applicationMusicPlayer] volume];
//    [[MPMusicPlayerController applicationMusicPlayer] setVolume:volume];
    speakerView.tag = kTagSpeakerBtn;
    [controlBarView addSubview:speakerView];

    //添加controlBarView到controlView
    [controlView addSubview:controlBarView];

    //音量滑动条
    volumeSliderWidth = isPad?354.5:154.5;//音量滑动条长度
    CGFloat volumeSliderHeight = isPad?5.5:3.5;//音量滑动条高度
    CGFloat volumeSliderRight = isPad?52.5:40.5;//音量滑动条x坐标
    CGFloat volumeSliderTop = isPad?306.5:91;//音量滑动条y坐标
    CGFloat volumeSliderFrameWidth = isPad?380:171;//音量滑动条背景长度
    CGFloat volumeSliderFrameHeight = isPad?35.5:30.5;//音量滑动条背景高度
    rect = CGRectMake(0, 0, volumeSliderWidth, volumeSliderHeight);
    UIGraphicsBeginImageContext(rect.size);
    context = UIGraphicsGetCurrentContext();

    color = [[UIColor alloc] initWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextAddRect(context,rect);//画方框
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    UIImage *img_bg_volume = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClearRect(context, rect);
    color = [[UIColor alloc] initWithRed:199.0/255 green:112.0/255 blue:246.0/255 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextAddRect(context,rect);//画方框
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    UIImage *img_fg_volume = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.pVolumeSliderView = [[UIView alloc]initWithFrame:CGRectMake(screenSize.width - volumeSliderRight -volumeSliderFrameWidth/2+volumeSliderFrameHeight/2, volumeSliderTop+volumeSliderFrameWidth/2-volumeSliderFrameHeight/2, volumeSliderFrameWidth, volumeSliderFrameHeight)];
    color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    volumeSliderView.backgroundColor = color;

    self.pVolumeSlider = [[UISlider alloc] init];
    volumeSlider.frame = CGRectMake(10, 0, volumeSliderFrameWidth-20, volumeSliderFrameHeight);
    volumeSlider.value = speakerView.volume;
    volumeSlider.minimumValue = 0.0;
    volumeSlider.maximumValue = 1.0;
    [volumeSlider setMinimumTrackImage:img_fg_volume forState:UIControlStateNormal];
    [volumeSlider setMaximumTrackImage:img_bg_volume forState:UIControlStateNormal];
    [volumeSlider setThumbImage:[self imageNamed:@"XBSoundSlideBtn"] forState:UIControlStateNormal];

    //开始按下滑块，准备拖动时的事件
    [volumeSlider addTarget:self action:@selector(willDragSlider:) forControlEvents:UIControlEventTouchDown];
    //滑块拖动时的事件
    [volumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [volumeSlider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];

    [volumeSliderView addSubview:volumeSlider];
    volumeSliderView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [controlView addSubview:volumeSliderView];
    volumeSliderView.hidden = YES;
    
    //视频质量列表
    if (fileType == kCaiyunFileTypeNormal || fileType == kCaiyunFileTypeShare) {
        CGFloat qualityListBottomMargin = 10.0;//视频质量列表按钮底部距离控制栏
        NSInteger qualityCount = 0;
        CGFloat padding = 15.0;
        qualityBtnWidth = qualityBtnFontSize*2+4.0;
        self.pQualityListView = [[UIView alloc] init];
        XBQualityBtnView *qualityBtn;
        if (videoUrlHigh) {
            qualityBtn = [[XBQualityBtnView alloc] initWithFrame:CGRectMake(padding, padding, qualityBtnWidth, qualityBtnHeight) isBox:NO forPad:isPad];
            qualityBtn.fontSize = qualityBtnFontSize;
            qualityBtn.title = NSLocalizedString(@"video_high_def", nil);
            qualityBtn.pressed = NO;
            qualityBtn.quality = kVIDEO_QUALITY_HIGH;
            qualityBtn.tag = kTagQualityListBtn;
            [qualityListView addSubview:qualityBtn];
             qualityCount++;
        }
        if (videoUrlMedium) {
            qualityBtn = [[XBQualityBtnView alloc] initWithFrame:CGRectMake(padding, padding + (padding + qualityBtnHeight) * qualityCount, qualityBtnWidth, qualityBtnHeight) isBox:NO forPad:isPad];
            qualityBtn.fontSize = qualityBtnFontSize;
            qualityBtn.title = NSLocalizedString(@"video_standard_def", nil);
            qualityBtn.pressed = NO;
            qualityBtn.quality = kVIDEO_QUALITY_MEDIUM;
            qualityBtn.tag = kTagQualityListBtn;
            [qualityListView addSubview:qualityBtn];
            qualityCount++;
        }
        if (videoUrlLow) {
            qualityBtn = [[XBQualityBtnView alloc] initWithFrame:CGRectMake(padding, padding + (padding + qualityBtnHeight) * qualityCount, qualityBtnWidth, qualityBtnHeight) isBox:NO forPad:isPad];
            qualityBtn.fontSize = qualityBtnFontSize;
            qualityBtn.title = NSLocalizedString(@"video_fluent", nil);
            qualityBtn.pressed = NO;
            qualityBtn.quality = kVIDEO_QUALITY_LOW;
            qualityBtn.tag = kTagQualityListBtn;
            [qualityListView addSubview:qualityBtn];
            qualityCount++;
        }
        CGFloat rh = padding + (padding + qualityBtnHeight) * qualityCount;
        rect = CGRectMake(screenSize.width-117.0, screenSize.height - controlBarViewHeight - qualityListBottomMargin - rh, qualityBtnWidth+padding*2, rh);
        qualityListView.frame = rect;
        color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        qualityListView.backgroundColor = color;
        [controlView addSubview:qualityListView];
        qualityListView.hidden = YES;
        [self selectQuality:currentQuality];
    }
    
    //工具条界面
    if (_functionView) {
        if (![controlView isEqual:[_functionView superview]]) {
            [_functionView removeFromSuperview];
            [controlView addSubview:_functionView];
            //这里自动定位到右侧对齐、垂直居中的位置
            [_functionView setCenter:CGPointMake(controlView.frame.size.width-_functionView.bounds.size.width/2,controlView.frame.size.height/2)];
        }
    }
    //将整个控制界面添加到播放界面中
    [self.view addSubview:controlView];

    //消息通知界面
    CGFloat infoViewFontSize = 12.0;
    UIImage *infoViewBgImage = [self imageNamed:@"XBInfobg"];
    self.pInfoView = [[UIImageView alloc] initWithImage:infoViewBgImage];
    [infoView setCenter:CGPointMake(screenSize.width/2, screenSize.height/2)];
    infoView.tag = kTagInfoPanel;
    UILabel *label = [[UILabel alloc]initWithFrame:infoView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor= [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Heiti SC" size:infoViewFontSize];
    label.text = NSLocalizedString(@"video_info", nil);
    label.tag = kTagInfoLabel;
    [infoView addSubview:label];
    infoView.hidden = YES;
    
    [self.view addSubview:infoView];
    
    //播放暂停时位于屏幕中央的播放按钮
    UIImage *centerPlayImage = [self imageNamed:@"XBCenterPlayBtn"];
    self.pCenterPlayBtn = [[UIImageView alloc] initWithImage:centerPlayImage];
    [centerPlayBtn setTag:kTagPlayBtn];
    [centerPlayBtn setCenter:CGPointMake(screenSize.width/2, screenSize.height/2)];
    [centerPlayBtn setHidden:YES];
    [centerPlayBtn setUserInteractionEnabled:YES];
    [self.view addSubview:centerPlayBtn];
}

- (void)selectQuality:(XBCaiyunVideoQuality)quality
{
    for (XBQualityBtnView *view in [qualityListView subviews]) {
        if ([view quality]==quality) {
            [view setPressed:YES];
        } else {
            [view setPressed:NO];
        }
        [view setNeedsDisplay];
    }
}

#pragma mark ----notification
- (BOOL)checkMuted
{
    CFStringRef route;
    UInt32 routeSize = sizeof(CFStringRef);
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &routeSize, &route);
    if (status == kAudioSessionNoError)
    {
        if (route == NULL || !CFStringGetLength(route)) {
            isMuted = YES;
            beforeMutedValume = [volumeSlider value];
            speakerView.volume = 0;
            volumeSlider.value = 0;
            [self sliderValueChanged:volumeSlider];
            return YES;
        } else {
            isMuted = NO;
            speakerView.volume = beforeMutedValume;
            volumeSlider.value = beforeMutedValume;
            [self sliderValueChanged:volumeSlider];
        }
    }
    return NO;
}

void muteListenerCallback(void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize, const void *inPropertyValue)
{
    if (inPropertyID == kAudioSessionProperty_AudioRouteChange) {
        CaiyunVideoViewController * controller = (__bridge CaiyunVideoViewController *)inUserData;
        [controller checkMuted];
    }
}

- (void)didAudioSessionInterrupted:(NSNotification *)notification
{
    //AVAudioSessionInterruptionNotification
    NSDictionary *info = [notification userInfo];
    NSNumber *type = [info objectForKey:AVAudioSessionInterruptionTypeKey];
    if (type) {
        if ([type integerValue] == AVAudioSessionInterruptionTypeBegan) {
            //the app’s audio session has been interrupted and is no longer active
        } else {
            NSNumber *option = [info objectForKey:AVAudioSessionInterruptionOptionKey];
            if (option) {
                if ([option integerValue] == AVAudioSessionInterruptionOptionShouldResume) {
                }
            }
        }
    }
}

- (void)didAudioSessionRouteChange:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    if (info) {
        AVAudioSessionRouteChangeReason changeReason = [[info objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        if (changeReason == AVAudioSessionRouteChangeReasonUnknown) {//0
        } else if (changeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {//1
            currentHeadphoneEvent = kHeadphoneEventPlug;
            if (currentState == kPlayStatePausedUnplugHeadphone) {
                currentState = kPlayStatePlaying;
                [self hideInfoAndPlay:YES];
            }
        } else if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {//2
            currentHeadphoneEvent = kHeadphoneEventUnplug;
        }
    }
}

/**
 播放器切换到前台
 */
-(void)onEnterForeground
{
    if (currentState != kPlayStatePausedUser && currentState != kPlayStateCompletedNormal
        && currentState !=kPlayStatePausedSystem)
    {
        if (myPlayer) {
            [myPlayer play];
        }
    }
}

/**
 播放器切换到后台
 */
-(void)onEnterBackground
{
    if (currentState != kPlayStatePausedUser && currentState != kPlayStateCompletedNormal) {
        if (myPlayer) {
            [myPlayer pause];
        }
    }
}

/**
 2014-02-26
 didBecomeActive和willResignActive被onEnterForeground、onEnterBackground替代
 由宿主应用调用，设置切换到前台或后台操作
 */
//- (void)didBecomeActive:(NSNotification *)notification
//{
////    NSLog(@"didBecomeActive, currentState=%d, player:%d", currentState, [myPlayer playbackState]);
//    if (currentState != kPlayStateUserPaused && currentState != kPlayStateCompletedNormal) {
//        if (myPlayer) {
//            [myPlayer play];
//        }
//    }
////    else if (currentState == kPlayStateCompletedNormal) {
////        myPlayer.currentPlaybackTime = playerSlider.value/10.0f;
////        [myPlayer pause];
////        NSLog(@"didBecomeActive no");
////    }
//}
//
//- (void)willResignActive:(NSNotification *)notification
//{
//    if (currentState != kPlayStateUserPaused && currentState != kPlayStateCompletedNormal) {
//        if (myPlayer) {
//            [myPlayer pause];
//        }
//    }
//}

- (void)didNetworkTimeout
{
    if (stalledTimer) {
        [stalledTimer invalidate];
        stalledTimer = nil;
    }
    [activityView stopAnimating];
    [self showInfo:NSLocalizedString(@"video_network_may_interrupt", nil) withPause:YES];
}

//视频播放状态改变，获取视频信息
- (void)playerLoadStateChange:(NSNotification *)notification
{
    if (stalledTimer) {
        [stalledTimer invalidate];
        stalledTimer = nil;
    }
    MPMovieLoadState state = myPlayer.loadState;
    if (currentState == kPlayStateInit) {
        if ((state & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable || (state & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK) {
            MPMoviePlayerController *movieController = [notification object];
            int currentTime = playerSlider.maximumValue = round(movieController.duration*10);
            int hour = currentTime / 36000;
            int minu = (currentTime % 36000)/600;
            int second = roundf((currentTime % 600)/10.0f);
            totalTimeLabel.text = [NSString stringWithFormat:@"/%02d:%02d:%02d", hour, minu, second];
            if (playerTimer) {
                [playerTimer invalidate];
                playerTimer = nil;
            }
            playerTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onPlayerPlay) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:playerTimer forMode:NSDefaultRunLoopMode];
            currentState = kPlayStatePlaying;
        } else if ((state & MPMovieLoadStateStalled) == MPMovieLoadStateStalled) {
            stalledTimer = [NSTimer timerWithTimeInterval:_networkTimeout target:self selector:@selector(didNetworkTimeout) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:stalledTimer forMode:NSDefaultRunLoopMode];
        } else {
            //do nothing
        }
    } else {
        if ((state & MPMovieLoadStateStalled) == MPMovieLoadStateStalled) {
            stalledTimer = [NSTimer timerWithTimeInterval:_networkTimeout target:self selector:@selector(didNetworkTimeout) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:stalledTimer forMode:NSDefaultRunLoopMode];
            currentState = kPlayStateLoading;
        } else if ((state & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK) {
            if (currentState == kPlayStatePausedSystem || currentState == kPlayStateLoading) {
                [myPlayer play];
            }
            currentState = kPlayStatePlaying;
        }
    }
}

//暂停播放触发的通知
-(void)playbackStateChange:(NSNotification*)notification
{
    if (myPlayer.playbackState == MPMoviePlaybackStatePaused) {
        playBtnView.hidden = NO;
        pauseBtnView.hidden = YES;
        if (currentHeadphoneEvent == kHeadphoneEventUnplug) {
            currentState = kPlayStatePausedUnplugHeadphone;
            //检测到您拔掉了耳机，播放已暂停
           // [self showInfo:NSLocalizedString(@"video_play_pause", nil) withPause:NO];
 		 [centerPlayBtn setHidden:NO]; 
         	  currentHeadphoneEvent = kHeadphoneEventNone;
        } else {
            if (currentState != kPlayStatePausedUser && currentState != kPlayStatePausedSystem
                && currentState!=kPlayStateCompletedNormal) {
                
                [self hideInfoAndPlay:NO];
                [activityView startAnimating];
                if (currentState != kPlayStateInit)
                {
                    currentState = kPlayStateLoading;
                }
            } else if (currentState == kPlayStateInterrupted) {
                [myPlayer play];
            }
        }
    } else {
  	if (currentState==kPlayStateCompletedNormal) {
           	 playBtnView.hidden = NO;
           	 pauseBtnView.hidden = YES;
           	 [centerPlayBtn setHidden:NO];
//            currentState = kPlayStatePausedSystem;
           	 [activityView stopAnimating];
        } else {   
    		playBtnView.hidden = YES;
      	  	pauseBtnView.hidden = NO;
        	if (currentState != kPlayStateInit)
        	{
            		currentState = kPlayStatePlaying;
        	}
        	[self hideInfoAndPlay:NO];
        	[activityView stopAnimating];
	}
    }
}

//视频播放结束时候通知
-(void)playbackDidFinish:(NSNotification*)notification
{
    if (playerTimer) {
        [playerTimer invalidate];
        playerTimer = nil;
        if (playerSlider.value != roundf(myPlayer.currentPlaybackTime*10.0f)) {
            [self onPlayerPlay];
        }
    }
    NSInteger reasonValue = 0;
    if (notification) {
        NSNumber *reason = [notification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        NSString *message = nil;
        switch ([reason intValue]) {
            case MPMovieFinishReasonPlaybackEnded:
                
                /**
                 修改前（2014-10-08，修改需求：播放完成后，将视频置为暂停状态，位于开头）
                 reasonValue = kPlayCompletedStateNormal;
                 currentState = kPlayStateCompletedNormal;
                 message = NSLocalizedString(@"video_play_finish", nil);
                 */
                /*以下为2014-10-08修改后*/
                currentState = kPlayStateCompletedNormal;
                timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", 0, 0, 0];
                playerSlider.value = 0.0f;
                [centerPlayBtn setHidden:NO];
                [myPlayer setCurrentPlaybackTime:0];
                break;
            case MPMovieFinishReasonPlaybackError:
                reasonValue = kPlayCompletedStateUrlError;
                currentState = kPlayStateCompletedError;
                if (fileType==kCaiyunFileTypeLocal||videoUrlLocal) {
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:videoUrlLocal]) {
                        message = NSLocalizedString(@"video_do_not_support_or_file_damaged", nil);
                    } else {
                        message = NSLocalizedString(@"video_file_did_not_exist", nil);
                    }
                } else {
                    message = NSLocalizedString(@"video_error_for_url_or_network", nil);
                }
                [myPlayer.view setBackgroundColor:[UIColor grayColor]];
                break;
            case MPMovieFinishReasonUserExited:
                reasonValue = kPlayCompletedStateUserClose;
                currentState = kPlayStateCompletedNormal;
                message = nil;
                break;
            default:
                reasonValue = kPlayCompletedStateNetworkError;
                currentState = kPlayStateCompletedError;
                message = NSLocalizedString(@"video_unavailable_network", nil);
                break;
        }
        if (message) {
            [self showInfo:message withPause:NO];
        }
    } else {
        currentState = kPlayStateCompletedNormal;
        //点击左上角返回按钮，reasonValue设置为kPlayCompletedStateUserClose
        [self releasePlayer];
        reasonValue = kPlayCompletedStateUserClose;
        [[UIApplication sharedApplication] setStatusBarHidden:initinalStatusBarHidden withAnimation:UIStatusBarAnimationNone];
    }
    [activityView stopAnimating];
    if (_delegate && [_delegate respondsToSelector:@selector(didMediaPlayCompleted:withState:)]) {
        [_delegate didMediaPlayCompleted:self.fileId withState:reasonValue];
    }
}

//用户通过手机按键调节音量
-(void)volumeChanged:(NSNotification *)notification
{
    CGFloat volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    speakerView.volume = volume;
    volumeSlider.value = volume;
}

//从外部调用切换码流
- (void)switchVideoQuality:(NSInteger)quality info:(NSString *)info
{
    if (quality != currentQuality) {
        currentQuality = quality;
        [self selectQuality:currentQuality];
        NSURL *url;
        if (quality == kVIDEO_QUALITY_LOW) {
            qualityBtnView.text = NSLocalizedString(@"video_fluent", nil);
            url = [[NSURL alloc] initWithString:videoUrlLow];
        } else if (quality == kVIDEO_QUALITY_MEDIUM) {
            qualityBtnView.text = NSLocalizedString(@"video_standard_def", nil);
            url = [[NSURL alloc] initWithString:videoUrlMedium];
        } else {
            qualityBtnView.text = NSLocalizedString(@"video_high_def", nil);
            url = [[NSURL alloc] initWithString:videoUrlHigh];
        }
        NSTimeInterval currentPlayTime = myPlayer.currentPlaybackTime;
        [myPlayer setContentURL:url];
        [myPlayer prepareToPlay];
        [myPlayer setCurrentPlaybackTime:currentPlayTime];
    }
}

//每隔1秒刷新播放状态
- (void)onPlayerPlay
{
    int currentTime = roundf(myPlayer.currentPlaybackTime*10.0f);
    if (currentTime > 0) {
        int hour = currentTime / 36000;
        int minu = (currentTime % 36000)/600;
        int second = roundf((currentTime % 600)/10.0f);
        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minu, second];
        playerSlider.value = currentTime;
    }
}

- (void)movieNaturalSizeAvailable:(NSNotification *)notification
{
    //do nothing
//    NSLog(@"movieNaturalSizeAvailable:%@, naturalSize:%@", notification, NSStringFromCGSize([myPlayer naturalSize]));
}

#pragma mark ----UISlider Action
- (void)willDragSlider:(id)sender
{
    [self autoHiddenControllView:NO];
}

- (void)sliderValueChanged:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    if ([slider isEqual:volumeSlider]) {
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:slider.value];
        [speakerView setVolume:slider.value];
    } else {
        if (currentState == kPlayStateCompletedError) {
            return;
        } else if (currentState == kPlayStateCompletedNormal) {
            currentState = kPlayStatePausedDrag;
        }
        if (playerTimer) {
            [playerTimer invalidate];
            [myPlayer pause];
            playerTimer = nil;
            currentState = kPlayStatePausedDrag;
        }
        int currentTime = playerSlider.value;
        int hour = currentTime / 36000;
        int minu = (currentTime % 36000)/600;
        int second = roundf((currentTime % 600)/10.0f);
        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minu, second];
    }
}

- (void)sliderDragUp:(id)sender
{
    [self autoHiddenControllView:YES];
    UISlider *slider = (UISlider *)sender;
    if ([slider isEqual:playerSlider]) {
        if (currentState == kPlayStateCompletedError || currentState == kPlayStateInit) {
            playerSlider.value = 0.0f;
            return;
        } else if (currentState == kPlayStateCompletedNormal) {
            return;
        }
        myPlayer.currentPlaybackTime = playerSlider.value/10.0f;
        [myPlayer play];
        playerTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onPlayerPlay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:playerTimer forMode:NSDefaultRunLoopMode];
    }
}

/**
 隐藏控制条
 */
- (void)hiddenControllView
{
    if (!volumeSliderView.hidden) {
        volumeSliderView.hidden = YES;
        if(_functionView)_functionView.hidden = NO;
    }
    if (!qualityListView.hidden) {
        qualityListView.hidden = YES;
        [qualityArrowView setHighlighted:NO];
    }
    controlView.hidden = YES;
    [self autoHiddenControllView:NO];
    if(systemVersion>=7.0&&autoShowStatusBar)[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

/**
 显示控制条
 */
- (void)showControllView
{
    if (_functionView&&_functionView.hidden) {
        _functionView.hidden = NO;
    }
    controlView.hidden = NO;
    [self autoHiddenControllView:YES];
    if(systemVersion>=7.0&&autoShowStatusBar)[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

/**
 是否自动隐藏控制条
 */
- (void)autoHiddenControllView:(BOOL)canAutoHide
{
    if (hiddenTimer) {
        [hiddenTimer invalidate];
        hiddenTimer = nil;
    }
    if (canAutoHide) {
        hiddenTimer = [NSTimer timerWithTimeInterval:autoHiddenTimeout target:self selector:@selector(hiddenControllView) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:hiddenTimer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark ----TouchMethods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] >= 1) {
        UITouch * touch = [[touches allObjects] objectAtIndex:0];
        if ([touch.view respondsToSelector:@selector(setHighlighted:)]) {
            ((UIImageView *)touch.view).highlighted = YES;
        }
    }
    startPoint = [[touches anyObject] locationInView:self.view];
    dragMode = kDragModeNone;
    pausedForDrag = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (currentState == kPlayStateCompletedNormal || currentState == kPlayStateCompletedError) {
        return;
    }
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    //规避6s和6s plus 坐标没变触发touchesMoved
    if(abs((int)(point.x - startPoint.x)) == 0 &&  abs((int)(point.y - startPoint.y)) == 0)
        return;

    if (dragMode == kDragModeHorizontal) {
        //水平拖动，调节播放进度
        CGFloat newValue = (point.x - startPoint.x)*playerSlider.maximumValue/playerSliderWidth + startSliderValue;
        if (newValue < 0) {
            newValue = 0;
        } else if (newValue > playerSlider.maximumValue) {
            newValue = playerSlider.maximumValue;
        }
        playerSlider.value = newValue;
        [self sliderValueChanged:playerSlider];
    } else if (dragMode == kDragModeVertical) {
        //垂直拖动，调节音量
        CGFloat newValue = (startPoint.y - point.y)*volumeSlider.maximumValue/volumeSliderWidth + startSliderValue;
        if (newValue < 0) {
            newValue = 0;
        } else if (newValue > volumeSlider.maximumValue) {
            newValue = volumeSlider.maximumValue;
        }
        volumeSlider.value = newValue;
        [self sliderValueChanged:volumeSlider];
    } else {
        //确定开始拖动
        dragMode = abs((int)(point.x - startPoint.x)) > abs((int)(point.y - startPoint.y)) ? kDragModeHorizontal : kDragModeVertical;
        if (controlView.hidden) {
            controlView.hidden = NO;
        }

        if (dragMode == kDragModeVertical) {
            if (!qualityListView.hidden) {
                qualityListView.hidden = YES;
                [qualityArrowView setHighlighted:NO];
            }
            if (volumeSliderView.hidden) {
                volumeSliderView.hidden = NO;
                if (_functionView&&!_functionView.hidden) {
                    _functionView.hidden = YES;
                }
            }
            startSliderValue = volumeSlider.value;
        } else if (dragMode == kDragModeHorizontal) {
            if (!qualityListView.hidden) {
                qualityListView.hidden = YES;
                [qualityArrowView setHighlighted:NO];
            }
            if (!volumeSliderView.hidden) {
                volumeSliderView.hidden = YES;
                if(_functionView)_functionView.hidden = NO;
            }
            startSliderValue = playerSlider.value;
            if (!pausedForDrag) {
                pausedForDrag = YES;
                [myPlayer pause];
            }
        }
        [self autoHiddenControllView:NO];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (dragMode != kDragModeNone) {
        [self sliderDragUp: dragMode==kDragModeHorizontal ? playerSlider : volumeSlider];
        pausedForDrag = NO;
        dragMode = kDragModeNone;
        return;
    }
    if ([touches count] >= 1) {
        UITouch * touch = [[touches allObjects] objectAtIndex:0];
        if ([touch.view respondsToSelector:@selector(setHighlighted:)]) {
            ((UIImageView *)touch.view).highlighted = NO;
        }
        NSInteger viewTag = touch.view.tag;
        if (viewTag >= kTagPlayBtn) {
            [self autoHiddenControllView:YES];
        }
        switch (viewTag) {
            case kTagPlayBtn:
                if (currentState == kPlayStatePlaying) {
                    currentState = kPlayStatePausedUser;
                    [myPlayer pause];
                   // [self showInfo:NSLocalizedString(@"video_play_pause", nil) withPause:NO];
                    [centerPlayBtn setHidden:NO];                } else {
                    if (currentState == kPlayStatePausedUser || currentState == kPlayStatePausedSystem || currentState == kPlayStatePausedUnplugHeadphone) {
                        currentState = kPlayStatePlaying;
                        [self hideInfoAndPlay:YES];
                    } else if (currentState == kPlayStateCompletedNormal) {
                        currentState = kPlayStatePlaying;
                        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", 0, 0, 0];
                        playerSlider.value = 0.0f;
                        [self hideInfoAndPlay:YES];
                        playerTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onPlayerPlay) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:playerTimer forMode:NSDefaultRunLoopMode];
                    } else if (currentState == kPlayStateInterrupted) {
                        currentState = kPlayStatePlaying;
                        [self hideInfoAndPlay:YES];
                    }
                }
                break;
            case kTagQualityBtn:
                if (qualityListView.hidden) {
                    qualityListView.hidden = NO;
                    [qualityArrowView setHighlighted:YES];
                    if (!volumeSliderView.hidden) {
                        volumeSliderView.hidden = YES;
                    }
                    if (_functionView&&!_functionView.hidden) {
                        _functionView.hidden = YES;
                    }
                } else {
                    qualityListView.hidden = YES;
                    [qualityArrowView setHighlighted:NO];
                    if (_functionView&&_functionView.hidden) {
                        _functionView.hidden = NO;
                    }
                }
                break;
            case kTagSpeakerBtn:
                if (volumeSliderView.hidden) {
                    volumeSliderView.hidden = NO;
                    if (_functionView&&!_functionView.hidden) {
                        _functionView.hidden = YES;
                    }
                    if (!qualityListView.hidden) {
                        qualityListView.hidden = YES;
                    }
                } else {
                    volumeSliderView.hidden = YES;
                    if (_functionView&&_functionView.hidden) {
                        _functionView.hidden = NO;
                    }
                }
                break;
            case kTagQualityListBtn:
                qualityListView.hidden = YES;
                if (_functionView&&_functionView.hidden) {
                    _functionView.hidden = NO;
                }
                [qualityArrowView setHighlighted:NO];
                NSInteger quality = [(XBQualityBtnView *)touch.view quality];
                if (quality != currentQuality) {
                    currentQuality = quality;
                    [self selectQuality:currentQuality];
                    NSTimeInterval currentPlayTime = myPlayer.currentPlaybackTime;
                    NSURL *url;
                    if (quality == kVIDEO_QUALITY_LOW) {
                        qualityBtnView.text = NSLocalizedString(@"video_fluent", nil);
                        url = [[NSURL alloc] initWithString:videoUrlLow];
                    } else if (quality == kVIDEO_QUALITY_MEDIUM) {
                        qualityBtnView.text = NSLocalizedString(@"video_standard_def", nil);
                        url = [[NSURL alloc] initWithString:videoUrlMedium];
                    } else {
                        qualityBtnView.text = NSLocalizedString(@"video_high_def", nil);
                        url = [[NSURL alloc] initWithString:videoUrlHigh];
                    }
                    if (currentState == kPlayStateCompletedNormal) {
                        [myPlayer stop];
                        currentState = kPlayStatePlaying;
                        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", 0, 0, 0];
                        playerSlider.value = currentPlayTime = 0;
                        [self hideInfoAndPlay:NO];
                    }
                    [myPlayer setContentURL:url];
                    if (currentPlayTime) {
                        [myPlayer setInitialPlaybackTime:currentPlayTime];
                    }
                    [myPlayer play];
                    if (!playerTimer) {
                        playerTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onPlayerPlay) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:playerTimer forMode:NSDefaultRunLoopMode];
                    }

                }
                break;
            case kTagBackBtn:
                [self playbackDidFinish:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                }];
                break;
            default:
                if (viewTag == 0) {
                    if (controlView.hidden) {
                        [self showControllView];
                    } else {
                        [self hiddenControllView];
                    }
                }
                break;
        }
    }
}

#pragma mark ------Tools
- (UIImage *)imageNamed:(NSString *)name
{
    if (isPad) {
        return [UIImage imageNamed:[name stringByAppendingString:@"-iPad"]];
    } else {
        return [UIImage imageNamed:name];
    }
}

- (void)showInfo:(NSString *)msg withPause:(BOOL)needPause
{
    UILabel *infoLabel = (UILabel*)[infoView viewWithTag:kTagInfoLabel];
    infoLabel.text = msg;
    infoView.hidden = NO;
    if (needPause && (currentState == kPlayStatePlaying || currentState == kPlayStateLoading)) {
        [myPlayer pause];
        currentState = kPlayStatePausedSystem;
    }
}

- (void)hideInfoAndPlay:(BOOL)needPlay
{
    [infoView setHidden:YES];
    [centerPlayBtn setHidden:YES];
    if (needPlay && myPlayer) {
        [myPlayer play];
    }
}

- (void)doPause
{
   if (currentState != kPlayStateCompletedNormal && currentState != kPlayStateCompletedError) {
        [centerPlayBtn setHidden:NO];
        if (currentState == kPlayStatePlaying || currentState == kPlayStateLoading) {
            [myPlayer pause];
            currentState = kPlayStatePausedSystem;
        }
    }
}

- (void)doPauseForShare
{
    if(self.currentState != kPlayStateCompletedNormal)
    {
        if(self.currentState != kPlayStateInit)
        {
            [centerPlayBtn setHidden:NO];
            self.currentState = kPlayStatePausedSystem;
            [myPlayer pause];
        }
       
        //[self showInfo:NSLocalizedString(@"video_play_pause", nil) withPause:YES];
    }
}

- (void)setFunctionView:(UIView *)functionView
{
    if (_functionView) {
        if ([_functionView isEqual:functionView]) {
            return;
        }
        [_functionView removeFromSuperview];
    }
    _functionView = functionView;
    if (_functionView&&controlView) {
        [controlView addSubview:_functionView];
        //这里自动定位到右侧对齐、垂直居中的位置
        [_functionView setCenter:CGPointMake(controlView.frame.size.width-_functionView.bounds.size.width/2,controlView.frame.size.height/2)];
    }
}

#pragma mark ---- 系统通用功能 ----
/**
 屏幕方向 >=6.0
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

/**
 屏幕方向 <6.0
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/**
 内存预警
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    [self releasePlayer];
    if (_delegate) {
        [_delegate didReceiveMemoryWarning:self];
    }
}

-(void)WaitingForGetURLFromCloud
{
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [bg setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bg];
    [self setupControlView];
    controlView.hidden = NO;
    
    if (activityView == nil)
    {
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = CGPointMake(screenSize.width/2, screenSize.height/2);
        [self.view addSubview:activityView];
    }
    [activityView startAnimating];
}

@end
