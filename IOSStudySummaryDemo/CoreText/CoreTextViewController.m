//
//  CoreTextViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/10/9.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "CoreTextViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "UIView+frameAdjust.h"

@interface CoreTextViewController ()

@end

@implementation CoreTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"CoreText排版引擎";
    CTDisplayView * displayView = [[CTDisplayView alloc] initWithFrame:
                                   CGRectMake(4, 68, SCREEN_WIDTH-8, SCREEN_HEIGHT-68)];
    
//    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
//    config.textColor = [UIColor redColor];
//    config.width = displayView.width;
//    config.lineSpace = 10.0f;
//    
//    CoreTextData *data = [CTFrameParser parseContent:@" 按照以上原则，我们将`CTDisplayView`中的部分内容拆开。"
//                                              config:config];
    
    //根据文件模板进行排版
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = displayView.width;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
    
    displayView.data = data;
    displayView.height = data.height;
    displayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:displayView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
