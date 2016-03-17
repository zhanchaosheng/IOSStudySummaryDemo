//
//  PictureShowController.m
//  IOSStudySummaryDemo
//
//  说明：使用AssetsLibrary、PhotoKit（IOS8）访问相册遍历照片，使用UICollectionView将照片展示出来
//
//  Created by Cusen on 15/10/3.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import "PictureShowController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PictureCollectionViewCell.h"
#import <Photos/Photos.h>


@interface PictureShowController ()
<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,
    PHPhotoLibraryChangeObserver>

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) ALAssetsLibrary *assetLibrary;
@property (strong,nonatomic) NSMutableArray *alAssets;

@property (assign,nonatomic) BOOL bFetchByPhotoKit;
@property (strong,nonatomic) PHFetchResult *assetsFetchResults;
@property (strong,nonatomic) PHCachingImageManager *phImageMgr;
@property (assign,nonatomic) CGSize assetThumbnailSize;

@end

@implementation PictureShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"照片展示";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"框架选择"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(libSelectBtnClicked:)];
    
    //初始化照片显示界面
    [self initView];
    
    //获取用户对该应用访问相册的授权状态（IOS6.0以上）
    ALAuthorizationStatus authForPhoto = [ALAssetsLibrary authorizationStatus];
    if (authForPhoto == ALAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝了应用访问相册!");
        return;
    }
    
    //设置相册变化通知
    [self addAssetsLibraryChangedNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
//    if (_bFetchByPhotoKit) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
//    }
//    else {
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize;
    self.assetThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
}

- (void)initView
{
    //创建CollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    //注册自定义collectionViewCell类
    [self.collectionView registerClass:[PictureCollectionViewCell class]
            forCellWithReuseIdentifier:@"PictureCollectionViewCell"];
}
- (void)libSelectBtnClicked:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"相册框架选择"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"AssetsLibrary",@"PhotoKit",nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //使用AssetsLibrary获取照片
            self.bFetchByPhotoKit = NO;
            [self enumPictures];
            break;
        case 1:
            self.bFetchByPhotoKit = YES;
            [self fetchPictureByPhotoKit];
            break;
        default:
            break;
    }
}

#pragma mark - AssetsLibrary
//遍历照片
- (void)enumPictures
{
    if (self.alAssets) {
        [self.alAssets removeAllObjects];
    }
    else{
        self.alAssets = [NSMutableArray array];
    }
    if (self.assetLibrary == nil) {
        self.assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    NSMutableArray *groupArray = [NSMutableArray arrayWithCapacity:1];
    //获取所有相册，通过ALAssetsLibrary的实例方法得到ALAssetsGroup类数组
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos//相机胶卷
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    if (group)
                                    {
                                        [groupArray addObject:group];
                                        NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                                        NSInteger numAsset = [group numberOfAssets];
                                        NSLog(@"相册%ld:%@ %ld",groupArray.count,groupName,numAsset);
                                        
                                        //根据相册获取该相册下所有图片，通过ALAssetsGroup的实例方法得到ALAsset类数组
                                        //按顺便遍历获取相册中所有的资源，index代表资源的索引，stop赋值为false时，会停止遍历
                                        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                            if (result)
                                            {
                                                //ALAssetRepresentation类，获取该资源图片的详细资源信息
                                                ALAssetRepresentation *representation = [result defaultRepresentation];
                                                //NSURL * assetUrl = [representation url];
                                                NSString *assetName = [representation filename];
                                                [self.alAssets addObject:result];
                                                NSLog(@"照片%ld:%@",self.alAssets.count,assetName);
                                            }
                                        }];
                                    }
                                    else
                                    {
                                        //相册遍历结束刷新界面
                                        [self.collectionView reloadData];
                                    }
                                }
                              failureBlock:^(NSError *error) {
                                  NSLog(@"遍历相册出错!");
                              }];
}

//设置相册变化通知
- (void)addAssetsLibraryChangedNotification
{
//    if (self.bFetchByPhotoKit)
//    {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
//    }
//    else
//    {
//        if (self.assetLibrary == nil) {
//            self.assetLibrary = [[ALAssetsLibrary alloc] init];
//        }
//        //通知ALAssetsLibraryChangedNotification在iOS5下面是不能正常工作的，这是iOS5的bug，
//        //可以通过一个方法来修正。做法就是在创建了ALAssetsLibrary的实例之后，立刻执行下面一句
//        if ([[UIDevice currentDevice].systemVersion floatValue] <= 5.0f)
//        {
//            [self.assetLibrary writeImageToSavedPhotosAlbum:nil
//                                                   metadata:nil
//                                            completionBlock:^(NSURL *assetURL, NSError *error) {}];
//        }
//        //添加相册变化通知
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(assetsLibraryDidChange:)
//                                                     name:ALAssetsLibraryChangedNotification
//                                                   object:self.assetLibrary];
//    }
}

- (void)assetsLibraryDidChange:(NSNotification *)notification
{
    NSLog(@"本地相册有变化!(ALAsset)");
}
#pragma mark - PhotoKit
- (void)fetchPictureByPhotoKit
{
    if (self.phImageMgr == nil) {
        self.phImageMgr = [[PHCachingImageManager alloc] init];
    }
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    [self.collectionView reloadData];
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    NSLog(@"本地相册有变化!(PHAsset)");
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.bFetchByPhotoKit)
    {
        return self.assetsFetchResults.count;
    }
    return self.alAssets.count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *myCell = (PictureCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCollectionViewCell" forIndexPath:indexPath];
    if (self.bFetchByPhotoKit)
    {
        PHAsset *asset = self.assetsFetchResults[indexPath.row];
        if (asset)
        {
            myCell.representedAssetIdentifier = asset.localIdentifier;
            
            [self.phImageMgr requestImageForAsset:asset
                                       targetSize:self.assetThumbnailSize
                                      contentMode:PHImageContentModeAspectFill
                                          options:nil
                                    resultHandler:^(UIImage *result, NSDictionary *info) {
                                        if ([myCell.representedAssetIdentifier isEqualToString:asset.localIdentifier])
                                        {
                                            myCell.imageView.image = result;
                                        }
                                    }];
        }
    }
    else
    {
        ALAsset *asset = self.alAssets[indexPath.row];
        if (asset) {
            //加载图片
            myCell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
//            [self.assetLibrary assetForURL:assetUrl
//                               resultBlock:^(ALAsset *asset) {
//                                   myCell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
//                               }
//                              failureBlock:^(NSError *error) {
//                                  NSLog(@"%@",error);
//                              }];
        }
    }
    
    return myCell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *msg = [NSString stringWithFormat:@"Select Item At %ld ",(long)indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"yes,I do"
                                          otherButtonTitles:nil];
    [alert show];
    return;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectViewDelegeteLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = self.view.bounds;
    CGFloat cellWidth = (rect.size.width-5)/4;
    return CGSizeMake(cellWidth, 55+15);
}

//定义每个UICollectionView 的间距（返回UIEdgeInsets：上、左、下、右）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

//定义每个UICollectionView 纵向的间距（同一行相邻cell之间的距离）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

//定义每个UICollectionView 横向的间距（同一列相邻cell之间的距离）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
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
