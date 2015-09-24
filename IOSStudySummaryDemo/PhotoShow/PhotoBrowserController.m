//
//  PhotoBrowserController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/9/22.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "PhotoBrowserController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface PhotoBrowserController ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
//UIImagePickerController是UINavigationController的子类，所以这里一定要继承UINavigationControllerDelegate，否则编译器会警告

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView; //显示图片
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *movieURL;
@property (copy, nonatomic) NSString *lastChosenMediaType;
@property (nonatomic, assign) BOOL bCameraEnable;

@end

@implementation PhotoBrowserController

- (void)initView
{
    //判断设备是否有摄像头
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.bCameraEnable = YES;
    }
    //图片显示视图
    self.imageView = [[UIImageView alloc] initWithFrame:
                      CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    self.imageView.backgroundColor = [UIColor yellowColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;//图片自适应
    
    //初始化scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:
                   CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    //如果scrollView的父视图被导航条控制则必须设置以下属性
    self.scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.zoomScale = 1.0;
    
    [_scrollView addSubview:_imageView];
    [self.view addSubview:_scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"图片浏览器";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                           target:self
                                                                                           action:@selector(rightBarBtnClicked:)];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarBtnClicked:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet;
    if (self.bCameraEnable)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"照片源选择"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"照片库",@"摄像头",nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"照片源选择"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"照片库",nil];
    }
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //用户将从现有的媒体库中选择照片或视频。照片将被返回到委托。
            [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 1:
            //用户使用内置摄像头拍照或录像
            if (self.bCameraEnable)
            {
                [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
            }
            break;
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //视图显示出来时刷新图像或录像的播放
    [self updateDisplay];
}

//UIImagePickerControllerSourceType:
// UIImagePickerControllerSourceTypePhotoLibrary 用户将从现有的媒体库中选择照片或视频。照片将被返回到委托
// UIImagePickerControllerSourceTypeCamera 用户使用内置摄像头拍照或录像
// UIImagePickerControllerSourceTypeSavedPhotosAlbum 用户将从现有照片库中选择照片，但选择范围仅限于最近使用的相册
- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
        mediaTypes.count > 0)
    {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        //picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing media"
                                                        message:@"Unsupported media source."
                                                       delegate:nil
                                              cancelButtonTitle:@"Drat"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)updateDisplay
{
    //判断选择返回的mediaType类型
    if ([self.lastChosenMediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.imageView.image = self.image;
        self.imageView.hidden = NO;
        self.moviePlayerController.view.hidden = YES;
    }
    else if ([self.lastChosenMediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        [self.moviePlayerController.view removeFromSuperview];
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.movieURL];
        [self.moviePlayerController play];
        UIView *movieView = self.moviePlayerController.view;
        movieView.frame = self.imageView.frame;
        movieView.clipsToBounds = YES;
        [self.view addSubview:movieView];
        self.imageView.hidden = YES;
    }
}

- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGFloat originalAspect = original.size.width / original.size.height;
    CGFloat targetAspect = size.width / size.height;
    CGRect targetRect;
    if (originalAspect > targetAspect)
    {
        targetRect.size.width = size.width;
        targetRect.size.height = size.height * targetAspect / originalAspect;
        targetRect.origin.x = 0;
        targetRect.origin.y = (size.height - targetRect.size.height) * 0.5;
    }
    else if (originalAspect < targetAspect)
    {
        targetRect.size.width = size.width * originalAspect / targetAspect;
        targetRect.size.height = size.height;
        targetRect.origin.x = (size.width - targetRect.size.width) * 0.5;
        targetRect.origin.y = 0;
    }
    else
    {
        targetRect = CGRectMake(0, 0, size.width, size.height);
    }
    
    [original drawInRect:targetRect];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    if ([self.lastChosenMediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *chosenImage;
        if (picker.allowsEditing)
        {
            chosenImage = info[UIImagePickerControllerEditedImage];
        }
        else
        {
            chosenImage = info[UIImagePickerControllerOriginalImage];
        }
        
        self.image = chosenImage;//[self shrinkImage:chosenImage toSize:self.imageView.bounds.size];
    }
    else if ([self.lastChosenMediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        self.movieURL = info[UIImagePickerControllerMediaURL];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x;
    CGFloat ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    self.imageView.center = CGPointMake(xcenter, ycenter);
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
