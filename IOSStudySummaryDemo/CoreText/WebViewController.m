//
//  WebViewController.m
//  IOSStudySummaryDemo
//
//  通过 UIWebView 的 loadRequest 加载网页，或者 loadHTMLString:baseURL: 加载经过模板渲染的HTML网页。
//  理解 objective-C 和 javascript 互相调用的方法：
//  OC -> (同步调用) UIWebView的stringByEvaluatingJavaScriptFromString: -> JS
//  JS ->  (异步调用) 用iFrame加载特殊URL触发delegate回调 -> OC
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
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(1, 70, 20, 40);
    [backBtn setTitle:@"《 " forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //前进按钮
    UIButton *forwardBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forwardBtn.frame = CGRectMake(22, 70, 20, 40);
    [forwardBtn setTitle:@"》" forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(forwardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwardBtn];
    
    //网址输入框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(43, 70, SCREEN_WIDTH-88, 40)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
    //go按钮
    UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goBtn.frame = CGRectMake(SCREEN_WIDTH-45, 70, 45, 40);
    [goBtn setTitle:@"Go" forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBtn];
    
    //UIWebView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, SCREEN_HEIGHT-115)];
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
    if (webUrl && webUrl.length > 0)
    {
        NSURL *url = [NSURL URLWithString:webUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:30];
        [self.webView loadRequest:request];
    }
}

- (void)backBtnClicked:(UIButton *)sender
{
    [self.webView goBack];
}

- (void)forwardBtnClicked:(UIButton *)sender
{
    [self.webView goForward];
}

//通过模板渲染加载HTML网页，得到我们想要的排版布局和内容并显示出来
- (void)loadWebViewFromHTML
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseUrl = [NSURL fileURLWithPath:path];
    NSString *htmlString;
    //通过模板渲染得到内容
    //NSString *htmlString = [self htmlContent];
    [self.webView loadHTMLString:htmlString baseURL:baseUrl];
}

#pragma mark - UITextFieldDelegate
//响应UITextField中键盘return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self goBtnClicked:nil];
    return YES;
}

#pragma mark - UIWebViewDelegate
//即将请求网络时调用该函数
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSLog(@"%@",url);
    //javascript调objective-c，是在UIWebView中发起一次特殊的网络请求(例如以gap://开头的地址)，触发调用delegate函数，如本函数
    if ([[url scheme] isEqualToString:@"gap:"])//这里识别出是特殊网络请求
    {
        //这里做javascript调objective-c的事情
        //...
        //做完后调用以下方法调回javascript,该方法是让webView同步执行一段javascript代码，然后得到执行结果返回
        NSString *ret = [webView stringByEvaluatingJavaScriptFromString:@"alert('done')"];
        NSLog(@"%@",ret);
        return NO;
    }
    return YES;
}

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
