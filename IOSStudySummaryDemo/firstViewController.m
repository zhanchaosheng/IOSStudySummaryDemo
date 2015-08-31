//
//  firstViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/24.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "firstViewController.h"
#import "secondViewController.h"
#import "ZCSAnimatorTransitioning.h"
#import "BaseAnimationViewController.h"
#import "KeyFrameAnimationViewController.h"
#import "GroupAnimationViewController.h"
#import "TransitionAnimationViewController.h"
#import "ComprehensiveCaseViewController.h"

@interface firstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableGroupType;
@property (strong, nonatomic) NSArray *tableGroupName;

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"知识点总结";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightBarButtonClicked:)];

    //设置下一个ViewController返回按钮的title和Image
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] init];
    backBarBtn.title = @"首页";
    self.navigationItem.backBarButtonItem = backBarBtn;
    
    //重新设置delegate并实现gestureRecognizerShouldBegin:
    //解决在secondViewController中设置了自定义leftBarButtonItem而导致左边缘右滑返回失效的问题
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
  
    //定时器总结
    //[self demoNSTimer];
    //[self demoCADisplayLink];
    //[self demoGCDTimer];
    
    //创建tableView
    [self initTableViewData];
    [self initTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonClicked:(UIBarButtonItem *)sender
{
    secondViewController *secondViewCtrl = [[secondViewController alloc] initWithDelegate:(ZCSAnimatorTransitioning *)self.navigationController.delegate];
    [self.navigationController pushViewController:secondViewCtrl animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    return  YES;
}

- (void)initTableViewData
{
    _tableGroupName = [NSArray arrayWithObjects:@"动画总结", nil];
    _tableGroupType = [NSMutableArray arrayWithCapacity:1];
    //动画总结
    NSArray *animation = [NSArray arrayWithObjects:@"基础动画",@"关键帧动画",@"组动画",@"过渡动画",@"综合案例", nil];
    [_tableGroupType addObject:animation];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //_tableView.separatorColor = [UIColor blueColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 定时器总结
- (void)demoNSTimer
{
    //方式一：主线程中创建scheduledTimer，Timer会自动添加进主线程的runLoop的NSDefaultRunLoopMode中
//    NSTimer *scheduledTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
//                                                               target:self
//                                                             selector:@selector(scheduledTimerHandle:)
//                                                             userInfo:@"scheduledTimer userInfo ."
//                                                              repeats:YES];
    
    //方式二：下面这种方式创建Timer需要手动添加进主线程RunLoop,否则不会调用Timer的处理函数
//    NSTimer *timer = [NSTimer timerWithTimeInterval:3.0
//                                             target:self
//                                           selector:@selector(scheduledTimerHandle:)
//                                           userInfo:@"NSTimer userInfo ."
//                                            repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //方式三：新线程中使用NSTimer
    //第一种需要调用start运行：
//    NSThread *newThread = [[NSThread alloc] initWithTarget:self
//                                                  selector:@selector(newThreadProc:)
//                                                    object:@"new thread start run !"];
//    [newThread start];
    
    //第二种
//    [NSThread detachNewThreadSelector:@selector(newThreadProc:)
//                             toTarget:self
//                           withObject:@"new thread start run !"];
    
    //第三种
    [self performSelectorOnMainThread:@selector(newThreadProc:)
                           withObject:@"performSelectorOnMainThread running !"
                        waitUntilDone:NO];
}

- (void)demoCADisplayLink
{
    //CADisplayLink以特定模式注册到runloop后，每当屏幕显示内容刷新结束的时候，
    //runloop就会向CADisplayLink指定的target发送一次指定的selector消息.通常情况下，按照iOS设备屏幕的刷新率60次/秒
    CADisplayLink *displayLinkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTimerHandle:)];
    [displayLinkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)demoGCDTimer
{
    __block int count = 0;
    
    NSTimeInterval period = 3.0; //设置时间间隔
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    ////每3秒触发一次，精度为1S
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCDTimer running !");
        if (count++ > 10)
        {
           dispatch_source_cancel(timer);//需要调用这一句，否则Timer不能正常工作 ？
        }
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"GCD Timer cancel !");
    });
    
    dispatch_resume(timer);
    NSLog(@"GCD Timer statr !");
}

- (void)scheduledTimerHandle:(NSTimer *)timer
{
    NSLog(@"%@",timer.userInfo);
    [timer invalidate];//解除定时器
}

- (void)newThreadProc:(id)object
{
    @autoreleasepool
    {
        NSLog(@"%@",object);
        
//        NSTimer *scheduledTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
//                                                               target:self
//                                                             selector:@selector(scheduledTimerHandle:)
//                                                             userInfo:@"scheduledTimer userInfo ."
//                                                              repeats:YES];
//        //在非主线程中需要手动将Timer添加到RunLoop中，并且运行RunLoop，因为新建线程RunLoop不会自动运行。
//        [[NSRunLoop currentRunLoop] addTimer:scheduledTimer forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
//        //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:6]];//RunLooP运行6S
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:3.0
                                                 target:self
                                               selector:@selector(scheduledTimerHandle:)
                                               userInfo:@"NSTimer userInfo ."
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
    
}

- (void)displayLinkTimerHandle:(CADisplayLink *)timer
{
    NSLog(@"displayLinkTimer running ...");
    [timer invalidate];//解除定时器
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableGroupType.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.tableGroupType objectAtIndex:section];
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableGroupName objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TABLEVIEW_CELL_ID = @"tableview_cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLEVIEW_CELL_ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:TABLEVIEW_CELL_ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell右边小箭头
    }
    NSArray *array = [self.tableGroupType objectAtIndex:indexPath.section];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath;//返回nil则表示不允许选中该项
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
////    UIView *view = [[UIView alloc] init];
////    view.backgroundColor = [UIColor blueColor];
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态
    NSLog(@"Select Row At ( %ld - %ld )",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section == 0)//动画总结
    {
        switch (indexPath.row) {
            case 0: {//基础动画
                BaseAnimationViewController *baseAnimation = [[BaseAnimationViewController alloc] init];
                [self.navigationController pushViewController:baseAnimation animated:YES];
                break;
            }
            case 1: {//关键帧动画
                KeyFrameAnimationViewController *keyFrameAnimation = [[KeyFrameAnimationViewController alloc] init];
                [self.navigationController pushViewController:keyFrameAnimation animated:YES];
                break;
            }
            case 2: {//组动画
                GroupAnimationViewController *groupAnimation = [[GroupAnimationViewController alloc] init];
                [self.navigationController pushViewController:groupAnimation animated:YES];
                break;
            }
            case 3: {//过渡动画
                TransitionAnimationViewController *transitionAnimation = [[TransitionAnimationViewController alloc] init];
                [self.navigationController pushViewController:transitionAnimation animated:YES];
                break;
            }
            case 4: {//综合动画例子
                ComprehensiveCaseViewController *comprehensiveCase = [[ComprehensiveCaseViewController alloc] init];
                [self.navigationController pushViewController:comprehensiveCase animated:YES];
                break;
            }
            default:
                break;
        }
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
