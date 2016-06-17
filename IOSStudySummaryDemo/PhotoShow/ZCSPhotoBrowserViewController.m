//
//  ZCSPhotoBrowserViewController.m
//  IOSStudySummaryDemo
//
//  Created by zcs on 16/6/16.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "ZCSPhotoBrowserViewController.h"
#import "AppDelegate.h"
#import "ZCSPhotoShowView.h"

@interface ZCSPhotoBrowserViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIView *topStatusBarview;
@property (nonatomic, strong) UIToolbar *topBar;
@property (nonatomic, strong) UILabel *imageTitle;

@property (nonatomic, assign) CGRect screenFrame;
@property (nonatomic, assign) BOOL isTransformView;
@property (nonatomic, assign) UIInterfaceOrientationMask orientationMask;

@property (nonatomic, strong) NSArray *imagesSource;
@property (nonatomic, strong) NSMutableArray *photoShowViewArray;
@property (nonatomic, assign) NSInteger startAtIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger rotateIndex; //旋转时记住当前节点位置
@property (nonatomic, assign) NSInteger numberOfImages;
@property (nonatomic, assign) BOOL notAllowScrollInRotate;//旋转过程中不允许滚动
@property (nonatomic, getter=isShowAtFullScrean) BOOL showAtFullScrean; //全屏展示

@end

@implementation ZCSPhotoBrowserViewController

- (instancetype)initWithImagesSource:(NSArray *)images
                     andStartAtIndex:(NSUInteger)index {
    if (images.count == 0 || index >= images.count) {
        return nil;
    }
    self = [super init];
    if (self) {
        _startAtIndex = index;
        _currentIndex = index;
        _rotateIndex = index;
        _imagesSource = [images copy];
        _numberOfImages = images.count;
        _photoShowViewArray = [NSMutableArray arrayWithCapacity:_numberOfImages];
        for (int i = 0; i < _numberOfImages; i++) {
            [_photoShowViewArray addObject:[NSNull null]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orientationMask = UIInterfaceOrientationMaskPortrait;
    self.screenFrame = [UIScreen mainScreen].bounds;
    [self setScrollViewContentSize];
    [self setTitleForIndex:self.currentIndex];
    [self setImageForIndex:self.currentIndex];
    [self scrollToIndex:self.currentIndex];
    _showAtFullScrean = YES;
    self.topStatusBarview.alpha = 0;
    self.topBar.alpha = 0;
    self.toolBar.alpha = 0;
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationFade];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    if(!isiOS7) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(layoutControllerSubViews)
                                                     name:UIApplicationDidChangeStatusBarFrameNotification
                                                   object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    [self creatScrollView];
    [self creatToolBarView];
    [self createTopBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isTransformView = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.orientationMask = UIInterfaceOrientationMaskAll;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isTransformView = NO;
}

#pragma mark - Init UI
- (void)creatScrollView {
    CGRect scrollFrame = [self frameForPagingScrollView];
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_scrollView setDelegate:self];
    [_scrollView setBackgroundColor:[UIColor blackColor]];
    [_scrollView setAutoresizesSubviews:YES];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsVerticalScrollIndicator:YES];
    [_scrollView setShowsHorizontalScrollIndicator:YES];
    
    [_scrollView setAlwaysBounceHorizontal:NO];
    [_scrollView setAlwaysBounceVertical:NO];
    
    [self.view addSubview:_scrollView];
}

- (void)creatToolBarView {
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect toolbarFrame = CGRectMake(0,
                                     screenFrame.size.height - kBarHeight,
                                     screenFrame.size.width,
                                     kBarHeight);
    _toolBar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    [_toolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
     | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin];
    if (isiOS7) {
        _toolBar.barTintColor = KMainColor;
    }
    else {
        _toolBar.tintColor = KMainColor;
    }
    //下载（保存至相册）
    CGRect frame= CGRectMake(0, 0, 64, 60);
    UIButton *downloadBtn= [[UIButton alloc] initWithFrame:frame];
    [downloadBtn setImage:[UIImage imageNamed:@"CloudFileFoldManagerV_OutLine"]
                 forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *downloadBarItem = [[UIBarButtonItem alloc] initWithCustomView:downloadBtn];
    
    UIBarItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                     target:nil
                                                                     action:nil];
    [_toolBar setItems:@[space,downloadBarItem,space]];
    [self.view addSubview:_toolBar];
}

- (void)createTopBarView {
    _topStatusBarview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [_topStatusBarview setBackgroundColor:KMainColor];
    
    _topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    if (isiOS7) {
        _topBar.barTintColor = KMainColor;
    }
    else {
        _topBar.tintColor = KMainColor;
    }
    _topBar.barStyle = UIBarStyleDefault;
    _topBar.backgroundColor = KMainColor;
    _topBar.translucent = NO;
    
    //标题
    _imageTitle = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 0, 200, 44)];
    _imageTitle.textAlignment = NSTextAlignmentCenter;
    _imageTitle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _imageTitle.backgroundColor = [UIColor clearColor];
    [_imageTitle setTextColor:[UIColor whiteColor]];
    [_topBar addSubview:_imageTitle];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, _topBar.frame.size.height)];
    backBtn.backgroundColor = [UIColor clearColor];
    //[backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * btnImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm_arrow_back_white"]];
    NSInteger imageHeight = iPhone6Plus?31:26;
    [btnImageView setFrame:CGRectMake(5, (_topBar.frame.size.height-imageHeight)/2, 24, imageHeight)];
    [backBtn addSubview:btnImageView];
    [_topBar addSubview:backBtn];
    
    [self.view addSubview:_topBar];
    [self.view addSubview:_topStatusBarview];
}

