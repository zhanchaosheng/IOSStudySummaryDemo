//
//  CaiyunMusicViewController.m
//  CaiyunPlayer
//
//  Created by youcan on 13-11-29.
//  Copyright (c) 2013年 mac . All rights reserved.
//

#import "CaiyunMusicViewController.h"

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
#define kTagPrevBtn 10010
#define kTagNextBtn 10011
#define kTagHandlerBtn 10012
#define kTagOpenBtn 10013
#define kTagSoundMinus 10014
#define kTagSoundPlus 10015

#define kDragModeNone 0
#define kDragModeHorizontal 1
#define kDragModeVertical 2

@interface CaiyunMusicViewController ()

@end

@implementation CaiyunMusicViewController

- (void)dealloc
{
}

- (id)initWithFame:(CGRect)frame
{
    self = [super init];
    if (self) {
        scale = [[UIScreen mainScreen] scale];
        CGSize statusBarFrameSize = [[UIApplication sharedApplication] statusBarFrame].size;
        CGFloat statusBarHeight = MIN(statusBarFrameSize.width, statusBarFrameSize.height);
        isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        if (isPad) {
            screenSize = frame.size;
        } else {
            screenSize = [[UIScreen mainScreen] bounds].size;
            screenSize.height = screenSize.height - statusBarHeight;
        }
        NSLog(@"frame=%@", NSStringFromCGRect(frame));
        NSLog(@"screenSize=%@", NSStringFromCGSize(screenSize));
        UIView *view = [[UIView alloc]initWithFrame:frame];
        self.view = view;
        self.view.tag = XBTagMusicPlayerMainView;
        [self setupControlView];
    }
    return self;
}

