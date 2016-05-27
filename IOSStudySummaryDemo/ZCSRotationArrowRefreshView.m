//
//  ZCSRotationArrowRefreshView.m
//  IOSStudySummaryDemo
//
//  Created by zcs on 16/5/27.
//  Copyright © 2016年 huawei. All rights reserved.
//

/** 
 CAReplicatorLayer：复制图层,它可以实现一种效果：复制它的subLayer，并做一些有规律的调整，下面是它的一些属性说明：
 
 //指定实体的个数，如果为10，那么它的每个subLayer会被复制，都拥有10个实例
 instanceCount
 
 //修改复制出来的layer的动画时钟的延迟
 //通俗的讲，假如delay为1s，那么就会有这样的效果，如果我往它的sublayer添加一个动画，
 //这个sublayer的第一个副本的动画开始时间会是它本身1s之后执行，第二个副本的动画就是2s之后，依次类推
 instanceDelay
 
 //这个属性是CATransform3D类型，用来依次设置每一个复制的layer副本的偏移量
 //举个例子，假如该属性的值是CATransform3DMakeTranslation(100, 0, 0),第一个subLayer的x坐标假如是0，
 //第二个sublayer的x坐标就是100，依次类推
 instanceTransform
 
 //同上面的其他属性相似，设置颜色的偏差
 instanceColor
 */

#import "ZCSRotationArrowRefreshView.h"

@interface ZCSRotationArrowRefreshView()
@property (nonatomic, strong) CAReplicatorLayer *parLayer;
@property (nonatomic, strong) CAShapeLayer *arcLayer;
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@property (nonatomic, strong) UIBezierPath *startArrowPath;
@property (nonatomic, strong) UIBezierPath *endArrowPath;
@end

@implementation ZCSRotationArrowRefreshView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithRed:34/255.0 green:233/255.0 blue:123/255.0 alpha:1];
    [self initLayer];
    [self initPath];
}

- (void)initLayer {
    _parLayer = [CAReplicatorLayer layer];
    _parLayer.frame = self.bounds;
    _parLayer.instanceCount = 2;
    _parLayer.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.fillColor = [UIColor clearColor].CGColor;
    _arcLayer.strokeColor = [UIColor whiteColor].CGColor;
    _arcLayer.lineWidth = 3;
    _arcLayer.contentsScale = [UIScreen mainScreen].scale;
    _arcLayer.lineCap = kCALineCapRound;
    
    _arrowLayer = [CAShapeLayer layer];
    _arrowLayer.fillColor = [UIColor clearColor].CGColor;
    _arrowLayer.strokeColor = [UIColor whiteColor].CGColor;
    _arrowLayer.lineWidth = 3;
    _arrowLayer.lineCap = kCALineCapRound;
    _arrowLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [_parLayer addSublayer:_arcLayer];
    [_parLayer addSublayer:_arrowLayer];
    [self.layer addSublayer:_parLayer];
}

- (void)initPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)
                    radius:40
                startAngle:0
                  endAngle:M_PI_2*7/4
                 clockwise:YES];
    _arcLayer.path = path.CGPath;
    
    _startArrowPath = [UIBezierPath bezierPath];
    [_startArrowPath moveToPoint:CGPointMake(80, 54)];
    [_startArrowPath addLineToPoint:CGPointMake(90, 50)];
    [_startArrowPath addLineToPoint:CGPointMake(99, 56.5)];
    _arrowLayer.path = _startArrowPath.CGPath;
    
    //反箭头
//    _endArrowPath = [UIBezierPath bezierPath];
//    [_endArrowPath moveToPoint:CGPointMake(80, 42.5)];
//    [_endArrowPath addLineToPoint:CGPointMake(90, 50)];
//    [_endArrowPath addLineToPoint:CGPointMake(99, 44.5)];
}

- (void)beginAnimation {
    //旋转动画
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAnimation.fromValue = @(M_PI*2);
    baseAnimation.toValue = @(0);
    baseAnimation.duration = 2;
    baseAnimation.repeatCount = NSIntegerMax;
    [_parLayer addAnimation:baseAnimation forKey:@"baseAnimation"];
    
    //箭头方向变换动画
//    CAKeyframeAnimation *changeArroeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
//    changeArroeAnimation.values = @[(__bridge id)_startArrowPath.CGPath,
//                              (__bridge id)_endArrowPath.CGPath,
//                              (__bridge id)_endArrowPath.CGPath];
//    changeArroeAnimation.keyTimes = @[@(0.45),@.75,@.95];
//    changeArroeAnimation.autoreverses = YES;
//    changeArroeAnimation.repeatCount = NSIntegerMax;
//    changeArroeAnimation.duration = 1;
//    [_arrowLayer addAnimation:changeArroeAnimation forKey:@"changeArroeAnimation"];
}

- (void)stopAnimation {
    [self.parLayer removeAllAnimations];
    //[self.arrowLayer removeAllAnimations];
}
@end