- (CGRect)frameForPagingScrollView {
    CGRect frame = [self getScreenFrame];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    CGRect bounds = [self.scrollView bounds];
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (void)scrollToIndex:(NSInteger)index
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSize
{
    NSInteger pageCount = self.numberOfImages;
    if (pageCount == 0)
    {
        pageCount = 1;
    }
    CGSize size = CGSizeMake(self.scrollView.frame.size.width * pageCount,
                             self.scrollView.frame.size.height);
    // Cut in half to prevent horizontal scrolling.
    [self.scrollView setContentSize:size];
}


#pragma mark - Event Handle
- (void)downloadBtnClicked:(id)sender {
    
}

- (void)backBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoSingleClick:(UITapGestureRecognizer *)recognizer {
    //显示或隐藏状态栏和工具栏
    if (self.isShowAtFullScrean) {
        self.showAtFullScrean = NO;
        
    }
    else {
        self.showAtFullScrean = YES;
    }
}

- (void)photoDoubleClick:(UITapGestureRecognizer *)recognizer {
    ZCSPhotoShowView *currentImageView = (ZCSPhotoShowView *)recognizer.view;
    if ([currentImageView isKindOfClass:[ZCSPhotoShowView class]])
    {
        CGPoint location = [recognizer locationInView:currentImageView];
        [currentImageView zoomToLocation:location];
    }
}

- (void)setShowAtFullScrean:(BOOL)showAtFullScrean {
    _showAtFullScrean = showAtFullScrean;
    CGFloat alpha = showAtFullScrean ? 0.0 : 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        if ([[UIApplication sharedApplication]
             respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
            [[UIApplication sharedApplication] setStatusBarHidden:showAtFullScrean
                                                    withAnimation:UIStatusBarAnimationFade];
        }
        self.topStatusBarview.alpha = alpha;
        self.topBar.alpha = alpha;
        self.toolBar.alpha = alpha;
    }];
}

