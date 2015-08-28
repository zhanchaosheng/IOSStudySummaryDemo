//
//  BaseAnimationViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/28.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "BaseAnimationViewController.h"

@interface BaseAnimationViewController ()
@property (strong, nonatomic) UIView *demoView;
@end

@implementation BaseAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"基础动画";
    
    _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-100, 100, 100)];
    _demoView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_demoView];
    
    //创建分段控件
    NSArray *btnArray = [NSArray arrayWithObjects:@"位移",@"透明度",@"缩放",@"旋转",@"背景色", nil];
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:btnArray];
    segmentedCtrl.frame = CGRectMake(5, SCREEN_HEIGHT - 55, SCREEN_WIDTH - 10, 50);
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
        case 0: //位移
            [self positionAnimation];
            break;
        case 1: //透明度
            [self opacityAniamtion];
            break;
        case 2: //缩放
            [self scaleAnimation];
            break;
        case 3: //旋转
            [self rotateAnimation];
            break;
        case 4: //背景色
            [self backgroundAnimation];
            break;
        default:
            break;
    }
}

- (void)positionAnimation
{
    //1、使用CABasicAnimation创建基础动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-75)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-75)];
    animation.duration = 2.0f;
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，
    //图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    //basicAnimation.fillMode = kCAFillModeForwards;
    //basicAnimation.removedOnCompletion = NO;
    [self.demoView.layer addAnimation:animation forKey:@"positionAnimation"];
    
    //2、使用UIView Animation 代码块调用
//    _demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-100, 100, 100);
//    [UIView animateWithDuration:2.0f animations:^{
//        _demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-100, 100, 100);
//    } completion:^(BOOL finished) {
//        _demoView.frame = CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-100, 100, 100);
//    }];
//
    //3、使用UIView [begin,commit]模式
//    _demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-100, 100, 100);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:2.0f];
//    _demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-100, 100, 100);
//    [UIView commitAnimations];
}

- (void)opacityAniamtion
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.1f];
    animation.duration = 2.0f;
    [self.demoView.layer addAnimation:animation forKey:@"opacityAniamtion"];
}

- (void)scaleAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.toValue = [NSNumber numberWithFloat:2.0f];
    animation.duration = 2.0f;
    [self.demoView.layer addAnimation:animation forKey:@"scaleAnimation"];
}

- (void)rotateAnimation
{
    //1、绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@"transform.rotation")
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima.toValue = [NSNumber numberWithFloat:M_PI];
    anima.duration = 1.0f;
    //anima.repeatCount = MAXFLOAT;//重复次数
    [_demoView.layer addAnimation:anima forKey:@"rotateAnimation"];
    
//    //2、CGAffineTransform作用与View
//    _demoView.transform = CGAffineTransformMakeRotation(0);
//    [UIView animateWithDuration:1.0f animations:^{
//        _demoView.transform = CGAffineTransformMakeRotation(M_PI);
//    } completion:^(BOOL finished) {
//
//    }];
}

- (void)backgroundAnimation
{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anima.toValue =(id)[UIColor orangeColor].CGColor;
    anima.duration = 1.0f;
    [_demoView.layer addAnimation:anima forKey:@"backgroundAnimation"];
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