//设置界面
- (void)setupControlView
{
    /**
     背景
     */
    UIImageView *mainView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicMainBg"]];
    [self.view addSubview:mainView];
    
    /**
     标题栏
     */
    CGFloat titleViewHeight = isPad?42.0:42.0;//标题栏高度
    CGFloat backBtnLeft = isPad?10.5:10.5;//返回按钮x坐标
    CGFloat titleFontSize = isPad?18.0:16.0;//标题字体大小
    CGFloat backLabelFontSize = 12.0;//iPad，关闭、打开方式的字体大小
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicTopBg"]];
    titleView.userInteractionEnabled = YES;
//    UIColor *color = [[UIColor alloc] initWithRed:86.0/255 green:26.0/255 blue:180.0/255 alpha:1.0];
//    titleView.backgroundColor = color;
//    [color release];
    UIImageView *backBtnView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicBack"]];
    backBtnView.userInteractionEnabled = YES;
    backBtnView.tag = kTagBackBtn;
    [backBtnView setCenter:CGPointMake(backBtnLeft + backBtnView.frame.size.width/2, titleViewHeight/2)];
    if (isPad) {
        UILabel *backLabel = [[UILabel alloc] initWithFrame:backBtnView.bounds];
        backLabel.backgroundColor = [UIColor clearColor];
        backLabel.textColor= [UIColor whiteColor];
        backLabel.textAlignment = NSTextAlignmentCenter;
        backLabel.font = [UIFont fontWithName:@"Heiti SC" size:backLabelFontSize];
        backLabel.text = NSLocalizedString(@"common_back", nil);
        backLabel.tag = kTagBackBtn;
        backLabel.userInteractionEnabled = YES;
        [backBtnView addSubview:backLabel];
    }
    [titleView addSubview:backBtnView];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (titleViewHeight - titleFontSize)/2, screenSize.width, titleFontSize)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor= [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:titleFontSize];
    [titleView addSubview:titleLabel];
    UIImageView *openBtnView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicOpen"]];
    [openBtnView setCenter:CGPointMake(screenSize.width - backBtnLeft - openBtnView.bounds.size.width/2, titleViewHeight/2)];
    openBtnView.tag = kTagOpenBtn;
    openBtnView.userInteractionEnabled = YES;
    if (isPad) {
        UILabel *menuLabel = [[UILabel alloc] initWithFrame:openBtnView.bounds];
        menuLabel.backgroundColor = [UIColor clearColor];
        menuLabel.textColor= [UIColor whiteColor];
        menuLabel.textAlignment = NSTextAlignmentCenter;
        menuLabel.font = [UIFont fontWithName:@"Heiti SC" size:backLabelFontSize];
        menuLabel.text = NSLocalizedString(@"video_the_way_to_open", nil);
        menuLabel.tag = kTagOpenBtn;
        menuLabel.userInteractionEnabled = YES;
        [openBtnView addSubview:menuLabel];
    }
    [titleView addSubview:openBtnView];
    
    [self.view addSubview:titleView];
    
    /**
     唱片盘
     */
    UIImageView *diskView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicDisk"]];
    [diskView setCenter:CGPointMake(screenSize.width/2, (screenSize.height - titleViewHeight)/2)];
    [self.view addSubview:diskView];
    
    CGFloat musicTitleFontSize = isPad?24.0:12.0;//标题字体大小
    CGFloat musicSingerFontSize = isPad?24.0:10.0;//标题字体大小
    CGFloat musicTitleTop = isPad?550.0:300.0;
    //唱片盘下方音乐标题的文本标签
    musicTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, musicTitleTop, screenSize.width, musicTitleFontSize)];
    musicTitleLabel.backgroundColor = [UIColor clearColor];
    musicTitleLabel.textColor= [UIColor whiteColor];
    musicTitleLabel.textAlignment = NSTextAlignmentCenter;
    musicTitleLabel.font = [UIFont fontWithName:@"Heiti SC" size:musicTitleFontSize];
    NSLog(@"musicTitleLabel:%@", NSStringFromCGRect(musicTitleLabel.frame));
    //唱片盘下方歌手名字的文本标签
    musicSingerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, musicTitleLabel.frame.origin.y + musicTitleFontSize + 2, screenSize.width, musicSingerFontSize)];
    musicSingerLabel.backgroundColor = [UIColor clearColor];
    musicSingerLabel.textColor= [UIColor grayColor];
    musicSingerLabel.textAlignment = NSTextAlignmentCenter;
    musicSingerLabel.font = [UIFont fontWithName:@"Heiti SC" size:musicSingerFontSize];
    NSLog(@"musicSingerLabel:%@", NSStringFromCGRect(musicSingerLabel.frame));

    [self.view addSubview:musicTitleLabel];
    [self.view addSubview:musicSingerLabel];
    
    /**
     播放控制条
     */
    UIImageView *bottomBg = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicBottomBg"]];
    CGFloat controlBarViewHeight = isPad?(bottomBg.frame.size.height + 25.5):(bottomBg.frame.size.height + 44);//底部控制条整体背景的高度
//    CGFloat playBtnLeft = isPad?14.0:18.0;//播放按钮x坐标
    UIView *controlBarView = [[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height - controlBarViewHeight, screenSize.width, controlBarViewHeight)];
    [controlBarView addSubview:bottomBg];
    [bottomBg setCenter:CGPointMake(screenSize.width/2, controlBarViewHeight-bottomBg.frame.size.height/2)];
    bottomBg = nil;
