//
//  DownloadViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/9/15.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "DownloadViewController.h"


@interface DownloadViewController ()<NSURLConnectionDataDelegate,NSURLSessionDownloadDelegate>

@property(nonatomic, strong) UIImageView *headImageView;//顶部图像视图
@property(nonatomic, strong) UIProgressView *downloadProgress; //下载进度条
@property(nonatomic, strong) UILabel *downloadPercent; //下载进度百分比
@property(nonatomic, strong) UIButton *downlaodButton; //开始/暂停下载按钮
@property(nonatomic, assign) BOOL bDownloadType; //下载方式：YES - NSURLConnection、NO - NSURLSession

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, assign) unsigned long long sizeHasDownloadFile;//已经下载的文件大小
@property(nonatomic, assign) unsigned long long totalSizeDownloadFile;//下载文件总大小
@property(nonatomic, strong) NSFileHandle *fileHandle;//本地保存的下载文件句柄

@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong) NSURLSessionDownloadTask *sessionDownloadTask;
@property(nonatomic, strong) NSData *resumeData; //任务取消后保存的文件下载信息
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
    self.downlaodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _downlaodButton.frame = CGRectMake(SCREEN_WIDTH/2-50, 450, 100, 100);
    [_downlaodButton setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [_downlaodButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
    [_downlaodButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downlaodButton];
    
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
    self.bDownloadType = YES;
}

- (void)segmentCtrlHandle:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0: //NSURLConnection
            self.bDownloadType = YES;
            break;
        case 1: //NSURLSession
            self.bDownloadType = NO;
            break;
        default:
            break;
    }
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

#pragma mark - 开始/暂停
- (void)btnClicked:(UIButton *)sender
{
    // 状态取反
    sender.selected = !sender.isSelected;
    if (self.bDownloadType)
    {
        [self downloadFileByNSURLConnection:sender.isSelected];
    }
    else
    {
        [self downloadFileByNSURLSession:sender.isSelected];
    }

}

#pragma mark - 通过NSData获取网络图片
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

#pragma mark - 通过NSURLConnection获取网络图片
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

#pragma mark - 使用NSURLConnection下载文件
- (void)downloadFileByNSURLConnection:(BOOL)state
{
    if (state) //开始或断点续传
    {
        NSURL *url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.0.3_setup.1435732931.dmg"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:30.0f];
        //通过设置HTTP协议中请求头的Range实现断点下载
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-",self.sizeHasDownloadFile];
        [urlRequest setValue:range forHTTPHeaderField:@"Range"];
        self.connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
    else //取消
    {
        [self.connection cancel];
    }
}
#pragma mark - NSURLConnectionDataDelegate
//请求失败时调用（请求超时、网络异常）,error:错误原因
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error)
    {
        NSLog(@"%@",error);
    }
}

//接收到服务器的响应就会调用, response:响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //文件本地保存地址
    NSString *ceches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [ceches stringByAppendingPathComponent:response.suggestedFilename];
    NSLog(@"%@",filePath);
    //创建一个空的文件到沙盒中
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (self.fileHandle)
    {
        //文件句柄不为空，则简单认为是断点续传
        return;
    }
    if (![fileMgr createFileAtPath:filePath contents:nil attributes:nil])
    {
        [connection cancel];
        self.downlaodButton.selected = NO;
        self.connection = nil;
        return;
    }
    //创建一个用来写数据的文件句柄对象
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    //获得文件的总大小
    self.totalSizeDownloadFile = response.expectedContentLength;
}

//当接收到服务器返回的实体数据时调用（具体内容，这个方法可能会被调用多次）,data:这次返回的数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //移动到文件的最后面
    [self.fileHandle seekToEndOfFile];
    //将数据写入文件
    [self.fileHandle writeData:data];
    //更新文件下载进度
    self.sizeHasDownloadFile += data.length;
    self.downloadProgress.progress = (double)self.sizeHasDownloadFile/self.totalSizeDownloadFile;
    unsigned int percent = self.downloadProgress.progress * 100;
    self.downloadPercent.text = [NSString stringWithFormat:@"%d%%",percent];
}

//加载完毕后调用（服务器的数据已经完全返回后）
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.totalSizeDownloadFile = 0;
    self.sizeHasDownloadFile = 0;
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    self.connection = nil;
    self.downlaodButton.selected = NO;
    self.downloadProgress.progress = 0.0;
    self.downloadPercent.text = @"0%";
    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"下载"
                                                           message:@"文件下载成功!"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
    [successAlert show];
}

#pragma mark - 使用NSURLSession下载文件
- (void)downloadFileByNSURLSession:(BOOL)state
{
    if (state)
    {
        if (self.sessionDownloadTask)//断点续传
        {
            //断点续传方式1：恢复暂停的任务
            //[self.sessionDownloadTask resume];
            
            //断点续传方式2：根据resumeData创建新的任务
            self.sessionDownloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
            [self.sessionDownloadTask resume];
        }
        else//开始
        {
            //得到session对象
            NSURL *url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.0.3_setup.1435732931.dmg"];
            NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
            self.session = [NSURLSession sessionWithConfiguration:cfg
                                                                  delegate:self
                                                             delegateQueue:[NSOperationQueue mainQueue]];
            //创建任务
            self.sessionDownloadTask = [self.session downloadTaskWithURL:url];
            [self.sessionDownloadTask resume];
        }
    }
    else
    {
        //断点续传方式1：暂停任务
        //[self.sessionDownloadTask suspend];
        
        //断点续传方式2：取消任务，断点续传时再根据resumeData创建新的任务
        __weak typeof(self) weakSelf = self; //防止循环引用
        [self.sessionDownloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            //  resumeData : 包含了继续下载的开始位置\下载的url
            weakSelf.resumeData = resumeData;
        }];
    }
}

#pragma mark -- NSURLSessionDownloadDelegate
/**
 *  下载完毕会调用
 *
 *  @param location     文件临时地址
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //下载好的文件被自动写入的temp文件夹下面了,不过在下载完成之后会自动删除temp中的文件，
    //所有我们需要做的只是在回调中把文件移动(或者复制，反正之后会自动删除)到caches中
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
    NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    // 将临时文件剪切或者复制Caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    [mgr moveItemAtPath:location.path toPath:file error:nil];
    
    self.downlaodButton.selected = NO;
    self.downloadProgress.progress = 0.0;
    self.downloadPercent.text = @"0%";
    self.sessionDownloadTask = nil;
    self.session = nil;
    // 提示下载完成
    [[[UIAlertView alloc] initWithTitle:@"下载完成"
                                message:downloadTask.response.suggestedFilename
                               delegate:self
                      cancelButtonTitle:@"知道了"
                      otherButtonTitles: nil] show];
}

/**
 *  每次写入沙盒完毕调用
 *  在这里面监听下载进度，totalBytesWritten/totalBytesExpectedToWrite
 *
 *  @param bytesWritten              这次写入的大小
 *  @param totalBytesWritten         已经写入沙盒的大小
 *  @param totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.downloadProgress.progress = (double)totalBytesWritten/totalBytesExpectedToWrite;
    unsigned int percent = self.downloadProgress.progress * 100;
    self.downloadPercent.text = [NSString stringWithFormat:@"%d%%",percent];
}

/**
 *  恢复下载后调用，
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    self.downloadProgress.progress = (double)fileOffset/expectedTotalBytes;
    unsigned int percent = self.downloadProgress.progress * 100;
    self.downloadPercent.text = [NSString stringWithFormat:@"%d%%",percent];
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
