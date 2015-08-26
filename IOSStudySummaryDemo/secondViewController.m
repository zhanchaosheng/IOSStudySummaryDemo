//
//  secondViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/24.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "secondViewController.h"


@interface secondViewController ()
@property (weak, nonatomic) ZCSAnimatorTransitioning *delegate;
@property (weak, nonatomic) UINavigationController *navigationCtrl;
@end

@implementation secondViewController

- (instancetype)initWithDelegate:(ZCSAnimatorTransitioning *)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    self.navigationItem.title = @"第二个";
    
    //自定义leftBarButtonItem按钮后，左边缘右滑返回失效
    UIBarButtonItem *firstLeftBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                          target:self
                                                                                          action:@selector(leftBarButtonClicked:)];
    self.navigationItem.leftBarButtonItem = firstLeftBarBtn;
    
//    UIBarButtonItem *secondLeftBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
//                                                                                     target:self
//                                                                                     action:@selector(leftBarButtonClicked:)];
//    NSArray *barButtonArray = [NSArray arrayWithObjects:firstLeftBarBtn, secondLeftBarBtn, nil];
//    self.navigationItem.leftBarButtonItems = barButtonArray;
    
    
//去除警告
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    
//    //添加滑动手势，调用系统左边缘右滑返回的处理函数，使得视图中右滑也可以返回
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.interactivePopGestureRecognizer.delegate
//                                                                          action:@selector(handleNavigationTransition:)];
//#pragma clang diagnostic pop
//    [self.view addGestureRecognizer:pan];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePanGestureRecongnizer:)];
    [self.view addGestureRecognizer:pan];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarButtonClicked:(UIBarButtonItem *)sender
{
    NSLog(@"leftBarButtonItem!");
}

- (void)handlePanGestureRecongnizer:(UIPanGestureRecognizer *)gesture
{
    if (self.navigationController)
    {
        //如果viewController没有嵌入到NavigationController中，则self.navigationController为nil
        //所以这里需要保存self.navigationController的值，以便在手势处理函数中使用
        self.navigationCtrl = self.navigationController;
    }
    UIView *view = self.navigationCtrl.view;
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [gesture locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) &&
            self.navigationController.viewControllers.count > 1)
        { // left half
            self.delegate.interactiveTransitionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gesture translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.delegate.interactiveTransitionController updateInteractiveTransition:d];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if ([gesture velocityInView:view].x > 0)
        {
            [self.delegate.interactiveTransitionController finishInteractiveTransition];
        }
        else
        {
            [self.delegate.interactiveTransitionController cancelInteractiveTransition];
        }
        self.delegate.interactiveTransitionController = nil;
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