//    UIColor *color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
//    controlBarView.backgroundColor = color;
//    [color release];
    //播放按钮
    playBtnView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicPlay"] highlightedImage:[self imageNamed:@"XBMusicPlay"]];
    [playBtnView setCenter:CGPointMake(screenSize.width/2, 80.0)];
    playBtnView.tag = kTagPlayBtn;
    playBtnView.hidden = YES;
    playBtnView.userInteractionEnabled = YES;
    [controlBarView addSubview:playBtnView];
    
    pauseBtnView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicPause"] highlightedImage:[self imageNamed:@"XBMusicPause"]];
    [pauseBtnView setCenter:playBtnView.center];
    pauseBtnView.tag = kTagPlayBtn;
    pauseBtnView.hidden = NO;
    pauseBtnView.userInteractionEnabled = YES;
    [controlBarView addSubview:pauseBtnView];
    isPlaying = NO;
    
    //上一首、下一首
    UIImageView *prevBtn = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicPrev"]];
    [prevBtn setCenter:CGPointMake(playBtnView.center.x - 100, playBtnView.center.y)];
    prevBtn.tag = kTagPrevBtn;
    prevBtn.userInteractionEnabled = YES;
    [controlBarView addSubview:prevBtn];

    UIImageView *nextBtn = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicNext"]];
    [nextBtn setCenter:CGPointMake(playBtnView.center.x + 100, playBtnView.center.y)];
    nextBtn.tag = kTagNextBtn;
    nextBtn.userInteractionEnabled = YES;
    [controlBarView addSubview:nextBtn];
    
    //SLIDE条
    CGFloat sliderWidth = screenSize.width;//进度条的长度
    CGFloat slideHeight = isPad?3.5:3.5;//进度条内拖动条的高度
    CGFloat slideFrameHeight = isPad?44.0:44.0;//进度条的高度
    CGFloat slideTop = isPad?2.0:22.0;//进度条x坐标
    playerSlider = [[UISlider alloc] init];
    UIImage *thumbImage = [self imageNamed:@"XBMusicSlideBtn"];
    playerSlider.frame = CGRectMake(0, slideTop, sliderWidth, slideFrameHeight);
    playerSlider.value= 0.0;
    playerSlider.minimumValue= 0.0;
    playerSlider.maximumValue= 1.0;
    
    //SLIDE条，未播放的进度条
    CGRect rect = CGRectMake(0, 0, sliderWidth, slideHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = [[UIColor alloc] initWithRed:187.0/255 green:187.0/255 blue:187.0/255 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context,rect);
    CGContextDrawPath(context, kCGPathFill);
    UIImage *img_bg = UIGraphicsGetImageFromCurrentImageContext();
    //SLIDE条，已播放的进度条
    CGContextClearRect(context, rect);
    color = [[UIColor alloc] initWithRed:86.0/255 green:26.0/255 blue:180.0/255 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context,rect);//画方框
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    UIImage *img_fg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [playerSlider setMinimumTrackImage:img_fg forState:UIControlStateNormal];
    [playerSlider setMaximumTrackImage:img_bg forState:UIControlStateNormal];
    [playerSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [playerSlider setThumbImage:[self imageNamed:@"XBSlideBtn-pressed"] forState:UIControlStateHighlighted];
    
    //滑块拖动时的事件
    [playerSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [playerSlider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
    [controlBarView addSubview:playerSlider];
    
    //时间标签
    CGFloat timeLabelFontSize = isPad?13.5:10.0;//时间标签的字体大小
    CGFloat timeLabelLeft = 10;
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelLeft, (controlBarViewHeight - slideFrameHeight)/2-timeLabelFontSize, timeLabelFontSize * 4, timeLabelFontSize)];
    timeLabel.font =[UIFont fontWithName:@"Arial" size:timeLabelFontSize];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor colorWithRed:201.0/255 green:205.0/255 blue:208.0/255 alpha:1.0];
    timeLabel.text = @"00:00";
    [controlBarView addSubview:timeLabel];
    totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width-timeLabel.frame.size.width-timeLabelLeft, (controlBarViewHeight - slideFrameHeight)/2-timeLabelFontSize, timeLabelFontSize * 5, timeLabelFontSize)];
    totalTimeLabel.font =[UIFont fontWithName:@"Arial" size:timeLabelFontSize];
    totalTimeLabel.backgroundColor = [UIColor clearColor];
    totalTimeLabel.textColor = [UIColor colorWithRed:201.0/255 green:205.0/255 blue:208.0/255 alpha:1.0];
    totalTimeLabel.text = @"00:00";
    [controlBarView addSubview:totalTimeLabel];
    
    //喇叭
