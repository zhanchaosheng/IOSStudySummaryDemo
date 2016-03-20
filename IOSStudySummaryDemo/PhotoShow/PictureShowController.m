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
<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,
    PHPhotoLibraryChangeObserver,UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) BOOL bFetchByALAssetsLibrary;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) ALAssetsLibrary *assetLibrary;
@property (strong, nonatomic) NSMutableArray *alAssets;

@property (assign, nonatomic) BOOL bFetchByPhotoKit;
@property (assign, nonatomic) CGSize assetThumbnailSize;
@property (strong, nonatomic) NSArray *sectionFetchResults;
@property (strong, nonatomic) NSArray *sectionLocalizedTitles;
@property (strong, nonatomic) UITableView *tableView;

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
    
    //获取用户对该应用访问相册的授权状态（IOS6.0以上）
    ALAuthorizationStatus authForPhoto = [ALAssetsLibrary authorizationStatus];
    if (authForPhoto == ALAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝了应用访问相册!");
        return;
    }
    
    [self initViewForALAssetsLibrary];
    [self initViewForPhotoKit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    if (_bFetchByPhotoKit) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
    
    if (_bFetchByALAssetsLibrary) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)initViewForALAssetsLibrary
{
    CGRect rect = self.view.bounds;
    //创建CollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect
                                             collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.hidden = YES;
    //注册自定义collectionViewCell类
    [self.collectionView registerClass:[PictureCollectionViewCell class]
            forCellWithReuseIdentifier:@"PictureCollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
}

- (void)initViewForPhotoKit
{
    CGRect rect = self.view.bounds;
    rect.origin.y = 64;
    rect.size.height -= 64;
    self.tableView = [[UITableView alloc] initWithFrame:rect
                                                  style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;

    [self.view addSubview:self.tableView];
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
            self.bFetchByALAssetsLibrary = YES;
            self.bFetchByPhotoKit = NO;
            self.navigationItem.rightBarButtonItem.enabled = NO;
            self.collectionView.hidden = NO;
            //设置相册变化通知
            [self addAssetsLibraryChangedNotification];
            [self enumPictures];
            break;
        case 1:
            //使用PhotoKit获取照片
            self.bFetchByPhotoKit = YES;
            self.bFetchByALAssetsLibrary = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                   target:self
                                                                                                   action:@selector(addAlbumsAction:)];
            self.tableView.hidden = NO;
            //设置相册变化通知
            [self addAssetsLibraryChangedNotification];
            [self fetchPictureByPhotoKit];
            break;
        default:
            break;
    }
}

- (void)addAlbumsAction:(UIBarButtonItem *)sender
{
    // Prompt user from new album title.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"新相册名";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:NULL]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"创建"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields.firstObject;
        NSString *title = textField.text;
        if (title.length == 0) {
            return;
        }
        
        // Create a new album with the title entered.
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error creating album: %@", error);
            }
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
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
    if (self.bFetchByPhotoKit)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    
    if (self.bFetchByALAssetsLibrary)
    {
        if (self.assetLibrary == nil) {
            self.assetLibrary = [[ALAssetsLibrary alloc] init];
        }
        //通知ALAssetsLibraryChangedNotification在iOS5下面是不能正常工作的，这是iOS5的bug，
        //可以通过一个方法来修正。做法就是在创建了ALAssetsLibrary的实例之后，立刻执行下面一句
        if ([[UIDevice currentDevice].systemVersion floatValue] <= 5.0f)
        {
            [self.assetLibrary writeImageToSavedPhotosAlbum:nil
                                                   metadata:nil
                                            completionBlock:^(NSURL *assetURL, NSError *error) {}];
        }
        //添加相册变化通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(assetsLibraryDidChange:)
                                                     name:ALAssetsLibraryChangedNotification
                                                   object:self.assetLibrary];
    }
}

- (void)assetsLibraryDidChange:(NSNotification *)notification
{
    NSLog(@"本地相册有变化!(ALAsset)");
}
#pragma mark - PhotoKit
- (void)fetchPictureByPhotoKit
{
    // Create a PHFetchResult object for each section in the table view.
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = @[allPhotos, smartAlbums, topLevelUserCollections];
    self.sectionLocalizedTitles = @[@"", @"Smart Albums", @"Albums"];
    
    [self.tableView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.alAssets.count;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *myCell = (PictureCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCollectionViewCell" forIndexPath:indexPath];
    if (self.bFetchByALAssetsLibrary)
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        // The "All Photos" section only ever has a single row.
        numberOfRows = 1;
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[section];
        numberOfRows = fetchResult.count;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const AlbumsCellIdentifier = @"AlbumsCellIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumsCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:AlbumsCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"全部照片";
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
        PHCollection *collection = fetchResult[indexPath.row];
        cell.textLabel.text = collection.localizedTitle;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionLocalizedTitles[section];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态
}



#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
            [self.tableView reloadData];
        }
        
    });
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
