//
//  GroupAnimationViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/31.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "GroupAnimationViewController.h"

@interface GroupAnimationViewController ()
@property (strong, nonatomic) UIView *demoView;
@end

@implementation GroupAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"组动画";
    
    _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-100, 100, 100)];
    _demoView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_demoView];
    
    //创建分段控件
    NSArray *btnArray = [NSArray arrayWithObjects:@"同时执行",@"连续执行", nil];
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:btnArray];
    segmentedCtrl.frame = CGRectMake(30, SCREEN_HEIGHT - 55, SCREEN_WIDTH - 60, 50);
    segmentedCtrl.momentary = YES;//设置点击后是否恢复原样
    [segmentedCtrl addTarget:self
                      action:@selector(segmentCtrlHandle:)
            forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentCtrlHandle:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0: //同步执行
            [self simultaneouslyRun];
            break;
        case 1: //连续执行
            [self ContinuousRun];
            break;
        default:
            break;
    }
}

- (void)simultaneouslyRun
{
    //位移动画
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-50)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-50)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2+50)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2+50)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2-50)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
    moveAnimation.values = @[value0,value1,value2,value3,value4,value5];
    
    //缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.8f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    
    //旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*4];
    
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[moveAnimation,scaleAnimation,rotationAnimation];
    groupAnimation.duration = 4.0f;
    
    [self.demoView.layer addAnimation:groupAnimation forKey:@"simultaneouslyGroupAnimation"];
}

- (void)ContinuousRun
{
    CFTimeInterval currentTimer = CACurrentMediaTime();
    //位移动画
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-50)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-50)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2+50)];
    moveAnimation.values = @[value0,value1,value2];
    moveAnimation.duration = 1.0f;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.beginTime = currentTimer;
    [self.demoView.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
    
    //缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.8f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    scaleAnimation.duration = 2.0f;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.beginTime = currentTimer + 1.0f;
    [self.demoView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    //旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*4];
    rotationAnimation.duration = 2.0f;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.beginTime = currentTimer + 1.0f + 2.0f;
    [self.demoView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