//    CGFloat speakerLeft = isPad?981.0:446.0;//喇叭按钮x坐标
//    UIImage * speakerFullImage = [self imageNamed:@"XBMusicSpeaker-full"];
//    speakerView = [[XBSpeakerView alloc] initWithFrame:CGRectMake(speakerLeft, (controlBarViewHeight - speakerFullImage.size.height)/2, speakerFullImage.size.width, speakerFullImage.size.height)];
//    [speakerView setImage:[self imageNamed:@"XBMusicSpeaker-zero"] ForTag:kSPEAKER_TAG_ZERO];
//    [speakerView setImage:[self imageNamed:@"XBMusicSpeaker-low"] ForTag:kSPEAKER_TAG_LOW];
//    [speakerView setImage:[self imageNamed:@"XBMusicSpeaker-middle"] ForTag:kSPEAKER_TAG_MIDDLE];
//    [speakerView setImage:speakerFullImage ForTag:kSPEAKER_TAG_FULL];
//    [speakerView setImage:[self imageNamed:@"XBMusicSpeaker-silent"] ForTag:kSPEAKER_TAG_SILENT];
//    speakerView.silent = NO;
//    speakerView.volume = [[MPMusicPlayerController applicationMusicPlayer] volume];
//    NSLog(@"volume:%f", speakerView.volume);
//    speakerView.tag = kTagSpeakerBtn;
//    [controlBarView addSubview:speakerView];

    if (isPad) {
        UIImageView *speakerFullView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicSpeaker-full"]];
        [speakerFullView setCenter:CGPointMake(screenSize.width - 20, playBtnView.center.y)];
        speakerFullView.tag = kTagSpeakerBtn;
        speakerFullView.userInteractionEnabled = YES;
        [controlBarView addSubview:speakerFullView];
    } else {
        UIImageView *speakerZeroView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicSpeaker-zero"]];
        [speakerZeroView setCenter:CGPointMake(20, 140)];
        speakerZeroView.tag = kTagSoundMinus;
        speakerZeroView.userInteractionEnabled = YES;
        [controlBarView addSubview:speakerZeroView];
        
        UIImageView *speakerFullView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicSpeaker-full"]];
        [speakerFullView setCenter:CGPointMake(screenSize.width - 20, speakerZeroView.center.y)];
        speakerFullView.tag = kTagSoundPlus;
        speakerFullView.userInteractionEnabled = YES;
        [controlBarView addSubview:speakerFullView];
    }

    //音量滑动条
    CGFloat soundSlideWidth = isPad?354.5:154.5;//音量滑动条长度
    CGFloat soundSlideHeight = isPad?5.5:3.5;//音量滑动条高度
    CGFloat soundSlideLeft = isPad?971.5:439.5;//音量滑动条x坐标
    CGFloat soundSlideTop = isPad?306.5:91;//音量滑动条y坐标
    CGFloat soundSlideFrameWidth = isPad?185:170.5;//音量滑动条背景长度
    CGFloat soundSlideFrameHeight = isPad?18.5:30.0;//音量滑动条背景高度
    rect = CGRectMake(0, 0, soundSlideWidth, soundSlideHeight);
    UIGraphicsBeginImageContext(rect.size);
    context = UIGraphicsGetCurrentContext();
    
    color = [[UIColor alloc] initWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextAddRect(context,rect);//画方框
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    UIImage *img_bg_volume = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClearRect(context, rect);
    color = [[UIColor alloc] initWithRed:86.0/255 green:26.0/255 blue:280.0/255 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextAddRect(context,rect);//画方框
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
    UIImage *img_fg_volume = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    volumeSlider = [[UISlider alloc] init];
    volumeSlider.frame = CGRectMake(soundSlideLeft-soundSlideFrameWidth/2+soundSlideFrameHeight/2, soundSlideTop+soundSlideFrameWidth/2-soundSlideFrameHeight/2, soundSlideFrameWidth, soundSlideFrameHeight);
    if (isPad) {
        volumeSlider.transform = CGAffineTransformMakeRotation(-M_PI/2);
        color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        volumeSlider.backgroundColor = color;
        [volumeSlider setCenter:CGPointMake(screenSize.width - 25.0, -40)];
        volumeSlider.hidden = YES;
    } else {
        [volumeSlider setCenter:CGPointMake(screenSize.width/2, 140)];
    }
    volumeSlider.value = speakerView.volume;
    volumeSlider.minimumValue = 0.0;
    volumeSlider.maximumValue = 1.0;
    [volumeSlider setMinimumTrackImage:img_fg_volume forState:UIControlStateNormal];
    [volumeSlider setMaximumTrackImage:img_bg_volume forState:UIControlStateNormal];
    [volumeSlider setThumbImage:[self imageNamed:@"XBSoundSlideBtn"] forState:UIControlStateNormal];
    
    //滑块拖动时的事件
    [volumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [volumeSlider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
    [controlBarView addSubview:volumeSlider];
//    volumeSlider.hidden = YES;
    
    //添加controlBarView到controlView
    [self.view addSubview:controlBarView];
}

- (void)setupFunctionView
{
    if (functionView) {
        [functionView removeFromSuperview];
        functionView = nil;
    }
    //功能按钮区
    if (musicFile.type != kCaiyunFileTypeLocal) {
        CGFloat functionViewWidth = isPad?72.5:45.0;//功能区宽度
        CGFloat functionViewHeight = isPad?245:159.0;//功能区高度
        CGFloat functionViewFontSize = isPad?12.0:7.0;//功能区字体大小
        CGFloat labelImagePadding = isPad?2.0:2.0;//功能区文字和图片的间隔
        functionView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicFunctionBg"]];
        [functionView setCenter:CGPointMake(functionView.bounds.size.width/2, screenSize.height/2)];
        //        color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        functionView.backgroundColor = [UIColor clearColor];
        functionView.userInteractionEnabled = YES;
        functionView.tag = kTagHandlerBtn;
        isFunctionViewOut = YES;
        if (handlerView) {
             handlerView = nil;
        }
        handlerView = [[UIImageView alloc] initWithImage:[self imageNamed:@"XBMusicPanelIn"]];
        //        handlerView.tag = kTagHandlerBtn;
        //        handlerView.userInteractionEnabled = YES;
        [handlerView setCenter:CGPointMake(functionView.bounds.size.width - handlerView.bounds.size.width/2, functionView.bounds.size.height/2)];
        [functionView addSubview:handlerView];
        //        [handlerView release];
        
        UIImage *image;
        UIImageView *imageView;
        UILabel *label;
        if (musicFile.type == kCaiyunFileTypeShare) {
            image = [self imageNamed:@"XBMusicDownload"];
            imageView = [[UIImageView alloc] initWithImage:image];
            //            [imageView setHighlightedImage:[self imageNamed:@"XBDownload-pressed"]];
            imageView.tag = kTagDownloadBtn;
        } else {
            image = [self imageNamed:@"XBMusicShare"];
            imageView = [[UIImageView alloc] initWithImage:image];
            //            [imageView setHighlightedImage:[self imageNamed:@"XBShare-pressed"]];
            imageView.tag = kTagShareBtn;
        }
        imageView.userInteractionEnabled = YES;
        [imageView setFrame:CGRectMake((functionViewWidth-image.size.width)/2, (functionViewHeight/3 - image.size.height - functionViewFontSize - labelImagePadding)/2, image.size.width, image.size.height)];
        [functionView addSubview:imageView];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + image.size.height + labelImagePadding, functionViewWidth, functionViewFontSize)];
        if (musicFile.type == kCaiyunFileTypeShare) {
            label.text = NSLocalizedString(@"video_offline_download", nil);
            label.tag = kTagDownloadBtn;
        } else {
            label.text = NSLocalizedString(@"sharemgr_share_action_title", nil);
            label.tag = kTagShareBtn;
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor= [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Heiti SC" size:functionViewFontSize];
        label.userInteractionEnabled = YES;
        [functionView addSubview:label];
        
        if (musicFile.type == kCaiyunFileTypeNormal) {
            image = [self imageNamed:@"XBMusicDownload"];
            imageView = [[UIImageView alloc] initWithImage:image];
            //        [imageView setHighlightedImage:[self imageNamed:@"XBSave-pressed"]];
            imageView.tag = kTagDownloadBtn;
            imageView.userInteractionEnabled = YES;
            [imageView setFrame:CGRectMake((functionViewWidth-image.size.width)/2, functionViewHeight/3+(functionViewHeight/3 - image.size.height - functionViewFontSize - labelImagePadding)/2, image.size.width, image.size.height)];
            [functionView addSubview:imageView];
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + image.size.height + labelImagePadding, functionViewWidth, functionViewFontSize)];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.textColor= [UIColor whiteColor];
            label.font = [UIFont fontWithName:@"Heiti SC" size:functionViewFontSize];
            label.text = NSLocalizedString(@"video_offline_download", nil);
            label.tag = kTagDownloadBtn;
            label.userInteractionEnabled = YES;
            [functionView addSubview:label];
        }
        
        if (musicFile.type == kCaiyunFileTypeShare) {
            image = [self imageNamed:@"XBMusicResave"];
            imageView = [[UIImageView alloc] initWithImage:image];
            //            [imageView setHighlightedImage:[self imageNamed:@"XBResave-pressed"]];
            imageView.tag = kTagResaveBtn;
        } else {
            image = [self imageNamed:@"XBMusicDelete"];
            imageView = [[UIImageView alloc] initWithImage:image];
            //            [imageView setHighlightedImage:[self imageNamed:@"XBDelete-pressed"]];
            imageView.tag = kTagDeleteBtn;
        }
        imageView.userInteractionEnabled = YES;
        [imageView setFrame:CGRectMake((functionViewWidth-image.size.width)/2, functionViewHeight*2/3+(functionViewHeight/3 - image.size.height - functionViewFontSize - labelImagePadding)/2, image.size.width, image.size.height)];
        [functionView addSubview:imageView];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + image.size.height + labelImagePadding, functionViewWidth, functionViewFontSize)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor= [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Heiti SC" size:functionViewFontSize];
        if (musicFile.type == kCaiyunFileTypeShare) {
            label.text = NSLocalizedString(@"filemgr_operation_tranfer_to_save", nil);
            label.tag = kTagResaveBtn;
        } else {
            label.text = NSLocalizedString(@"common_delete", nil);
            label.tag = kTagDeleteBtn;
        }
        label.userInteractionEnabled = YES;
        [functionView addSubview:label];

        [self.view addSubview:functionView];
    }
}

/**
 CaiyunVideoViewDelegate
 */
- (void)setDelegate:(id)fileDelegate
{
    delegate = fileDelegate;
}

/**
 播放音乐
 file：音乐文件对象
 */
- (void)play:(XBMusicFile *)file
{
    BOOL needResetFunctionView = YES;
    if (musicFile) {
        if (musicFile.type == file.type) {
            needResetFunctionView = NO;
        }
    }
    musicFile = file;
    titleLabel.text = musicFile.title;
    musicTitleLabel.text = musicFile.title;
    musicSingerLabel.text = musicFile.singer;
    if (musicFile.prev) {
        [self.view viewWithTag:kTagPrevBtn].userInteractionEnabled = YES;
    } else {
        [self.view viewWithTag:kTagPrevBtn].userInteractionEnabled = NO;
    }
    if (musicFile.next) {
        [self.view viewWithTag:kTagNextBtn].userInteractionEnabled = YES;
    } else {
        [self.view viewWithTag:kTagNextBtn].userInteractionEnabled = NO;
    }
    if (needResetFunctionView) {
        [self setupFunctionView];
    }
    NSURL *url;
    if (musicFile.type == kCaiyunFileTypeLocal) {
        url = [[NSURL alloc] initFileURLWithPath:musicFile.url];
    } else {
        url = [[NSURL alloc] initWithString:musicFile.url];
    }
    if (myPlayer) {
        [myPlayer stop];
        [myPlayer setContentURL:url];
    } else {
        myPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMusicInfo:) name:MPMoviePlayerLoadStateDidChangeNotification object:myPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:myPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:myPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        [myPlayer setControlStyle:MPMovieControlStyleNone];
    }
    [myPlayer prepareToPlay];
    [myPlayer play];
}

