//
//  ComprehensiveCaseViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/31.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "ComprehensiveCaseViewController.h"
#import "DCPathButton.h"
#import "DWBubbleMenuButton.h"
#import "MCFireworksButton.h"
#import "ZCSCircleProgressView.h"
#import "ZCSRotationArrowRefreshView.h"
#import "ZCSWaterWaveView.h"

@interface ComprehensiveCaseViewController ()<DCPathButtonDelegate>

@property (nonatomic , strong) DCPathButton *pathAnimationView;
@property (nonatomic , strong) DWBubbleMenuButton *dingdingAnimationMenu;
@property (nonatomic , strong) MCFireworksButton *goodBtn;
@property (nonatomic , assign) BOOL selected;

@property (nonatomic , strong) ZCSCircleProgressView *progress;

@end

@implementation ComprehensiveCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"综合案例";
    //创建分段控件
    NSArray *btnArray = [NSArray arrayWithObjects:@"Path菜单",@"钉钉菜单",@"点赞", nil];
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:btnArray];
    segmentedCtrl.frame = CGRectMake(20, SCREEN_HEIGHT - 55, SCREEN_WIDTH - 140, 50);
    //segmentedCtrl.momentary = YES;//设置点击后是否恢复原样
    segmentedCtrl.selectedSegmentIndex = 0;
    [segmentedCtrl addTarget:self
                      action:@selector(segmentCtrlHandle:)
            forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrl];
    
    [self pathAnimation];
    
    //创建时钟进度视图
    _progress = [[ZCSCircleProgressView alloc] initWithFrame:CGRectMake(5, 69, 100, 100)];
    _progress.trackColor = [UIColor grayColor];
    _progress.progressColor = [UIColor orangeColor];
    _progress.progress = 0.f;
    //_progress.progressWidth = 10;
    [self.view addSubview:_progress];
    
    //旋转箭头刷新视图
    ZCSRotationArrowRefreshView *refreshView = [[ZCSRotationArrowRefreshView alloc]
                                                initWithFrame:CGRectMake(150, 69, 100, 100)];
    [refreshView beginAnimation];
    [self.view addSubview:refreshView];
    
    //水波动画视图
    ZCSWaterWaveView *waveView = [[ZCSWaterWaveView alloc] initWithFrame:CGRectMake(150, 180, 200, 200)];
    waveView.backgroundColor = [UIColor colorWithRed:(CGFloat)1/255 green:(CGFloat)122/255 blue:(CGFloat)233/255 alpha:1];
    waveView.layer.borderWidth = 5;
    waveView.layer.borderColor = [UIColor grayColor].CGColor;
    waveView.waveSpeed = 6.0f;
    waveView.waveAmplitude = 6.0f;
    waveView.waterWaveHeightRatio = 0.8;
    waveView.waveColor = [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)79/255 blue:(CGFloat)47/255 alpha:1];
    [waveView wave];
    [self.view addSubview:waveView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentCtrlHandle:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self pathAnimation];
            break;
        case 1:
            [self dingdingAnimation];
            break;
        case 2:
            [self clickGoodAnimation];
            break;
        default:
            break;
    }
}

#pragma mark - 仿Path 菜单动画
/**
 *  仿Path 菜单动画
 *
 *  动画解析：
 *  1、点击红色按钮，红色按钮旋转。（旋转动画）
 *  2、黑色小按钮依次弹出，并且带有旋转效果。（位移动画、旋转动画、组动画）
 *  3、点击黑色小按钮，其他按钮消失，被点击的黑色按钮变大变淡消失。（缩放动画、alpha动画、组动画）
 */
-(void)pathAnimation{
    if (_dingdingAnimationMenu)
    {
        _dingdingAnimationMenu.hidden = YES;
    }
    if (_goodBtn)
    {
        _goodBtn.hidden = YES;
    }
    if (!_pathAnimationView)
    {
        [self ConfigureDCPathButton];
    }
    else
    {
        _pathAnimationView.hidden = NO;
    }
}

- (void)ConfigureDCPathButton
{
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                           hilightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    _pathAnimationView = dcPathButton;
    
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5]];
    
    [self.view addSubview:dcPathButton];
}

#pragma mark - DCPathButton Delegate

- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    NSLog(@"You tap at index : %ld", (unsigned long)index);
}

#pragma mark - 仿造钉钉菜单动画
/**
 *  仿造钉钉菜单动画
 *  
 *  位移动画+缩放动画
 */
-(void)dingdingAnimation{
    if (_pathAnimationView) {
        _pathAnimationView.hidden = YES;
    }
    if (_goodBtn) {
        _goodBtn.hidden = YES;
    }
    if (!_dingdingAnimationMenu) {
        UILabel *homeLabel = [self createHomeButtonView];
        
        DWBubbleMenuButton *upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - homeLabel.frame.size.width - 20.f,
                                                                                              self.view.frame.size.height - homeLabel.frame.size.height - 20.f,
                                                                                              homeLabel.frame.size.width,
                                                                                              homeLabel.frame.size.height)
                                                                expansionDirection:DirectionUp];
        upMenuView.homeButtonView = homeLabel;
        [upMenuView addButtons:[self createDemoButtonArray]];
        
        _dingdingAnimationMenu = upMenuView;
        
        [self.view addSubview:upMenuView];
    }else{
        _dingdingAnimationMenu.hidden = NO;
    }
}

- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"A", @"B", @"C", @"D", @"E", @"F"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(dwBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (void)dwBtnClick:(UIButton *)sender {
    NSLog(@"DWButton tapped, tag: %ld", (long)sender.tag);
}


#pragma mark - 仿造facebook，点赞动画
/**
 *  仿造facebook，点赞动画
 *  
 *  这里其实只有按钮变大效果使用的缩放动画。烟花效果 使用的是一种比较特殊的动画–粒子动画。
 *  一个粒子系统一般有两部分组成：
 *  1、CAEmitterCell：可以看作是单个粒子的原型（例如，一个单一的粉扑在一团烟雾）。当散发出一个粒子，UIKit根据这个发射粒子和定义的基础上创建一个随机粒子。此原型包括一些属性来控制粒子的图片，颜色，方向，运动，缩放比例和生命周期。
 *  2、CAEmitterLayer：主要控制发射源的位置、尺寸、发射模式、发射源的形状等等
 */
-(void)clickGoodAnimation{
    if (_pathAnimationView) {
        _pathAnimationView.hidden = YES;
    }
    if (_dingdingAnimationMenu) {
        _dingdingAnimationMenu.hidden = YES;
    }
    if (!_goodBtn) {
        _goodBtn = [[MCFireworksButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-25, 50, 50)];
        _goodBtn.particleImage = [UIImage imageNamed:@"Sparkle"];
        _goodBtn.particleScale = 0.05;
        _goodBtn.particleScaleRange = 0.02;
        [_goodBtn setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
        
        [_goodBtn addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_goodBtn];
    }else{
        _goodBtn.hidden = NO;
    }
}

- (void)handleButtonPress:(id)sender {
    _selected = !_selected;
    if(_selected) {
        [_goodBtn popOutsideWithDuration:0.5];
        [_goodBtn setImage:[UIImage imageNamed:@"Like-Blue"] forState:UIControlStateNormal];
        [_goodBtn animate];
    }else {
        [_goodBtn popInsideWithDuration:0.4];
        [_goodBtn setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
