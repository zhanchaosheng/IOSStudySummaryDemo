//
//  KTThumbView.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KTThumbViewDelegate <NSObject>
- (void)setSelect:(NSInteger)btnTag withMyImageHiddenType:(BOOL)isHidden;
- (void)didSelectThumbAtIndex:(NSUInteger)index;
- (BOOL)isEditButtonPress;
- (BOOL)isBatchSelAndOverLimit:(NSUInteger)index;
@end

//图片标示调整frame
typedef enum
{
    FLAG_INDEX_ONE = 0,  //第一个
    FLAG_INDEX_TWO,     //第二个
}Flag_index;

@interface KTThumbView : UIButton 
{

}

@property (nonatomic, retain) NSString *requestString;
@property (nonatomic, assign) id <KTThumbViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, assign) BOOL isEditButtonPressFlag;
@property (nonatomic, assign) BOOL isTimeLineFlag;
@property (nonatomic, strong) UIImageView *belowImageView;
@property (nonatomic, strong) UIImageView *batchSelbelowImageView;

- (id)initWithFrame:(CGRect)frame;
- (void)setThumbImage:(UIImage *)newImage;
- (void)setSelec;
- (void)setAllSelect:(BOOL)selectFlag withBatchFlag:(BOOL)batchSelFlag;

@end