#pragma mark ---- Notification
//获取视频信息
- (void)getMusicInfo:(NSNotification *)notification
{
    if (myPlayer.loadState != MPMovieLoadStateUnknown) {
        MPMoviePlayerController *movieController = [notification object];
        playerSlider.maximumValue = movieController.duration;
        int currentTime = myPlayer.duration;
//        NSInteger hour = currentTime / 3600;
        int minu = (currentTime %= 3600)/60;
        int second = currentTime % 60;
        totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minu, second];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:movieController];
        playerTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onPlayerPlay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:playerTimer forMode:NSDefaultRunLoopMode];
        [myPlayer play];
    }
}

//暂停播放触发的通知
-(void)playbackStateChange:(NSNotification*)notification
{
    if (myPlayer.playbackState == MPMoviePlaybackStatePaused) {
        playBtnView.hidden = NO;
        pauseBtnView.hidden = YES;
        isPlaying = NO;
        [activityView startAnimating];
    } else {
        playBtnView.hidden = YES;
        pauseBtnView.hidden = NO;
        isPlaying = YES;
        [activityView stopAnimating];
    }
}

//电影播放结束时候通知
-(void)playbackDidFinish:(NSNotification*)notification
{
    int reasonValue;
    if (notification) {
        NSNumber *reason = [notification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        switch ([reason intValue]) {
            case MPMovieFinishReasonPlaybackEnded:
                reasonValue = kPlayCompletedStateNormal;
                break;
            case MPMovieFinishReasonPlaybackError:
                reasonValue = kPlayCompletedStateUrlError;
                break;
            case MPMovieFinishReasonUserExited:
                reasonValue = kPlayCompletedStateUserClose;
                break;
            default:
                reasonValue = kPlayCompletedStateNetworkError;
                break;
        }
    } else {
        if (!isPad) {
            [myPlayer stop];
        }
        reasonValue = kPlayCompletedStateUserClose;
    }
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:myPlayer];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:myPlayer];
    [activityView stopAnimating];
    if (delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
        [delegate performSelector:@selector(didMediaPlayCompleted:withState:) withObject:musicFile.fileId withObject:[NSNumber numberWithInt:reasonValue]];
    }
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

