//
//  KTCollectionViewCell.h
//  mCloud_iPhone
//
//  Created by Cusen on 15/11/9.
//  Copyright (c) 2015年 epro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) UIImageView *livePhotoBadgeImageView;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@end
