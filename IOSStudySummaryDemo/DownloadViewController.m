//
//  DownloadViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/9/15.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()

@property(nonatomic, strong) UIImageView *headImageView;//顶部图像视图
@property(nonatomic, strong) UIProgressView *downloadProgress; //下载进度条
@property(nonatomic, strong) UILabel *downloadPercent; //下载进度百分比

@end

@implementation DownloadViewController

- (void)initView
{
    //图片显示
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 250)];
    self.headImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.headImageView];
    
    //下载进度条
    self.downloadProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(75, 400, 200, 6)];
    self.downloadProgress.progress = 0.0;
    [self.view addSubview:self.downloadProgress];
    
    //下载进度百分比
    self.downloadPercent = [[UILabel alloc] initWithFrame:CGRectMake(295, 390, 50, 20)];
    self.downloadPercent.text = @"0%";
    [self.view addSubview:self.downloadPercent];
    
    //开始、暂停 (下载大文件的断点续传)
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH/2-50, 450, 100, 100);
    [btn setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //下载方式选择
    NSArray *btnArray = [NSArray arrayWithObjects:@"NSURLConnection",@"NSURLSession",nil];
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:btnArray];
    segmentedCtrl.frame = CGRectMake(5, SCREEN_HEIGHT - 55, SCREEN_WIDTH - 10, 50);
    //segmentedCtrl.momentary = YES;//设置点击后是否恢复原样
    segmentedCtrl.selectedSegmentIndex = 0;
    [segmentedCtrl addTarget:self
                      action:@selector(segmentCtrlHandle:)
            forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"下载";
    
    [self initView];
    
    //小文件下载方式(这里从网络下载一张图片)
    //这里URL如果使用的是http而不是https，在Xcode7中需要在info.plist文件添加
    //<key>NSAppTransportSecurity</key>
    //<dict>
    //<key>NSAllowsArbitraryLoads</key>
    //<true/>
    //</dict>
    //因为在iOS9 beta1中，苹果将原http协议改成了https协议，使用 TLS1.2 SSL加密请求数据。
    NSURL *imageUrl = [NSURL URLWithString:@"http://img.baizhan.net/uploads/allimg/150817/16_150817171037_1.jpg"];
    
    // 1.NSData dataWithContentsOfURL
    //[self downloadImageByNSData:imageUrl];
    
    // 2.NSURLConnection
    [self downloadImageByNSURLConnection:imageUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadImageByNSData:(NSURL *)url
{
    //方法1：通过NSData dataWithContentsOfURL获取
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //其实是发送一个Get请求
        NSData *dataImage = [NSData dataWithContentsOfURL:url];
        if (dataImage != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程刷新UI
                self.headImageView.image = [UIImage imageWithData:dataImage];
            });
        }
        else
        {
            NSLog(@"download image fail!");
        }
    });
}

- (void)downloadImageByNSURLConnection:(NSURL *)url
{
    //方法2：通过NSURLConnection获取
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                            timeoutInterval:60.0f];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if(connectionError == nil && data.length > 0)
                               {
                                   self.headImageView.image = [UIImage imageWithData:data];
                               }
                               else if(connectionError == nil && data.length == 0)
                               {
                                   NSLog(@"Nothing was downloaded.");
                               }
                               else if(connectionError != nil)
                               {
                                   NSLog(@"Error happened = %@",connectionError);
                               }
                           }];
}

- (void)segmentCtrlHandle:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0: //NSURLConnection
            
            break;
        case 1: //NSURLSession
            break;
        default:
            break;
    }
}

- (void)btnClicked:(UIButton *)sender
{
    // 状态取反
    sender.selected = !sender.isSelected;
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
