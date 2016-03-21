//
//  AlbumsCollectionViewController.h
//  mCloudSDCard_iPhone
//
//  Created by Cusen on 16/3/21.
//  Copyright © 2016年 epro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumsCollectionViewController : UICollectionViewController

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
