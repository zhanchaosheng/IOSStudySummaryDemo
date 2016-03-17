//
//  PictureCollectionViewCell.h
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/6.
//  Copyright © 2015年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) NSString *representedAssetIdentifier;
@end
