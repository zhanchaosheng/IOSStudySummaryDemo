//
//  firstViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/24.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "firstViewController.h"
#import "secondViewController.h"
#import "ZCSAnimatorTransitioning.h"

@interface firstViewController ()

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"第一个";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"second"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightBarButtonClicked:)];

    //设置下一个ViewController返回按钮的title和Image
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] init];
    backBarBtn.title = @"first";
    self.navigationItem.backBarButtonItem = backBarBtn;
    
    //重新设置delegate并实现gestureRecognizerShouldBegin:
    //解决在secondViewController中设置了自定义leftBarButtonItem而导致左边缘右滑返回失效的问题
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonClicked:(UIBarButtonItem *)sender
{
    secondViewController *secondViewCtrl = [[secondViewController alloc] initWithDelegate:(ZCSAnimatorTransitioning *)self.navigationController.delegate];
    [self.navigationController pushViewController:secondViewCtrl animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    return  YES;
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