//用户通过手机按键调节音量
-(void)volumeChanged:(NSNotification *)notification
{
    CGFloat volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    volumeSlider.value = volume;
}

//每隔1秒刷新播放状态
- (void)onPlayerPlay
{
    int currentTime = myPlayer.currentPlaybackTime;
    int minu = (currentTime %= 3600)/60;
    int second = currentTime % 60;
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minu, second];
    playerSlider.value = myPlayer.currentPlaybackTime;
}

#pragma mark ----UISlider Action
- (void)sliderValueChanged:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    if ([slider isEqual:volumeSlider]) {
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:slider.value];
        [speakerView setVolume:slider.value];
    } else {
        if (playerTimer) {
            [playerTimer invalidate];
            [myPlayer pause];
            playerTimer = nil;
        }
        int currentTime = playerSlider.value;
        int minu = (currentTime %= 3600)/60;
        int second = currentTime % 60;
        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minu, second];
    }
}

- (void)sliderDragUp:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    if ([slider isEqual:playerSlider]) {
        myPlayer.currentPlaybackTime = playerSlider.value;
        [myPlayer play];
        //        [[NSUserDefaults standardUserDefaults] setFloat:myPlayer.currentPlaybackTime forKey:@"currentTime"];
        playerTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onPlayerPlay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:playerTimer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark ---- UIViewController
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
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (dragMode == kDragModeHorizontal) {
        //水平拖动，调节播放进度
        CGFloat newValue = (point.x - startPoint.x) / playerSlider.frame.size.width * playerSlider.maximumValue + playerSlider.value;
        startPoint = point;
        if (newValue >= 0 && newValue <= playerSlider.maximumValue) {
            if (!pausedForDrag) {
                pausedForDrag = YES;
                [myPlayer pause];
            }
            playerSlider.value = newValue;
            [self sliderValueChanged:playerSlider];
        }
    } else if (dragMode == kDragModeVertical) {
        //垂直拖动，调节音量
        CGFloat newValue = (startPoint.y - point.y) / volumeSlider.frame.size.height * volumeSlider.maximumValue + volumeSlider.value;
        startPoint = point;
        if (newValue >= 0 && newValue <= volumeSlider.maximumValue) {
            volumeSlider.value = newValue;
            [self sliderValueChanged:volumeSlider];
        }
    } else {
        dragMode = abs((int)(point.x - startPoint.x)) > abs((int)(point.y - startPoint.y)) ? kDragModeHorizontal : kDragModeVertical;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (dragMode) {
        if (pausedForDrag) {
            [self sliderDragUp: playerSlider];
        }
        pausedForDrag = NO;
        dragMode = kDragModeNone;
        return;
    }
    if ([touches count] >= 1) {
        UITouch * touch = [[touches allObjects] objectAtIndex:0];
//        if ([touch.view respondsToSelector:@selector(setHighlighted:)]) {
//            ((UIImageView *)touch.view).highlighted = NO;
//        }
        switch (touch.view.tag) {
            case kTagPlayBtn:
                if (isPlaying) {
                    //                    playBtnView.hidden = NO;
                    //                    pauseBtnView.hidden = YES;
                    [myPlayer pause];
                    isPlaying = NO;
                } else {
                    //                    playBtnView.hidden = NO;
                    //                    pauseBtnView.hidden = YES;
                    [myPlayer play];
                    isPlaying = YES;
                }
                break;
            case kTagSpeakerBtn:
                if (volumeSlider.hidden) {
                    volumeSlider.hidden = NO;
                } else {
                    volumeSlider.hidden = YES;
                }
                break;
            case kTagShareBtn:
                if (delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
                    [delegate performSelector:@selector(willShareFile:) withObject:musicFile.fileId];
                }
                break;
            case kTagSaveBtn:
                if (delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
                    [delegate performSelector:@selector(willSaveFile:) withObject:musicFile.fileId];
                }
                break;
            case kTagResaveBtn:
                if (delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
                    [delegate performSelector:@selector(willResaveFile:) withObject:musicFile.fileId];
                }
                break;
            case kTagDeleteBtn:
                if (delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
                    [delegate performSelector:@selector(willDeleteFile:) withObject:musicFile.fileId];
                }
                break;
            case kTagDownloadBtn:
                if (delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
                    [delegate performSelector:@selector(willDownloadFile:) withObject:musicFile.fileId];
                }
                break;
            case kTagPrevBtn:
                if (musicFile.prev && delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
                    [delegate performSelector:@selector(willPlayPrev:) withObject:musicFile.fileId];
                }
                break;
            case kTagNextBtn:
                if (musicFile.next && delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
                    [delegate performSelector:@selector(willPlayNext:) withObject:musicFile.fileId];
                }
                break;
            case kTagOpenBtn:
                if (delegate && [delegate conformsToProtocol:@protocol(CaiyunFileFunctionDelegate)]) {
                    [delegate performSelector:@selector(didMenuClicked:) withObject:musicFile.fileId];
                }
                break;
            case kTagBackBtn:
                if (isPad) {
                    [self playbackDidFinish:nil];
                } else {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self playbackDidFinish:nil];
                    }];
                }
                break;
            case kTagSoundMinus:
            {
                CGFloat nextSound = volumeSlider.value - 0.1;
                if (nextSound < 0) {
                    nextSound = 0.0;
                }
                volumeSlider.value = nextSound;
                [self sliderValueChanged:volumeSlider];
            }
                break;
            case kTagSoundPlus:
            {
                CGFloat nextSound = volumeSlider.value + 0.1;
                if (nextSound > volumeSlider.maximumValue) {
                    nextSound = volumeSlider.maximumValue;
                }
                volumeSlider.value = nextSound;
                [self sliderValueChanged:volumeSlider];
            }
                break;
            case kTagHandlerBtn:
                if (isFunctionViewOut) {
                    isFunctionViewOut = NO;
                    [handlerView setImage:[self imageNamed:@"XBMusicPanelOut"]];
                    [functionView setCenter:CGPointMake(functionView.center.x - 48.5, functionView.center.y)];
                } else {
                    isFunctionViewOut = YES;
                    [handlerView setImage:[self imageNamed:@"XBMusicPanelIn"]];
                    [functionView setCenter:CGPointMake(functionView.center.x + 48.5, functionView.center.y)];
                }
                break;
            default:
                if (isPad && !volumeSlider.hidden) {
                    volumeSlider.hidden = YES;
                }
                break;
        }
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (isPad) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (isPad) {
        return interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft;
    } else {
        return interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (isPad) {
        return UIInterfaceOrientationLandscapeLeft;
    } else {
        return UIInterfaceOrientationPortrait;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ---- Tools
- (UIImage *)imageNamed:(NSString *)name
{
    if (isPad) {
        return [UIImage imageNamed:[name stringByAppendingString:@"-iPad"]];
    } else {
        return [UIImage imageNamed:name];
    }
}

@end
