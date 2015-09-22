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

@interface PhotoBrowserController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//UIImagePickerController是UINavigationController的子类，所以这里一定要继承UINavigationControllerDelegate，否则编译器会警告
@property (strong, nonatomic) UIImageView *imageView; //显示图片
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *movieURL;
@property (copy, nonatomic) NSString *lastChosenMediaType;
@end

@implementation PhotoBrowserController

- (void)initView
{
    //图片来源：照片库或摄像头
    NSArray *btnArray = [NSArray arrayWithObjects:@"照片库",@"摄像头",nil];
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:btnArray];
    segmentedCtrl.frame = CGRectMake(5, SCREEN_HEIGHT - 55, SCREEN_WIDTH - 10, 50);
    segmentedCtrl.momentary = YES;//设置点击后是否恢复原样
    [segmentedCtrl addTarget:self
                      action:@selector(segmentCtrlHandle:)
            forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrl];
    
    //判断设备是否有摄像头
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [segmentedCtrl setEnabled:NO forSegmentAtIndex:1];
    }
    
    //图片显示视图
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,SCREEN_HEIGHT-80)];
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"图片浏览器";
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //视图显示出来时刷新图像或录像的播放
    [self updateDisplay];
}

- (void)segmentCtrlHandle:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        //用户将从现有的媒体库中选择照片或视频。照片将被返回到委托。
        [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else
    {
        //用户使用内置摄像头拍照或录像
        [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    }
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
        
        self.image = [self shrinkImage:chosenImage toSize:self.imageView.bounds.size];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
