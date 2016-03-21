//
//  KTCollectionReusableView.m
//  mCloud_iPhone
//
//  Created by Cusen on 15/11/9.
//  Copyright (c) 2015年 cusen. All rights reserved.
//

#import "KTCollectionReusableView.h"

@implementation KTCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.8f;
         _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 150, 30)];
        [self addSubview:_title];

//        _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        _selectBtn.frame = CGRectMake(self.bounds.size.width - 85 , 6, 65, 30);
//        _selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [_selectBtn setTitle:@"选择" forState:UIControlStateNormal];
//        [_selectBtn setTintColor:[UIColor blueColor]];
//        [_selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_selectBtn];
//        _selectBtn.hidden = YES;
    }
    return self;
}

//- (void)selectBtnClicked:(UIButton *)sender
//{
//    if ([sender.titleLabel.text isEqualToString:@"选择"])
//    {
//        self.selceted = NO;
//    }
//    else
//    {
//        self.selceted = YES;
//    }
//}
//
//- (void)setSelceted:(BOOL)sel
//{
//    _selceted = sel;
//    if (_selceted)
//    {
//        [self.selectBtn setTitle:@"选择" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.selectBtn setTitle:@"取消选择" forState:UIControlStateNormal];
//    }
//}
@end
