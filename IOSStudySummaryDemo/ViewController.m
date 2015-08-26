//
//  ViewController.m
//  IOSStudySummaryDemo
//
//  Created by Cusen on 15/8/20.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "ViewController.h"
#import "customView.h"
#import <objc/runtime.h>
#import "UIView+ZCSAssociatedObjc.h"

@interface ViewController ()<ZCSViewCallBackProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//	[self gradientColorView];
//	[self encode];
//	[self gAffineTransform];
	
	customView *myView = [[customView alloc] initWithFrame:self.view.bounds];
	myView.delegate = self;
	[self.view addSubview:myView];
	
//	[self associatedObject];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - ZCSViewCallBackProtocol
- (void)showStartEvent
{
	NSLog(@"ShowStartEvent!");
}

- (void)showMoveEvent
{
	NSLog(@"ShowMoveEvent!");
}

- (void)showEndEvent
{
	NSLog(@"ShowEndEvent!");
}


#pragma mark - @encode()
- (void)encode
{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"key1",
						 [NSNumber numberWithDouble:1.00f],@"key2",
						 [NSNumber numberWithInt:1],@"key3",
						 [NSNumber numberWithFloat:33.0f], @"key4",
						 nil];
	for(NSString *key in dic)
	{
		id value = [dic valueForKey:key];
		if([value isKindOfClass:[NSNumber class]])
		{
			const char * pObjCType = [((NSNumber*)value) objCType];
			if (strcmp(pObjCType, @encode(int))  == 0)
			{
				NSLog(@"字典中key=%@的值是int类型,值为%d",key,[value intValue]);
			}
			if (strcmp(pObjCType, @encode(float)) == 0)
			{
				NSLog(@"字典中key=%@的值是float类型,值为%f",key,[value floatValue]);
			}
			if (strcmp(pObjCType, @encode(double))  == 0)
			{
				NSLog(@"字典中key=%@的值是double类型,值为%f",key,[value doubleValue]);
			}
			if (strcmp(pObjCType, @encode(BOOL)) == 0)
			{
				NSLog(@"字典中key=%@的值是bool类型,值为%i",key,[value boolValue]);
			}
			if (strcmp(pObjCType, @encode(char)) == 0)
			{
				NSLog(@"字典中key=%@的值是bool类型,值为%i",key,[value boolValue]);
			}
		}
		
	}
}

#pragma mark - CAGradientLayer颜色渐变层
- (void)gradientColorView
{
	//CAGradientLayer可以方便的处理颜色渐变
	UIView *myView = [[UIView alloc] initWithFrame:self.view.bounds];
	myView.backgroundColor = [UIColor whiteColor];
	
	CAGradientLayer *subLayer = [CAGradientLayer layer];
	subLayer.frame = myView.bounds;
	
	//渐变颜色组
	NSArray *colorArray = [NSArray arrayWithObjects:(id)[UIColor redColor].CGColor,
						   (id)[UIColor greenColor].CGColor,
						   (id)[UIColor blueColor].CGColor,
						   (id)[UIColor purpleColor].CGColor,
						   nil];
	subLayer.colors = colorArray;
	
	//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布。
	NSArray *locationArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
							  [NSNumber numberWithFloat:0.3],
							  [NSNumber numberWithFloat:0.8],
							  [NSNumber numberWithFloat:1.0],
							  nil];
	subLayer.locations = locationArray;
	
	//映射locations中第一个位置，用单位向量表示，比如（0，0）表示从左上角开始变化。默认值是(0.5,0.0)。
	subLayer.startPoint = CGPointMake(1, 0);
	
	//映射locations中最后一个位置，用单位向量表示，比如（1，1）表示到右下角变化结束。默认值是(0.5,1.0)。
	subLayer.endPoint = CGPointMake(0, 1);
	
	//默认值是kCAGradientLayerAxial，表示按像素均匀变化。除了默认值也无其它选项。
	subLayer.type = kCAGradientLayerAxial;
	
	[myView.layer addSublayer:subLayer];
	[self.view addSubview:myView];
}

#pragma mark - CGAffineTransform仿射变换
- (void)gAffineTransform
{
	CGRect myRect = CGRectMake(50,150,200,50);
	UIView *myView = [[UIView alloc] initWithFrame:myRect];
	myView.backgroundColor = [UIColor redColor];
	[self.view addSubview:myView];
 
	//创建一个CGAffineTransform变量，仿射变换可以用于平移、旋转、缩放变换路径或者图形上下文
	CGAffineTransform transform = myView.transform;
	transform = CGAffineTransformRotate(transform,3.14/4);//这里选择使用旋转功能
	myView.transform = transform;
	[self.view addSubview:myView];
}

#pragma mark - 关联对象
- (void)associatedObject
{
	self.view.associatedString = @"this is a associatedString!";
	NSLog(@"%@",self.view.associatedString);
	
	static char overStr;
	NSArray *array = @[@"111",@"222",@"333"];
	NSString *asscoiatedString = @"444";
	objc_setAssociatedObject(array, &overStr, asscoiatedString, OBJC_ASSOCIATION_RETAIN);
	NSLog(@"%@",asscoiatedString);
	NSLog(@"%@",array);
	NSString *retStr = objc_getAssociatedObject(array, &overStr);
	NSLog(@"%@",retStr);
	objc_removeAssociatedObjects(array);
}
@end
