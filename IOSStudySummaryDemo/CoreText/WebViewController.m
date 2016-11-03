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

static NSString* const kTouchJavaScriptString =
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";

typedef NS_ENUM(NSInteger, GESTURE_STATE) {
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_CANCEL = 3,
    GESTURE_STATE_END = 4,
};

@interface WebViewController ()<UIWebViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSString *imgURL;
@property (assign, nonatomic) GESTURE_STATE gesState;
@property (strong, nonatomic) NSTimer *timer;

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
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    //先显示一个Gif图片
    NSString *gifFilePath = [[NSBundle mainBundle] pathForResource:@"fanye" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifFilePath];
    [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
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
//    NSURL *url = [request URL];
//    NSLog(@"%@",url);
//    //javascript调objective-c，是在UIWebView中发起一次特殊的网络请求(例如以gap://开头的地址)，触发调用delegate函数，如本函数
//    if ([[url scheme] isEqualToString:@"gap:"])//这里识别出是特殊网络请求
//    {
//        //这里做javascript调objective-c的事情
//        //...
//        //做完后调用以下方法调回javascript,该方法是让webView同步执行一段javascript代码，然后得到执行结果返回
//        NSString *ret = [webView stringByEvaluatingJavaScriptFromString:@"alert('done')"];
//        NSLog(@"%@",ret);
//        return NO;
//    }
//    return YES;
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 &&
        [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"]) {
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //NSLog(@"you are touching!");
            //NSTimeInterval delaytime = Delaytime;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                self.gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
                self.imgURL = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    self.imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
                if (self.imgURL) {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                self.gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
            else if ([(NSString*)[components objectAtIndex:2] isEqualToString:@"cancel"]) {
                [self.timer invalidate];
                self.timer = nil;
                self.gesState = GESTURE_STATE_CANCEL;
                NSLog(@"touch cancel");
            }
            else if ([(NSString*)[components objectAtIndex:2] isEqualToString:@"end"]) {
                [self.timer invalidate];
                self.timer = nil;
                self.gesState = GESTURE_STATE_END;
                NSLog(@"touch end");
            }
        }
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
    
    //加载js注入，主要用于响应touch事件，以及获得点击的坐标位置，
    [self.webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
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


//如果点击的是图片，并且按住的时间超过1s，执行handleLongTouch函数，处理图片的保存操作。
- (void)handleLongTouch {
    NSLog(@"%@", self.imgURL);
    if (self.imgURL && self.gesState == GESTURE_STATE_START) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"保存图片"]) {
        
        if (self.imgURL) {
            NSLog(@"imgurl = %@", _imgURL);
        }
        NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:self.imgURL];
        NSLog(@"image url=%@", urlToSave);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        UIImage* image = [UIImage imageWithData:data];
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
        
    }else {
        NSLog(@"OK");
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