#pragma mark - 转屏调整
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.orientationMask;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    self.notAllowScrollInRotate = YES;
    self.rotateIndex = self.currentIndex;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
              withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.notAllowScrollInRotate = YES;
    self.rotateIndex = self.currentIndex;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        CGRect screenFrame = [self getScreenFrame];
        //[self adjustOriginalImageControl];
        CGFloat toolbarY = isiOS8 ? self.view.frame.size.height : screenFrame.size.height;
        CGRect toolbarFrame = CGRectMake(0,
                                         toolbarY - kBarHeight,
                                         screenFrame.size.width,
                                         kBarHeight);
        self.toolBar.frame = toolbarFrame;
        
        if(!isiOS7) {
            [self reSetTopbarFrame];
        }
        
        CGRect tempFrame = self.topStatusBarview.frame;
        tempFrame.size.width = screenFrame.size.width;
        self.topStatusBarview.frame = tempFrame;
        
        tempFrame = self.topBar.frame;
        tempFrame.size.width = screenFrame.size.width;
        self.topBar.frame = tempFrame;
        
        tempFrame = self.imageTitle.frame;
        tempFrame.origin.x = (screenFrame.size.width-200)/2;
        self.imageTitle.frame = tempFrame;
        
        CGRect scrollFrame = [self frameForPagingScrollView];
        self.scrollView.frame = scrollFrame;
        
        [self setScrollViewContentSize];
        
        [self.photoShowViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[ZCSPhotoShowView class]]) {
                ZCSPhotoShowView *showView = (ZCSPhotoShowView *)obj;
                showView.frame = [self frameForPageAtIndex:idx];
            }
        }];
        
    } completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.notAllowScrollInRotate = NO;
        if(self.rotateIndex != self.currentIndex)
        {
            [self scrollToIndex:self.rotateIndex];
        }
        else
        {
            [self scrollToIndex:self.currentIndex];
        }
        
    } completion:nil];
    
}

- ( void )layoutControllerSubViews
{
    if(!isiOS7)
    {
        [self reSetTopbarFrame];
    }
    
}

