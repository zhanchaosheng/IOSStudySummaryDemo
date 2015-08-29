//
//  KeyFrameAnimationViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/29.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "KeyFrameAnimationViewController.h"

@interface KeyFrameAnimationViewController ()

@property (strong, nonatomic) UIView *demoView;
@end

@implementation KeyFrameAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关键帧动画";
    
    _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-100, 100, 100)];
    _demoView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_demoView];
    
    //创建分段控件
    NSArray *btnArray = [NSArray arrayWithObjects:@"关键帧",@"路径",@"抖动", nil];
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:btnArray];
    segmentedCtrl.frame = CGRectMake(20, SCREEN_HEIGHT - 55, SCREEN_WIDTH - 40, 50);
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
        case 0: //关键帧
            [self keyFrameAnimation];
            break;
        case 1: //路径
            [self pathAnimation];
            break;
        case 2: //抖动
            [self shakeAnimation];
            break;
        default:
            break;
    }
}

- (void)keyFrameAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-50)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-50)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2+50)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2+50)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2-50)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
    animation.values = [NSArray arrayWithObjects:value0,value1,value2,value3,value4,value5, nil];
    animation.duration = 2.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//设置动画的节奏
    //kCAMediaTimingFunctionLinear 线性动画
    //kCAMediaTimingFunctionEaseIn 先慢后快（慢进快出）
    //kCAMediaTimingFunctionEaseOut 先块后慢（快进慢出）
    //kCAMediaTimingFunctionEaseInEaseOut 先慢后快再慢
    //kCAMediaTimingFunctionDefault 默认，也属于中间比较快
    animation.delegate = self;//设置代理，可以检测动画的开始和结束
    [_demoView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

- (void)pathAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //创建圆形或椭圆路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 200)];
    
    //创建五边形路径
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(100.0, 0.0)];//设置起点
//    [path addLineToPoint:CGPointMake(200.0, 40.0)]; //添加线条
//    [path addLineToPoint:CGPointMake(160, 140)];
//    [path addLineToPoint:CGPointMake(40.0, 140)];
//    [path addLineToPoint:CGPointMake(0.0, 40.0)];
//    [path closePath]; //闭合终点和起点
    
    //创建一条弧线路径
//    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150)
//                                                         radius:75
//                                                     startAngle:0
//                                                       endAngle:(M_PI*135)/180
//                                                      clockwise:YES];
    
    animation.path = path.CGPath;
    animation.duration = 2.0f;
    animation.delegate = self;
    [_demoView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

- (void)shakeAnimation
{
    //在这里@"transform.rotation"==@"transform.rotation.z"
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*8];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*8];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*8];
    anima.values = @[value1,value2,value3];
    anima.repeatCount = MAXFLOAT;
    
    [_demoView.layer addAnimation:anima forKey:@"shakeAnimation"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim;
{
    NSLog(@"animation start !");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animation stop !");
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
