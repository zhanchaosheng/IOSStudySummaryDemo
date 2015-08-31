//
//  secondViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/24.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "secondViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface secondViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) ZCSAnimatorTransitioning *delegate;
@property (weak, nonatomic) UINavigationController *navigationCtrl;

@property (strong, nonatomic) CLLocationManager *locationManger;//位置管理器
@property (strong, nonatomic) CLLocation *previousPoint;//最后一次从位置管理器接收的位置
@property (assign, nonatomic) CLLocationDistance totalMovementDistance;//位置移动的总距离

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
    self.navigationItem.title = @"位置管理";
    
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
    
    //创建拖曳手势，实现拖动返回动画效果
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePanGestureRecongnizer:)];
    [self.view addGestureRecognizer:pan];
    
    //创建分段控件
    NSArray *btnArray = [NSArray arrayWithObjects:@"开启位置管理器",@"停止位置管理器", nil];
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:btnArray];
    segmentedCtrl.frame = CGRectMake(30, SCREEN_HEIGHT - 55, SCREEN_WIDTH - 60, 50);
    segmentedCtrl.momentary = YES;//设置点击后是否恢复原样
    [segmentedCtrl addTarget:self
                      action:@selector(segmentCtrlHandle:)
            forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrl];
    //创建位置管理器并启动
    self.locationManger = [[CLLocationManager alloc] init];
    self.locationManger.delegate = self;//设置代理
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//设置精度
    //self.locationManger.distanceFilter = 1;//距离筛选器，即位置偏移超过1M才会通知代理
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

- (void)segmentCtrlHandle:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0: {
            [self.locationManger startUpdatingLocation];//启动位置管理器
            break;
        }
        case 1: {
            [self.locationManger stopUpdatingLocation];//停止位置管理器
            break;
        }
        default:
            break;
    }
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *getTimerString = [dateFormatter stringFromDate:newLocation.timestamp];
    NSLog(@"位置信息：(%@)",getTimerString);
    
    CLLocationDegrees latitude = newLocation.coordinate.latitude; //纬度
    CLLocationDegrees longitude = newLocation.coordinate.longitude; //经度
    NSString *latitudeString = [NSString stringWithFormat:@"%g\u00B0",latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0",longitude];
    NSLog(@"纬度：%@，经度：%@",latitudeString,longitudeString);
    
    NSString *horizontalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.horizontalAccuracy];
    NSLog(@"水平精度：%@",horizontalAccuracyString);
    
    NSString *altitudeString = [NSString stringWithFormat:@"%gm",newLocation.altitude];
    NSLog(@"海拔高度：%@",altitudeString);
    
    NSString *verticalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.verticalAccuracy];
    NSLog(@"垂直精度：%@",verticalAccuracyString);
    
    if (newLocation.horizontalAccuracy < 0 ||
        newLocation.verticalAccuracy < 0)
    {
        NSLog(@"无效的精度!");
        return;
    }
    if (newLocation.horizontalAccuracy > 100 ||
        newLocation.verticalAccuracy > 50)
    {
        NSLog(@"不使用过大的精度!");
        return;
    }
    if (self.previousPoint == nil)
    {
        self.totalMovementDistance = 0;
    }
    else
    {
        //计算两次位置之间的距离
        self.totalMovementDistance += [newLocation distanceFromLocation:self.previousPoint];
    }
    self.previousPoint = newLocation;
    
    NSString *distanceString = [NSString stringWithFormat:@"%gm",self.totalMovementDistance];
    NSLog(@"移动总距离：%@",distanceString);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"移动总距离"
                                                    message:distanceString
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSString *errorType = (error.code == kCLErrorDenied) ? @"用户未授权！":@"未知错误！";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取位置信息失败"
                                                    message:errorType
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
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