- ( void )reSetTopbarFrame
{
    //检测状态栏高度，适配打电话或者开热点的UI
    CGRect status_Rect = [[UIApplication sharedApplication] statusBarFrame];
    if ( status_Rect.size.height > STATE_BAR_HEIGHT)
    {
        [self.topBar setFrame:CGRectMake(0, 20+20, SCREEN_WIDTH, 44)];
    }
    else
    {
        [self.topBar setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    }
    
}

- (void)setIsTransformView:(BOOL)isTransformView {
    _isTransformView = isTransformView;
    AppDelegate * app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isTransform = isTransformView;
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    if(!isiOS8) {
        UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
        [self adaptUIBaseOnOriention:oriention];
    }
}

- (void)adaptUIBaseOnOriention:(UIInterfaceOrientation)oriention {
    if(oriention == UIInterfaceOrientationLandscapeLeft||
       oriention == UIInterfaceOrientationLandscapeRight)
    {
        _screenFrame = [[UIScreen mainScreen] bounds];
        _screenFrame.size.width = [[UIScreen mainScreen] bounds].size.height;
        _screenFrame.size.height = [[UIScreen mainScreen] bounds].size.width;
    }
    else
    {
        _screenFrame = [[UIScreen mainScreen] bounds];
    }
}

- (CGRect)getScreenFrame {
    if(isiOS8) {
        return [[UIScreen mainScreen] bounds];
    }
    else {
        return _screenFrame;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.notAllowScrollInRotate) {
        return;
    }
    
    NSInteger page = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    
    if (page != self.currentIndex && page >= 0 && page < self.numberOfImages)
    {
        [self setTitleForIndex:page];
        [self setImageForIndex:page];
    }
}

#pragma mark - Update title and image
- (void)setTitleForIndex:(NSInteger)index {
    id imageInfo = [self.imagesSource objectAtIndex:index];
    if (imageInfo) {
        NSString *imageName = [imageInfo valueForKeyPath:@"contentName"];
        if (imageName) {
            NSArray *nameArray = [imageName componentsSeparatedByString:@"."];
            NSString *titleStr = nil;
            if ([nameArray count] >= 2) {
                NSString *suffix = [nameArray lastObject];
                NSRange range = NSMakeRange(0, imageName.length-suffix.length-1);
                titleStr = [imageName substringWithRange:range];
                self.imageTitle.text = titleStr;
            }
            else {
                self.imageTitle.text = titleStr;
            }
        }
        else {
            NSString *titleStr = [NSString stringWithFormat:@"图片_%ld",(long)index];
            self.imageTitle.text = titleStr;
        }
    }
}

- (void)setImageForIndex:(NSInteger)index {
    NSInteger unloadIndex = -1;
    if (self.currentIndex > index) {
        unloadIndex = _currentIndex + 4;
    }
    else if (self.currentIndex < index){
        unloadIndex = _currentIndex - 4;
    }
    
    self.currentIndex = index;
    self.rotateIndex = index;
    [self loadImageWithIndex:_currentIndex];
    [self loadImageWithIndex:_currentIndex - 1];
    [self loadImageWithIndex:_currentIndex + 1];
    [self loadImageWithIndex:_currentIndex - 2];
    [self loadImageWithIndex:_currentIndex + 2];
    [self loadImageWithIndex:_currentIndex - 3];
    [self loadImageWithIndex:_currentIndex + 3];
    
    [self unloadImageWithIndex:unloadIndex];
}

- (void)loadImageWithIndex:(NSInteger)index {
    if (index < 0 || index >= self.numberOfImages) {
        return;
    }
    id showView = [self.photoShowViewArray objectAtIndex:index];
    if ([showView isKindOfClass:[ZCSPhotoShowView class]]) {
        ZCSPhotoShowView *photoShowView = (ZCSPhotoShowView *)showView;
        [photoShowView turnOffZoom];
    }
    else if ([showView isKindOfClass:[NSNull class]]) {
        CGRect frame = [self frameForPageAtIndex:index];
        ZCSPhotoShowView *photoShowView = [[ZCSPhotoShowView alloc] initWithFrame:frame];
        id imageInfo = [self.imagesSource objectAtIndex:index];
        if ([imageInfo isKindOfClass:[UIImage class]]) {
            [photoShowView setImage:imageInfo];
            [self.scrollView addSubview:photoShowView];
            [self.photoShowViewArray replaceObjectAtIndex:index withObject:photoShowView];
        }
        else {
            NSString *thumbnailUrl = [imageInfo valueForKeyPath:@"bigthumbnailURL"];
            if (thumbnailUrl == nil) {
                thumbnailUrl = [imageInfo valueForKeyPath:@"thumbnailURL"];
            }
            if (thumbnailUrl) {
                [photoShowView setImageWithURL:[NSURL URLWithString:thumbnailUrl] placeholderImage:nil];
                //单击
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(photoSingleClick:)];
                [photoShowView addGestureRecognizer:singleTap];
                //双击
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(photoDoubleClick:)];
                doubleTap.numberOfTapsRequired = 2;
                [photoShowView addGestureRecognizer:doubleTap];
                [singleTap requireGestureRecognizerToFail:doubleTap];
                
                [self.scrollView addSubview:photoShowView];
                [self.photoShowViewArray replaceObjectAtIndex:index withObject:photoShowView];
            }
        }
    }
}

- (void)unloadImageWithIndex:(NSInteger)index {
    if (index < 0 || index >= self.numberOfImages) {
        return;
    }
    id showView = [self.photoShowViewArray objectAtIndex:index];
    if ([showView isKindOfClass:[ZCSPhotoShowView class]]) {
        ZCSPhotoShowView *photoShowView = (ZCSPhotoShowView *)showView;
        [photoShowView removeFromSuperview];
        [self.photoShowViewArray replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}
@end
