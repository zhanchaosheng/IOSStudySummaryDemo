//
//  secondViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/24.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "secondViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "myAnnotation.h"


@interface secondViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) ZCSAnimatorTransitioning *delegate;
@property (weak, nonatomic) UINavigationController *navigationCtrl;

@property (strong, nonatomic) CLLocationManager *locationManger;//位置管理器
@property (strong, nonatomic) CLLocation *previousPoint;//最后一次从位置管理器接收的位置
@property (strong, nonatomic) MKMapView *mkMapView;

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

- (void)initMkMapView {
    //初始一个纬度，经度
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.928168, 116.39328);
    self.previousPoint = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                    longitude:coordinate.longitude];
    //配置地图显示区域的缩放级别
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    //确定一个区域
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    self.mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    self.mkMapView.delegate = self;
    //地图类型
    //MKMapTypeStandard = 0,  标准
    //MKMapTypeSatellite,  卫星
    //MKMapTypeHybrid    混合
    self.mkMapView.mapType = MKMapTypeStandard;
    self.mkMapView.showsUserLocation = YES;
    [self.mkMapView setRegion:[self.mkMapView regionThatFits:region] animated:YES];//设置MKMapView对象的显示区域
    //添加大头针
    myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate];
    annotation.title = @"北京";
    annotation.subtitle = @"故宫博物馆";
    [self.mkMapView addAnnotation:annotation];
    
    //长按手势 插上大头针
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                                  action:@selector(longPress:)];
    [self.mkMapView addGestureRecognizer:longPressGesture];
    
    [self.view addSubview:self.mkMapView];
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    //只有长按第一次响应时才插上大头针
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.mkMapView];
        CLLocationCoordinate2D coordinate = [self.mkMapView convertPoint:point
                                              toCoordinateFromView:self.mkMapView];
        myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate];
        annotation.title = @"位置";
        annotation.subtitle = [NSString stringWithFormat:@"纬度：%g\u00B0，经度：%g\u00B0",
                               coordinate.latitude,coordinate.longitude];// \u00B0 是 °的Unicode码
        [self.mkMapView addAnnotation:annotation];
    }
}

- (void)initCLLocationManger {
    //定位服务是否开启
    if ([CLLocationManager locationServicesEnabled])
    {
        self.locationManger = [[CLLocationManager alloc] init];
        self.locationManger.delegate = self;//设置代理
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//设置精度
        self.locationManger.distanceFilter = 10;//距离筛选器，即位置偏移超过10M才会通知代理
        
        //IOS 8.0以上定位服务需要设置授权
        //if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        if ([self.locationManger respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            //申请应用程序使用期间授权
            [self.locationManger requestWhenInUseAuthorization];
            
            //申请永久授权,
            //[self.locationManger requestAlwaysAuthorization];
            
            //另外还要在info.plist里加入对应加上下面两个key,Value可以为空
            //NSLocationWhenInUseDescription，允许在前台获取GPS的描述
            //NSLocationAlwaysUsageDescription，允许在后台获取GPS的描述
        }
    }
    else
    {
        NSLog(@"定位服务没有开启!");
    }
    
    //创建分段控件
    NSArray *btnArray = [NSArray arrayWithObjects:@"开启位置管理器",@"停止位置管理器", nil];
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:btnArray];
    segmentedCtrl.frame = CGRectMake(30, SCREEN_HEIGHT - 55, SCREEN_WIDTH - 60, 50);
    segmentedCtrl.momentary = YES;//设置点击后是否恢复原样
    segmentedCtrl.tintColor = [UIColor colorWithRed:225./255 green:186./255 blue:136./255 alpha:1.0];
    [segmentedCtrl addTarget:self
                      action:@selector(segmentCtrlHandle:)
            forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:69./255 green:62./255 blue:55./255 alpha:1.0];
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
    
    //创建位置管理器
    [self initCLLocationManger];
    
    //创建地图视图
    [self initMkMapView];
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
/**
 * 定位服务通知位置信息
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    //得到位置后更新地图视图
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, span);
    //[self.mkMapView setRegion:region animated:YES];
    [self.mkMapView setRegion:[self.mkMapView regionThatFits:region] animated:YES];
    //添加大头针之前先删除之前的
    [self.mkMapView removeAnnotations:self.mkMapView.annotations];
    //添加大头针
    myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:newLocation.coordinate];
    annotation.title = @"定位位置";
    annotation.subtitle = [NSString stringWithFormat:@"纬度：%g\u00B0，经度：%g\u00B0",
                           newLocation.coordinate.latitude,newLocation.coordinate.longitude];    //CLGeocoder解析地址信息
    [self.mkMapView addAnnotation:annotation];
    
    
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
    
//    if (newLocation.horizontalAccuracy < 0 ||
//        newLocation.verticalAccuracy < 0)
//    {
//        NSLog(@"无效的精度!");
//        return;
//    }
//    if (newLocation.horizontalAccuracy > 100 ||
//        newLocation.verticalAccuracy > 50)
//    {
//        NSLog(@"不使用过大的精度!");
//        return;
//    }
    
    //newLocation中的坐标映射到MKMapView控件上时，会发现这个点跟本不是我们所在的位置，而是离我们百米左右的某个地方
    //计算它们之间的距离
    CLLocationDistance totalMovementDistance = [newLocation distanceFromLocation:self.mkMapView.userLocation.location];
    
    NSString *distanceString = [NSString stringWithFormat:@"%gm",totalMovementDistance];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位位置与当前位置的偏差距离"
                                                    message:distanceString
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

/**
 * 定位服务出错
 */
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
    [self.locationManger stopUpdatingLocation];
}

/**
 * 定位服务授权发生变化
 */
- (void)locationManager:(CLLocationManager *)manager
    didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManger respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.locationManger requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //如果是所在地 跳过   固定写法
    if ([annotation isKindOfClass:[mapView.userLocation class]])
    {
        return nil;
    }
    MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if (pinView == nil)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ID"];
    }
    
    pinView.canShowCallout = YES;//能显示Call信息 上面那些图字
    pinView.pinColor = MKPinAnnotationColorPurple;//只有三种
    //大头针颜色
    //MKPinAnnotationColorRed = 0,
    //MKPinAnnotationColorGreen,
    //MKPinAnnotationColorPurple
    pinView.animatesDrop = YES;//显示动画  从天上落下
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    view.backgroundColor = [UIColor orangeColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0f;
    pinView.leftCalloutAccessoryView = view;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = button;
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //初始化MKMapView时，将属性showsUserLocation设置为YES，MKMapView会启动内置的位置监听服务，
    //当用户位置变化时，调用delegate的回调函数
    //CLGeocoder解析设备当前位置地址信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (!error)
                       {
                           for (CLPlacemark *placemark in placemarks)
                           {
                               NSDictionary *placeDict = placemark.addressDictionary;
                               NSLog(@"%@",[placeDict objectForKey:@"Name"]);
                               //self.mkMapView.userLocation.title = @"当前位置";
                               userLocation.subtitle = [NSString stringWithFormat:@"%@",
                                                                       [placeDict objectForKey:@"Name"]];
                               break;
                           }
                       }
                       else
                       {
                           NSLog(@"定位位置信息解析失败!");
                       }
                   }];
    
    //得到位置后更新地图视图
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [self.mkMapView setRegion:[self.mkMapView regionThatFits:region] animated:YES];
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
