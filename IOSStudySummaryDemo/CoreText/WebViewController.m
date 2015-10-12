//
//  WebViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/12.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"基于UIWebView的混合编程";
    
    //网址输入框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH-50, 50)];
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
    //go按钮
    UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goBtn.frame = CGRectMake(SCREEN_WIDTH-50, 64, 50, 50);
    [goBtn setTitle:@"Go" forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBtn];
    
    //UIWebView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    //正在加载风火轮
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicatorView setCenter:self.view.center];
    [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBtnClicked:(UIButton *)sender
{
    [self.textField resignFirstResponder];
    NSString *webUrl = self.textField.text;
    if (webUrl && ![webUrl isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:webUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:5];
        [self.webView loadRequest:request];
    }
}

#pragma mark - UITextFieldDelegate
//响应UITextField中键盘return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self goBtnClicked:nil];
    return YES;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //加载开始
    [self.activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //加载结束
    [self.activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //加载失败
    [self.activityIndicatorView stopAnimating];
    NSLog(@"%@",[error localizedDescription]);
    if (error.code != 101)
    {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"出错了"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alterview show];
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
