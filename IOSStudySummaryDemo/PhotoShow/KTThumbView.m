//
//  KTThumbView.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbView.h"
#import <QuartzCore/QuartzCore.h>

@implementation KTThumbView

- (id)initWithFrame:(CGRect)frame
{
   if (self = [super initWithFrame:frame]) 
   {
       [self addTarget:self
                action:@selector(didTouch:)
      forControlEvents:UIControlEventTouchUpInside];
       self.exclusiveTouch = YES;
       [self setClipsToBounds:YES];
       [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
       
       _belowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 16, 16)];
       _belowImageView.image = [UIImage imageNamed:@"upload_batch_default_assert"];
       _belowImageView.hidden = YES;
       [self addSubview:_belowImageView];
       
       _batchSelbelowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 16, 16)];
       _batchSelbelowImageView.image = [UIImage imageNamed:@"upload_batch_unselect_assert"];
       _batchSelbelowImageView.hidden = YES;
       [self addSubview:_batchSelbelowImageView];

       _myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CloudFileFoldPhotoV_SelectCell"]];

       _myImageView.frame = CGRectMake(3, 3, 16, 16);
       _myImageView.hidden = YES;
       [self addSubview:_myImageView];
   }
   return self;
}

- (void)didTouch:(id)sender 
{
   if (self.delegate)
   {
       BOOL isEditFlag = NO;
       if([self.delegate respondsToSelector:@selector(isEditButtonPress)])
       {
           isEditFlag = [self.delegate isEditButtonPress];
       }
       if (isEditFlag)
       {
       }
       else
       {
           if ([self.delegate respondsToSelector:@selector(didSelectThumbAtIndex:)])
           {
               [self.delegate didSelectThumbAtIndex:[self tag]];
           }
       }
   }
}

- (void)setSelec
{
    self.myImageView.hidden = !self.myImageView.hidden;
}

- (void)setAllSelect:(BOOL)selectFlag withBatchFlag:(BOOL)batchSelFlag
{
    if(selectFlag)
    {
        self.belowImageView.hidden = selectFlag;
        self.batchSelbelowImageView.hidden = selectFlag;
    }
    else
    {
        if(batchSelFlag)
        {
            self.belowImageView.hidden = YES;
            self.batchSelbelowImageView.hidden = selectFlag;
        }
        else
        {
            self.belowImageView.hidden = selectFlag;
            self.batchSelbelowImageView.hidden = YES;
        }
    }
}

- (void)setThumbImage:(UIImage *)newImage
{
    [self setImage:newImage forState:UIControlStateNormal];
}

@end
